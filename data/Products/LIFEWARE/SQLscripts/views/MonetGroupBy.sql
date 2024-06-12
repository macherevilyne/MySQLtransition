DROP VIEW IF EXISTS `MonetGroupBy`;
CREATE VIEW `MonetGroupBy` AS
    SELECT
        MonetPolData.`Policy Nr` AS Ausdr1,
        MonetPolData.GroupBy,
        MonetPolData.Branch,
        MonetPolData.TypeOfPrem,
        MonetPolData.Count,
        MonetPolData.PeriodIF,
        MonetPolData.StartYear,
        MonetPolData.AgeEnt1,
        MonetPolData.Sex1,
        MonetPolData.RegularContribution,
        MonetPolData.SingleContribution,
        MonetPolData.AdhocContribution,
        MonetPolData.TermPrem,
        MonetPolData.Term,
        MonetPolData.SA_fixed,
        MonetPolData.TSA,
        MonetPolData.PremFreq,
        MonetPolData.FundAccValDat,
        MonetPolData.CommAccValDat,
        MonetPolData.ExpAccValDat,
        MonetPolData.SVValDat,
        MonetPolData.ECValDat,
        MonetPolData.PCValDat,
        MonetPolData.ClawBackValDat
    FROM
        MonetPolData
    ORDER BY
        MonetPolData.GroupBy;