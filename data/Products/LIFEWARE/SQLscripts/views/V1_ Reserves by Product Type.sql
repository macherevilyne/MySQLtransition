DROP VIEW IF EXISTS `V1: Reserves by Product Type`;
CREATE VIEW `V1: Reserves by Product Type` AS
    SELECT
        CONCAT(IF(CalcProduct(Bestandsreport.`Gewinnverband`) LIKE 'PB%', 'PB', CalcProduct(Bestandsreport.`Gewinnverband`)), '_', Bestandsreport.`Currency`) AS Product,
        Bestandsreport.`Branch`,
        COUNT(Bestandsreport.`Policy Nr`) AS `Policy Nr`,
        SUM(Results_Records.`SurrenderReserveValDat`) AS SurrenderReserveValDat,
        SUM(Results_Records.`FundReserveValDat`) AS FundReserveValDat,
        SUM(Results_Records.`EuroReserveValDat`) AS EuroReserveValDat,
        SUM(Results_Records.`ReserveValDat`) AS ReserveValDat,
        SUM(IF(Bestandsreport.`Exclude RWB from Zillmer (Y/N): ` = 'Y' AND Bestandsreport.`Branch` LIKE '%RWB%', 0, Results_Records.`ZillmerValDat`)) AS ZillmerValDat,
        SUM(Results_Records.`PolReceivableValDat`) AS PolReceivableValDat,
        SUM(Results_Records.`SolvMarginValDat`) AS SolvMarginValDat,
        SUM(Bestandsreport.`Single Premium`) AS `Single Premium`
    FROM Results_Records
    INNER JOIN Bestandsreport ON Results_Records.`PolNo` = Bestandsreport.`Policy Nr`
    GROUP BY CONCAT(IF(CalcProduct(Bestandsreport.`Gewinnverband`) LIKE 'PB%', 'PB', CalcProduct(Bestandsreport.`Gewinnverband`)), '_', Bestandsreport.`Currency`), Bestandsreport.`Branch`;