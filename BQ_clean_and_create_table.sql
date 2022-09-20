-- Remove duplicates, round fpl_sel, get clubs without the pluses

-- Create table statement to get the updated table
CREATE OR REPLACE TABLE soccer.soccer_updated
AS 
(
  -- Inner query with cleaning functions
  SELECT DISTINCT * EXCEPT(club, fpl_sel), REPLACE(club,'+',' ') AS club_name, ROUND(fpl_sel, 2) AS rounded_fpl_sel
  FROM `example-queries-for-repository.soccer.soccer`
)