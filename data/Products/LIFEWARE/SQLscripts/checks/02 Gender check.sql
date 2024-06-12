INSERT INTO `Error Table` (`Policy Nr`, Error, `Data Value`)
SELECT
    Bestandsreport.`Policy Nr`,
    'Gender empty or invalid expression' AS Error,
    Bestandsreport.Gender
FROM Bestandsreport
WHERE Bestandsreport.Gender NOT IN ('männlich', 'weiblich') OR Bestandsreport.Gender IS NULL;