INSERT INTO ErrorTable (`Policy No`, Error, Warning, Val)
SELECT
    `Monet Inputs Term`.PolNo,
    CASE
        WHEN `Monet Inputs Term`.Term IS NULL THEN 'Term of cover empty'
        WHEN 12 * `Monet Inputs Term`.Term < `Monet Inputs Term`.PeriodIF THEN 'Policy expired'
        WHEN `Monet Inputs Term`.Term > 50 THEN 'Term of cover >50'
        WHEN `Monet Inputs Term`.AgeEnt1 + `Monet Inputs Term`.Term > 81 THEN 'Age of Life 1 >81 at end of term'
        WHEN `Monet Inputs Term`.AgeEnt2 + `Monet Inputs Term`.Term > 81 THEN 'Age of Life 2 >81 at end of term'
    END AS Error,
    IF(`Monet Inputs Term`.Term < 5, 'Term of cover < 5', NULL) AS Warning,
    `Monet Inputs Term`.Term AS Val
FROM `Monet Inputs Term`
WHERE
    (
        `Monet Inputs Term`.Term IS NULL
        OR `Monet Inputs Term`.Term < 5
        OR `Monet Inputs Term`.Term < `Monet Inputs Term`.PeriodIF / 12
        OR `Monet Inputs Term`.Term > 50
    )
    AND (`Monet Inputs Term`.CalcEngine <> 8 AND `Monet Inputs Term`.CalcEngine <> 13)
    OR (
        (`Monet Inputs Term`.CalcEngine <> 8 AND `Monet Inputs Term`.CalcEngine <> 13)
        AND (`Monet Inputs Term`.AgeEnt1 + `Monet Inputs Term`.Term) > 86
    )
    OR (
        (`Monet Inputs Term`.CalcEngine <> 8 AND `Monet Inputs Term`.CalcEngine <> 13)
        AND (`Monet Inputs Term`.AgeEnt2 + `Monet Inputs Term`.Term) > 86
    );