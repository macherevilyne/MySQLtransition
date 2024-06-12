INSERT INTO `Error Table` (`Policy Nr`, Error, `Data Value`)
SELECT
    Bestandsreport.`Policy Nr` AS `Policy Nr`,
    CASE
        WHEN Bestandsreport.Start IS NULL THEN 'Start empty'
        WHEN STR_TO_DATE(`Bestandsreport`.`Start`, '%d.%m.%Y') < STR_TO_DATE('01-11-2006', '%d-%m-%Y') THEN 'Invalid start'
        WHEN STR_TO_DATE(`Bestandsreport`.`Start`, '%d.%m.%Y') > STR_TO_DATE('{ValDate}', '%d-%m-%Y') THEN 'Invalid start'
        ELSE NULL
    END AS `Error`,
    Bestandsreport.Start AS `Data Value`
FROM Bestandsreport
WHERE
    Bestandsreport.Start IS NULL OR
    STR_TO_DATE(`Bestandsreport`.`Start`, '%d.%m.%Y') < STR_TO_DATE('01-11-2006', '%d-%m-%Y') OR
    STR_TO_DATE(`Bestandsreport`.`Start`, '%d.%m.%Y') > STR_TO_DATE('{ValDate}', '%d-%m-%Y');