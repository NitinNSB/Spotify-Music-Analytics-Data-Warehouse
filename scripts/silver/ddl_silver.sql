
DROP TABLE IF EXISTS silver.ma_artist_genre;
DROP TABLE IF EXISTS silver.ma_track;
DROP TABLE IF EXISTS silver.ma_genre;
DROP TABLE IF EXISTS silver.ma_album;
DROP TABLE IF EXISTS silver.ma_artist;

CREATE TABLE silver.ma_artist(
    artist_id SERIAL,
	artist_name VARCHAR(200) NOT NULL,
	artist_popularity INT NOT NULL,
	artist_followers INT NOT NULL,
	CONSTRAINT ma_artist_pkey
	PRIMARY KEY(artist_id)
);


CREATE TABLE silver.ma_album(
    album_id VARCHAR(30) NOT NULL,
	album_name VARCHAR(200) NOT NULL,
	album_release_date DATE NOT NULL,
	album_total_tracks INT NOT NULL,
	album_type VARCHAR(30) NOT NULL,
	CONSTRAINT ma_album_pkey
	PRIMARY KEY(album_id)
);


CREATE TABLE silver.ma_genre(
    genre_id SERIAL NOT NULL,
	genre VARCHAR(30) NOT NULL,
	CONSTRAINT ma_genre_pkey
	PRIMARY KEY(genre_id)
);


CREATE TABLE silver.ma_track(
    track_id VARCHAR(30) NOT NULL,
    track_name VARCHAR(200) NOT NULL,
    track_number INT NOT NULL,
    track_popularity INT NOT NULL,
    track_duration_ms INT NOT NULL,
    explicit BOOLEAN NOT NULL,
    artist_id INT NOT NULL,
    album_id  VARCHAR(30) NOT NULL,
	CONSTRAINT ma_track_pkey PRIMARY KEY(track_id),
	CONSTRAINT fkey_ma_artist FOREIGN KEY(artist_id)
	REFERENCES silver.ma_artist(artist_id),
	CONSTRAINT fkey_album FOREIGN KEY(album_id)
	REFERENCES silver.ma_album(album_id)
);


CREATE TABLE silver.ma_artist_genre(
    artist_id INT NOT NULL,
    genre_id INT NOT NULL,
	CONSTRAINT artist_genre_pkey PRIMARY KEY(artist_id, genre_id),
	CONSTRAINT fkey_ma_artist_bridge FOREIGN KEY(artist_id)
	REFERENCES silver.ma_artist(artist_id),
	CONSTRAINT fkey_ma_genre FOREIGN KEY(genre_id)
	REFERENCES silver.ma_genre(genre_id)
);
