CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'Truncating Silver layer Tables';
    TRUNCATE TABLE silver.ma_artist_genre,
                   silver.ma_track,
                   silver.ma_genre,
                   silver.ma_album,
                   silver.ma_artist;

    RAISE NOTICE 'Inserting in ma_artist table';
    INSERT INTO silver.ma_artist(artist_name, artist_popularity, artist_followers)
    SELECT DISTINCT 
        TRIM(artist_name),
        artist_popularity::INT,
        artist_followers::INT
    FROM bronze.ma_spotify_track_a
    WHERE artist_popularity IS NOT NULL 
      AND artist_followers IS NOT NULL
      AND artist_name IS NOT NULL
    UNION
    SELECT DISTINCT
        TRIM(artist_name),
        artist_popularity::INT,
        artist_followers::INT
    FROM bronze.ma_spotify_track_b
    WHERE artist_popularity IS NOT NULL 
      AND artist_followers IS NOT NULL
      AND artist_name IS NOT NULL;

    RAISE NOTICE 'Inserting in ma_album table';
    INSERT INTO silver.ma_album
    SELECT DISTINCT
        album_id,
        album_name,
        (DATE '1899-12-30' + album_release_date::INT),
        album_total_tracks::INT,
        album_type
    FROM bronze.ma_spotify_track_a
    WHERE album_id IS NOT NULL
      AND album_name IS NOT NULL
      AND album_total_tracks IS NOT NULL
      AND album_type IS NOT NULL
      AND album_release_date IS NOT NULL
      AND album_release_date ~ '^[0-9]*$'
    UNION
    SELECT DISTINCT
        album_id,
        album_name,
        (DATE '1899-12-30' + album_release_date::INT),
        album_total_tracks::INT,
        album_type
    FROM bronze.ma_spotify_track_b
    WHERE album_id IS NOT NULL
      AND album_name IS NOT NULL
      AND album_total_tracks IS NOT NULL
      AND album_type IS NOT NULL
      AND album_release_date IS NOT NULL
      AND album_release_date ~ '^[0-9]*$'
    ON CONFLICT(album_id) DO NOTHING;

    RAISE NOTICE 'Inserting in ma_genre table';
    INSERT INTO silver.ma_genre (genre)
    SELECT DISTINCT
        TRIM(BOTH '''"' FROM REGEXP_SPLIT_TO_TABLE(
            REPLACE(REPLACE(artist_genres, '[', ''), ']', ''),
            '\s*,\s*'
        )) AS genre
    FROM bronze.ma_spotify_track_a
    WHERE artist_genres IS NOT NULL AND artist_genres <> '[]'
    UNION
    SELECT DISTINCT
        TRIM(BOTH '''"' FROM REGEXP_SPLIT_TO_TABLE(
            REPLACE(REPLACE(artist_genres, '[', ''), ']', ''),
            '\s*,\s*'
        ))
    FROM bronze.ma_spotify_track_b
    WHERE artist_genres IS NOT NULL AND artist_genres <> '[]';

    RAISE NOTICE 'Inserting in ma_track table';
    INSERT INTO silver.ma_track
    SELECT
        b.track_id,
        TRIM(b.track_name),
        b.track_number::INT,
        b.track_popularity::INT,
        b.track_duration_ms::INT,
        b.explicit::BOOLEAN,
        a.artist_id,
        b.album_id
    FROM bronze.ma_spotify_track_a b
    JOIN silver.ma_artist a
        ON TRIM(b.artist_name) = a.artist_name
    WHERE 
          b.track_id IS NOT NULL AND TRIM(b.track_id) <> ''
      AND b.track_name IS NOT NULL AND TRIM(b.track_name) <> ''
      AND b.track_number IS NOT NULL
      AND b.track_popularity IS NOT NULL
      AND b.track_duration_ms IS NOT NULL
      AND b.explicit IS NOT NULL
      AND b.album_id IS NOT NULL AND TRIM(b.album_id) <> ''

    UNION

    SELECT
        b.track_id,
        TRIM(b.track_name),
        b.track_number::INT,
        b.track_popularity::INT,
        ROUND(b.track_duration_min::NUMERIC * 60000)::INT,
        b.explicit::BOOLEAN,
        a.artist_id,
        b.album_id
    FROM bronze.ma_spotify_track_b b
    JOIN silver.ma_artist a
        ON TRIM(b.artist_name) = a.artist_name
    WHERE 
          b.track_id IS NOT NULL AND TRIM(b.track_id) <> ''
      AND b.track_name IS NOT NULL AND TRIM(b.track_name) <> ''
      AND b.track_number IS NOT NULL
      AND b.track_popularity IS NOT NULL
      AND b.track_duration_min IS NOT NULL
      AND b.explicit IS NOT NULL
      AND b.album_id IS NOT NULL AND TRIM(b.album_id) <> ''
	ON CONFLICT(track_id) DO NOTHING;

    RAISE NOTICE 'Inserting in ma_artist_genre table';
    INSERT INTO silver.ma_artist_genre
    SELECT DISTINCT
        a.artist_id,
        g.genre_id
    FROM bronze.ma_spotify_track_a b
    JOIN silver.ma_artist a
        ON TRIM(b.artist_name) = a.artist_name
    CROSS JOIN LATERAL (
        SELECT TRIM(BOTH '''"' FROM value) AS genre
        FROM REGEXP_SPLIT_TO_TABLE(
                REPLACE(REPLACE(b.artist_genres, '[', ''), ']', ''),
                '\s*,\s*'
        ) AS value
    ) s
    JOIN silver.ma_genre g
        ON g.genre = s.genre
    WHERE b.artist_genres IS NOT NULL AND b.artist_genres <> '[]'

    UNION

    SELECT DISTINCT
        a.artist_id,
        g.genre_id
    FROM bronze.ma_spotify_track_b b
    JOIN silver.ma_artist a
        ON TRIM(b.artist_name) = a.artist_name
    CROSS JOIN LATERAL (
        SELECT TRIM(BOTH '''"' FROM value) AS genre
        FROM REGEXP_SPLIT_TO_TABLE(
                REPLACE(REPLACE(b.artist_genres, '[', ''), ']', ''),
                '\s*,\s*'
        ) AS value
    ) s
    JOIN silver.ma_genre g
        ON g.genre = s.genre
    WHERE b.artist_genres IS NOT NULL AND b.artist_genres <> '[]'
	ON CONFLICT(artist_id, genre_id) DO NOTHING;

    RAISE NOTICE 'Silver layer load complete.';

END $$;


CALL silver.load_silver();