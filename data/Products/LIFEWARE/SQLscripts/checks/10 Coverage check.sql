INSERT INTO `Error Table` (`Policy Nr`, Error, Warning, `Data Value`)
SELECT
    Bestandsreport.`Policy Nr`,
    IF(Bestandsreport.`Coverage` < 0, 'Coverage negative', NULL) AS Error,
    IF(Bestandsreport.`Coverage` > 100000, 'Coverage > 100000', NULL) AS Warning,
    Bestandsreport.`Coverage` AS Expr1
FROM Bestandsreport
WHERE
    Bestandsreport.`Coverage` < 0 OR
    Bestandsreport.`Coverage` > 100000;