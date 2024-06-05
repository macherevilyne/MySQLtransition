INSERT INTO ErrorTable (`Policy No`, `Val`, `Error`, `Warning`)
SELECT `Monet Inputs Term`.PolNo, `Monet Inputs Term`.SumAssuredEnt,
       CASE
           WHEN `SumAssuredEnt` IS NULL THEN 'SA Life 1 empty'
           WHEN `SumAssuredEnt` <= 0 THEN 'SA Life 1 non-positive'
       END AS Error,
       CASE
           WHEN `SumAssuredEnt` > 500000 THEN 'SA Life 1 >€500,000'
           WHEN `SumAssuredEnt` < 50000 THEN 'SA Life 1 <€50,000'
       END AS Warning
FROM `Monet Inputs Term`
WHERE (`Monet Inputs Term`.SumAssuredEnt IS NULL OR `Monet Inputs Term`.SumAssuredEnt > 500000 OR `Monet Inputs Term`.SumAssuredEnt < 50000) AND (`Monet Inputs Term`.CalcEngine <> 3)
   OR (`Monet Inputs Term`.SumAssuredEnt IS NULL OR `Monet Inputs Term`.SumAssuredEnt > 500000) AND (`Monet Inputs Term`.CalcEngine = 3);