CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE '   Loading Bronze Layer';
    RAISE NOTICE '========================================';

    RAISE NOTICE '------ Loading ma_spotify_track_2009_2023 Table ------';

    TRUNCATE TABLE bronze.ma_spotify_track_2009_2023;
    COPY bronze.ma_spotify_track_2009_2023
    FROM 'D:\\Projects\\sql-data-warehouse-project-main\\datasets\\source_MA\\spotify_track_2009_2023.csv'
    CSV HEADER ENCODING 'LATIN1';

    RAISE NOTICE '------ Loading ma_spotify_track_2025 Tables ------';

    TRUNCATE TABLE bronze.ma_spotify_track_2025;
    COPY bronze.ma_spotify_track_2025
    FROM 'D:\\Projects\\sql-data-warehouse-project-main\\datasets\\source_MA\\spotify_track_2025.csv'
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