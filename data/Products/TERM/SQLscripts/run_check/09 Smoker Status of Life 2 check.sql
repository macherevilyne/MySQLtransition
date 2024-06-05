INSERT INTO ErrorTable (`Policy No`, `Error`, `Val`)
SELECT `Monet Inputs Term`.PolNo,
       CASE
           WHEN `Smoker2` IS NULL THEN 'Class of Life 2 is empty'
           WHEN `Joined` = 'Yes' AND (`Smoker2` <> 'NonSmoker' AND `Smoker2` <> 'Smoker') THEN 'Invalid class of Life 2'
       END AS Error,
       `Monet Inputs Term`.Smoker2 AS Val
FROM `Monet Inputs Term`
WHERE `Monet Inputs Term`.Joined = 'Yes' AND (`Smoker2` IS NULL OR (`Smoker2` <> 'NonSmoker' AND `Smoker2` <> 'Smoker'));