INSERT INTO ErrorTable (`Policy No`, `Val`, `Error`)
SELECT `Monet Inputs Term`.PolNo,
       `Monet Inputs Term`.Smoker1,
       CASE
           WHEN `Smoker1` IS NULL THEN 'Class of Life 1 empty'
           WHEN `Smoker1` NOT IN ('NonSmoker', 'Smoker') THEN 'Invalid class of Life 1'
       END AS Error
FROM `Monet Inputs Term`
WHERE `Monet Inputs Term`.Smoker1 IS NULL OR `Smoker1` NOT IN ('NonSmoker', 'Smoker');