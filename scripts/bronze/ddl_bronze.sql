DROP TABLE IF EXISTS bronze.ma_spotify_track_2009_2023;
CREATE TABLE bronze.ma_spotify_track_2009_2023(
    track_id TEXT,
    track_name TEXT,
    track_number TEXT,
    track_popularity TEXT,
	track_duration_ms TEXT,
    explicit TEXT,
    artist_name TEXT,
    artist_popularity TEXT,
    artist_followers TEXT,
    artist_genres TEXT,
    album_id TEXT,
	album_name TEXT,
	album_release_date TEXT,
	album_total_tracks TEXT,
	album_type TEXT
);

DROP TABLE IF EXISTS bronze.ma_spotify_track_2025;
CREATE TABLE bronze.ma_spotify_track_2025(
    track_id            TEXT,
    track_name          TEXT,
    track_number        TEXT,
    track_popularity    TEXT,
    explicit            TEXT,
    artist_name         TEXT,
    artist_popularity   TEXT,
    artist_followers    TEXT,
    artist_genres       TEXT,
	album_id            TEXT,
    album_name          TEXT,
    album_release_date  TEXT,
    album_total_tracks  TEXT,
    album_type          TEXT,
    track_duration_min  TEXT
);