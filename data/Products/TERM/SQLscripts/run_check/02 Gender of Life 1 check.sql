INSERT INTO ErrorTable (`Policy No`, `Val`, `Error`)
SELECT `Monet Inputs Term`.PolNo,
       `Monet Inputs Term`.Sex1,
       CASE
           WHEN `Sex1` IS NULL THEN 'Gender of Life 1 empty'
           WHEN `Sex1` NOT IN ('Male', 'Female') THEN 'Invalid gender of Life 1'
       END AS Error
FROM `Monet Inputs Term`
WHERE `Monet Inputs Term`.Sex1 IS NULL OR `Sex1` NOT IN ('Male', 'Female');