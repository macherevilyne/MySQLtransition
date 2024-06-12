DROP VIEW IF EXISTS `Q_MaxZillmer`;
CREATE VIEW `Q_MaxZillmer` AS
    SELECT
        MonetPolData.PolNo,
        MonetPolData.Branch,
        MonetPolData.RegularContribution,
        MonetPolData.SingleContribution,
        MonetPolData.PremFreq,
        MonetPolData.TermPrem,
        Results_Records.FundReserveValDat,
        Results_Records.SurrenderReserveValDat,
        Results_Records.DACValDat,
        Results_Records.DOCValDat,
        Results_Records.ZillmerValDat
    FROM MonetPolData
    INNER JOIN Results_Records ON MonetPolData.PolNo = Results_Records.PolNo;