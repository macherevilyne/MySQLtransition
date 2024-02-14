UPDATE Bestandsreport
    SET Bestandsreport.`Due Regular Premiums (EUR)` = 0
WHERE Bestandsreport.`Due Regular Premiums (EUR)` IS NOT NULL AND Bestandsreport.`Regular Premium (EUR)` IS NULL;