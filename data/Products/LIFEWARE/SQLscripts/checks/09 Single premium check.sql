INSERT INTO `Error Table` (`Policy Nr`, Warning, `Data Value`)
SELECT
    Bestandsreport.`Policy Nr`,
    'Single premium >100000 or negative' AS Warning,
    Bestandsreport.`Single Premium` AS Expr1
FROM Bestandsreport
WHERE
    Bestandsreport.`Single Premium` > 100000 OR
    Bestandsreport.`Single Premium` < 0;