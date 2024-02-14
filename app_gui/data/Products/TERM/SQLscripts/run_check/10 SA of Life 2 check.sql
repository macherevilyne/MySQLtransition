INSERT INTO ErrorTable (`Policy No`, `Error`, `Warning`, `Val`)
SELECT
    `Monet Inputs Term`.PolNo,
    CASE
        WHEN `SumAssuredEnt2` IS NULL THEN 'SA Life 2 empty'
        WHEN `Joined` = 'Yes' AND (`SumAssuredEnt2` > 500000 OR `SumAssuredEnt2` IS NULL) AND `CalcEngine` <> 3 THEN 'SA Life 2 >€500,000'
        WHEN `Joined` = 'Yes' AND (`SumAssuredEnt2` < 50000 AND `SumAssuredEnt2` > 0 OR `SumAssuredEnt2` IS NULL) AND `CalcEngine` <> 3 THEN 'SA Life 2 <€50,000'
        WHEN `Joined` = 'Yes' AND (`SumAssuredEnt2` IS NULL OR `SumAssuredEnt2` > 500000) AND `CalcEngine` = 3 THEN 'SA Life 2 >€500,000'
    END AS Error,
    CASE
        WHEN `SumAssuredEnt2` > 500000 THEN 'SA Life 2 >€500,000'
        WHEN `SumAssuredEnt2` < 50000 AND `SumAssuredEnt2` > 0 THEN 'SA Life 2 <€50,000'
    END AS Warning,
    `Monet Inputs Term`.SumAssuredEnt2 AS Val
FROM `Monet Inputs Term`
WHERE
    (`Monet Inputs Term`.SumAssuredEnt2 IS NULL OR `Monet Inputs Term`.SumAssuredEnt2 > 500000)
    AND `Joined` = 'Yes'
    AND `CalcEngine` <> 3
    OR (`Monet Inputs Term`.SumAssuredEnt2 < 50000 AND `Monet Inputs Term`.SumAssuredEnt2 <> 0)
    AND `Joined` = 'Yes'
    AND `CalcEngine` <> 3
    OR (`Monet Inputs Term`.SumAssuredEnt2 IS NULL OR `Monet Inputs Term`.SumAssuredEnt2 > 500000)
    AND `Joined` = 'Yes'
    AND `CalcEngine` = 3;