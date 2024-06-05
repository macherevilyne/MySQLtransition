DROP VIEW IF EXISTS `V9: Total reserves, SMSM, DAC and DOC`;
CREATE VIEW `V9: Total reserves, SMSM, DAC and DOC` AS
    SELECT
        Count(Bestandsreport.PolicyNr) AS PolicyCount,
        Sum(Results_Records.SurrenderReserveValDat) AS SurrenderReserveValDat,
        Sum(Results_Records.FundReserveValDat) AS FundReserveValDat,
        Sum(Results_Records.EuroReserveValDat) AS EuroReserveValDat,
        Sum(Results_Records.ReserveValDat) AS ReserveValDat,
        Sum(Results_Records.DACValDat) AS DACValDat,
        Sum(Results_Records.DOCValDat) AS DOCValDat,
        Sum(Results_Records.SolvMarginValDat) AS SolvMarginValDat,
        Sum(Bestandsreport.SinglePremiumEUR) AS SinglePremiumEUR
    FROM
        Results_Records
    INNER JOIN
        Bestandsreport ON Results_Records.PolNo = Bestandsreport.PolicyNr;
