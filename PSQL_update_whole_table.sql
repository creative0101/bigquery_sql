ALTER TABLE title_basics
ALTER COLUMN titletype TYPE TEXT USING titletype::TEXT;

UPDATE title_basics
SET isadult = NULL
WHERE isadult = '\N';

ALTER TABLE title_basics
ALTER COLUMN isadult TYPE INT USING isadult::INT;

UPDATE title_basics
SET startyear = NULL
WHERE startyear = '\N';

ALTER TABLE title_basics
ALTER COLUMN startyear TYPE SMALLINT USING startyear::SMALLINT;

UPDATE title_basics
SET endyear = NULL
WHERE endyear = '\N';

ALTER TABLE title_basics
ALTER COLUMN endyear TYPE SMALLINT USING endyear::SMALLINT;

ALTER TABLE title_basics
ALTER COLUMN titletype TYPE TEXT USING titletype::TEXT;

UPDATE title_basics
SET 
runtimeminutes = NULL 
WHERE runtimeminutes = '\N';

UPDATE title_basics
SET 
runtimeminutes = NULL 
WHERE runtimeminutes = 'Game-Show,Reality-TV';

UPDATE title_basics
SET 
runtimeminutes = NULL 
WHERE runtimeminutes = 'Talk-Show';

UPDATE title_basics
SET 
runtimeminutes = NULL 
WHERE runtimeminutes = 'Animation,Comedy,Family';

UPDATE title_basics
SET 
runtimeminutes = NULL 
WHERE runtimeminutes = 'Reality-TV';

UPDATE title_basics
SET 
runtimeminutes = NULL 
WHERE runtimeminutes = 'Documentary';

UPDATE title_basics
SET 
runtimeminutes = NULL 
WHERE runtimeminutes = 'Game-Show';

ALTER TABLE title_basics
ALTER COLUMN runtimeminutes TYPE INT USING runtimeminutes::INT;

