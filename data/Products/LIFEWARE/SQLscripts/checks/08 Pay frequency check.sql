INSERT INTO `Error Table` (`Policy Nr`, Error, `Data Value`)
SELECT
    Bestandsreport.`Policy Nr`,
    'Invalid pay frequency' AS Error,
    CASE
        WHEN Bestandsreport.`Pay Frequency (per year)` = 1 OR
             Bestandsreport.`Pay Frequency (per year)` = 2 OR
             Bestandsreport.`Pay Frequency (per year)` = 4 OR
             Bestandsreport.`Pay Frequency (per year)` = 12
        THEN TRUE
        ELSE FALSE
    END AS Ausdr1
FROM Bestandsreport
WHERE
    NOT (
        Bestandsreport.`Pay Frequency (per year)` = 1 OR
        Bestandsreport.`Pay Frequency (per year)` = 2 OR
        Bestandsreport.`Pay Frequency (per year)` = 4 OR
        Bestandsreport.`Pay Frequency (per year)` = 12
    );