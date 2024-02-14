INSERT INTO `Error Table` (`Policy Nr`, Error, Warning, `Data Value`)
SELECT
    Bestandsreport.`Policy Nr`,
    CASE
        WHEN CAST(REPLACE(Bestandsreport.`Regular Premium`, ',', '.') AS DECIMAL(10, 2)) IS NULL THEN 'Regular premium empty'
        WHEN AnnualPremium(CAST(REPLACE(Bestandsreport.`Regular Premium`, ',', '.') AS DECIMAL(10, 2)), 0, Bestandsreport.`Pay Frequency (per year)`) < 600 THEN 'Annual premium <50'
        WHEN AnnualPremium(CAST(REPLACE(Bestandsreport.`Regular Premium`, ',', '.') AS DECIMAL(10, 2)), 0, Bestandsreport.`Pay Frequency (per year)`) > 12000 THEN 'Annual premium >12000'
        ELSE ''
    END AS Error,
    CASE
        WHEN Bestandsreport.`Regular Premium` IS NULL THEN ''
        WHEN AnnualPremium(CAST(REPLACE(Bestandsreport.`Regular Premium`, ',', '.') AS DECIMAL(10, 2)), 0, Bestandsreport.`Pay Frequency (per year)`) < 600 THEN 'Annual premium <50'
        WHEN AnnualPremium(CAST(REPLACE(Bestandsreport.`Regular Premium`, ',', '.') AS DECIMAL(10, 2)), 0, Bestandsreport.`Pay Frequency (per year)`) > 12000 THEN 'Annual premium >12000'
        ELSE ''
    END AS Warning,
    CAST(REPLACE(Bestandsreport.`Regular Premium`, ',', '.') AS DECIMAL(10, 2)) * IF(ISNULL(Bestandsreport.`Pay Frequency (per year)`), 12, Bestandsreport.`Pay Frequency (per year)`) AS Ausdr1
FROM Bestandsreport
WHERE
    (
        IF(
            CAST(REPLACE(Bestandsreport.`Regular Premium`, ',', '.') AS DECIMAL(10, 2)) IS NULL,
            IF(Bestandsreport.`Single Premium` IS NULL, 'error', 'ok'),
            ''
        ) = 'error'
        AND Bestandsreport.`Status` = TRUE
    )
    OR (
        AnnualPremium(CAST(REPLACE(Bestandsreport.`Regular Premium`, ',', '.') AS DECIMAL(10, 2)), 0, Bestandsreport.`Pay Frequency (per year)`) < 600
        AND Bestandsreport.`Status` = TRUE
    )
    OR (
        AnnualPremium(CAST(REPLACE(Bestandsreport.`Regular Premium`, ',', '.') AS DECIMAL(10, 2)), 0, Bestandsreport.`Pay Frequency (per year)`) > 12000
        AND Bestandsreport.`Status` = TRUE
    );