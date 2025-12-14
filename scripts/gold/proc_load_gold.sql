CREATE OR REPLACE PROCEDURE gold.load_gold()
LANGUAGE plpgsql
AS $$
BEGIN

    RAISE NOTICE 'Creating gold.dim_artist view';
    CREATE OR REPLACE VIEW gold.dim_artist AS
    SELECT DISTINCT
        a.artist_id,
        a.artist_name,
        a.artist_popularity,
        a.artist_followers
    FROM silver.ma_artist as a
	INNER JOIN silver.ma_track as t
	ON a.artist_id = t.artist_id
	INNER JOIN silver.ma_album as b
	ON t.album_id = b.album_id
	WHERE EXTRACT(YEAR FROM album_release_date) >1999 ;

    RAISE NOTICE 'Creating gold.dim_album view';
    CREATE OR REPLACE VIEW gold.dim_album AS
    SELECT
        album_id,
        album_name,
        album_release_date,
        album_total_tracks,
        album_type
    FROM silver.ma_album;

    RAISE NOTICE 'Creating gold.dim_genre view';
    CREATE OR REPLACE VIEW gold.dim_genre AS
    SELECT
        genre_id,
        genre AS genre_name
    FROM silver.ma_genre;


    RAISE NOTICE 'Creating gold.fact_track view';
    CREATE OR REPLACE VIEW gold.fact_track AS
    SELECT
        track_id,
        track_name,
        track_number,
        track_popularity,
        track_duration_ms,
        explicit,
        artist_id,
        album_id
    FROM silver.ma_track;


    RAISE NOTICE 'Creating gold.bridge_track_genre view';
    CREATE OR REPLACE VIEW gold.bridge_track_genre AS
    SELECT
        t.track_id,
        g.genre_id
    FROM silver.ma_track t
    JOIN silver.ma_artist_genre ag
        ON ag.artist_id = t.artist_id
    JOIN silver.ma_genre g
        ON g.genre_id = ag.genre_id;

    RAISE NOTICE 'Gold layer view creation complete.';
END;
$$;

CALL gold.load_gold();