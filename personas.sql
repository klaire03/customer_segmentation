SELECT * FROM personas.personas;

SELECT DISTINCT phone_brand
FROM personas.personas;

SELECT DISTINCT phone_model
FROM personas.personas;

ALTER TABLE personas.personas
DROP COLUMN phone_model;

ALTER TABLE personas.personaspersonas
DROP COLUMN wishlist;

SET SQL_SAFE_UPDATES = 0;

UPDATE personas.personas
SET watch_brand = LEFT(watch_brand, INSTR(watch_brand, ' ') - 1)
WHERE INSTR(watch_brand, ' ') > 0;


 --------
 
-- Assuming 'smartwatch_users' is the name of your original table
CREATE TABLE personas.personas_temp AS
SELECT 
    *,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(situation, ',', 1), ',', -1)) AS situation1,
    CASE WHEN INSTR(situation, ',') > 0 THEN
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(situation, ',', 2), ',', -1))
    ELSE
        NULL
    END AS situation2
FROM 
    personas.personas;

SELECT * FROM personas.personas_temp;

ALTER TABLE personas.personas_temp
DROP COLUMN situation;

RENAME TABLE personas.personas_temp TO personas.personas;

UPDATE personas.personas
SET spent_watch = REPLACE(spent_watch, 'Â', '');

ALTER TABLE personas.personas
DROP COLUMN feeling_anxious;

ALTER TABLE personas.personas
ALTER COLUMN purchase_year INTEGER;

UPDATE personas.personas
SET intention_price = REPLACE(spent_watch, 'Â', '');

ALTER TABLE personas.personas
DROP COLUMN situation2;

ALTER TABLE personas.personas
RENAME COLUMN situation1 to situation;



