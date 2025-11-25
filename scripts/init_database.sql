-- Drop and recreate the 'sotify_dw' database
DROP DATABASE IF EXISTS spotify_dw;

-- Create the  database
CREATE DATABASE spotify_dw;

-- Create Schema

CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;