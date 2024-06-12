DROP VIEW IF EXISTS `V9: Total FMA reserves, SMSM, DAC and DOC`;
CREATE VIEW `V9: Total FMA reserves, SMSM, DAC and DOC` AS
    SELECT
        Count(Bestandsreport.`Policy Nr`) AS `Policy Nr`,
        Sum(Results_Records_FMA.`SurrenderReserveValDat`) AS `SurrenderReserveValDat`,
        Sum(Results_Records_FMA.`FundReserveValDat`) AS `FundReserveValDat`,
        Sum(Results_Records_FMA.`EuroReserveValDat`) AS `EuroReserveValDat`,
        Sum(Results_Records_FMA.`ReserveValDat`) AS `ReserveValDat`,
        Sum(Results_Records_FMA.`DACValDat`) AS `DACValDat`,
        Sum(Results_Records_FMA.`DOCValDat`) AS `DOCValDat`,
        Sum(Results_Records_FMA.`SolvMarginValDat`) AS `SolvMarginValDat`,
        Sum(Bestandsreport.`Single Premium (EUR)`) AS `Single Premium (EUR)`
    FROM Results_Records_FMA
    INNER JOIN Bestandsreport ON Results_Records_FMA.`PolNo` = Bestandsreport.`Policy Nr`;