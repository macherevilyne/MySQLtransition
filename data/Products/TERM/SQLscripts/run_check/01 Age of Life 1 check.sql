CREATE TABLE IF NOT EXISTS `ErrorTable` (
   `Policy No` TEXT,
   `Error` TEXT,
   `Warning` TEXT,
   `Val` TEXT
   );
INSERT INTO ErrorTable (`Policy No`, `Val`, `Error`)
SELECT `Monet Inputs Term`.PolNo AS Ausdr1,
       `Monet Inputs Term`.AgeEnt1 AS Age1,
       CASE
           WHEN `AgeEnt1` > 75 THEN 'Life 1 age >75'
           WHEN `AgeEnt1` < 18 THEN 'Life 1 age <18'
           WHEN `AgeEnt1` IS NULL THEN 'Age of Life 1 empty'
       END AS Error
FROM `Monet Inputs Term`
WHERE `Monet Inputs Term`.AgeEnt1 IS NULL OR `Monet Inputs Term`.AgeEnt1 > 75 OR `Monet Inputs Term`.AgeEnt1 < 18;