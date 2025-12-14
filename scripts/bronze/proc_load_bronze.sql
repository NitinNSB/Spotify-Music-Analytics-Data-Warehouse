CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE '   Loading Bronze Layer';
    RAISE NOTICE '========================================';

    RAISE NOTICE '------ Loading ma_spotify_track_a Table ------';

    TRUNCATE TABLE bronze.ma_spotify_track_a;
    COPY bronze.ma_spotify_track_a
    FROM 'D:\\Projects\\sql-data-warehouse-project-main\\datasets\\source_MA\\spotify_track_a.csv'
    CSV HEADER ENCODING 'LATIN1';

    RAISE NOTICE '------ Loading ma_spotify_track_b Tables ------';

    TRUNCATE TABLE bronze.ma_spotify_track_b;
    COPY bronze.ma_spotify_track_b
    FROM 'D:\\Projects\\sql-data-warehouse-project-main\\datasets\\source_MA\\spotify_track_b.csv'
    CSV HEADER ENCODING 'LATIN1';


    RAISE NOTICE '========================================';
    RAISE NOTICE ' Bronze Layer Load Completed';
    RAISE NOTICE '========================================';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '========================================';
    RAISE NOTICE ' ERROR OCCURRED DURING LOADING BRONZE LAYER';
    RAISE NOTICE ' Message: %', SQLERRM;
    RAISE NOTICE '========================================';
END;
$$;

CALL bronze.load_bronze();