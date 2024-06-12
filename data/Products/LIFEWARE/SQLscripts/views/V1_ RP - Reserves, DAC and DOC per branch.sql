DROP VIEW IF EXISTS `V1: RP - Reserves, DAC and DOC per branch`;
CREATE VIEW `V1: RP - Reserves, DAC and DOC per branch` AS
    SELECT
        Bestandsreport.`Branch`,
        COUNT(Bestandsreport.`Policy Nr`) AS `Policy Nr`,
        SUM(Results_Records.`SurrenderReserveValDat`) AS SurrenderReserveValDat,
        SUM(Results_Records.`FundReserveValDat`) AS FundReserveValDat,
        SUM(Results_Records.`EuroReserveValDat`) AS EuroReserveValDat,
        SUM(Results_Records.`ReserveValDat`) AS ReserveValDat,
        SUM(Results_Records.`ZillmerValDat`) AS ZillmerValDat,
        SUM(Results_Records.`PolReceivableValDat`) AS PolReceivableValDat,
        SUM(Results_Records.`SolvMarginValDat`) AS SolvMarginValDat,
        SUM(Bestandsreport.`Single Premium (EUR)`) AS `Single Premium (EUR)`
    FROM Results_Records
    INNER JOIN Bestandsreport ON Results_Records.`PolNo` = Bestandsreport.`Policy Nr`
    WHERE Bestandsreport.`Regular Premium (EUR)` IS NOT NULL
    GROUP BY Bestandsreport.`Branch`;