INSERT INTO ErrorTable (`Policy No`, Error, Val)
SELECT `Monet Inputs Term`.PolNo,
       CASE
           WHEN `AgeEnt2` IS NULL THEN 'Age of Life 2 empty'
           WHEN `AgeEnt2` > 75 THEN 'Life 2 age >75'
           WHEN `AgeEnt2` < 18 THEN 'Life 2 age <18'
       END AS Error,
       `Monet Inputs Term`.AgeEnt2 AS Val
FROM `Monet Inputs Term`
WHERE ((`AgeEnt2` IS NULL OR `AgeEnt2` > 75 OR `AgeEnt2` < 18) AND `Monet Inputs Term`.Joined = 'Yes');