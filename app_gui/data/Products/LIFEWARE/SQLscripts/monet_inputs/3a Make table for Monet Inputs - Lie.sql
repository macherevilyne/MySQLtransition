DROP TABLE IF EXISTS `MonetPolData_LI`;
CREATE TABLE IF NOT EXISTS `MonetPolData_LI` AS
    SELECT MonetPolData_GermanUL.*, Bestandsreport.`Broker ID`
    FROM MonetPolData_GermanUL
    INNER JOIN Bestandsreport ON MonetPolData_GermanUL.PolNo = Bestandsreport.`Policy Nr`
    WHERE Bestandsreport.`Broker ID` LIKE 'man%002';