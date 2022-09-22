-- Load tsv files from imdb into PSQL

--- Info from documentation: 
-- title.ratings.tsv.gz – Contains the IMDb rating and votes information for titles
-- tconst (string) - alphanumeric unique identifier of the title
-- averageRating – weighted average of all the individual user ratings
-- numVotes - number of votes the title has received

ALTER USER postgres WITH SUPERUSER;

CREATE TABLE ratings(
   tconst         INT      NOT NULL,
   averageRating  FLOAT    NOT NULL,
   numVotes       INT      NOT NULL,   
CONSTRAINT ratings_pkey PRIMARY KEY (tconst));

COPY ratings 
FROM 'C:\Users\Public\IMDB\title.ratings.tsv'
DELIMITER E'\t';