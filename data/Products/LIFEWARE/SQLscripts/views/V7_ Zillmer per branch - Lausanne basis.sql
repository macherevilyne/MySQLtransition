DROP VIEW IF EXISTS `V7: Zillmer per branch - Lausanne basis`;
CREATE VIEW `V7: Zillmer per branch - Lausanne basis` AS
    SELECT
        CONCAT(IF(CalcProduct(Bestandsreport.`Gewinnverband`) LIKE 'PB%', 'PB', CalcProduct(Bestandsreport.`Gewinnverband`)), '_', Bestandsreport.`Currency`) AS Product,
        Bestandsreport.`Branch`,
        COUNT(Results_Records.`PolNo`) AS `No of Policies`,
        SUM(IF(Bestandsreport.`Exclude RWB from Zillmer (Y/N): ` = 'Y' AND Bestandsreport.`Branch` LIKE '%RWB%', 0, Results_Records.`ZillmerValDat`)) AS Zillmer,
        SUM(Results_Records.`PolReceivableValDat`) AS PolReceivable
    FROM Bestandsreport
    INNER JOIN Results_Records ON Bestandsreport.`Policy Nr` = Results_Records.`PolNo`
    GROUP BY CONCAT(IF(CalcProduct(Bestandsreport.`Gewinnverband`) LIKE 'PB%', 'PB', CalcProduct(Bestandsreport.`Gewinnverband`)), '_', Bestandsreport.`Currency`), Bestandsreport.`Branch`;