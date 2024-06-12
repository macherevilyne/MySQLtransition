DROP TABLE IF EXISTS `MonetPolData_EPIFPCHF`;
CREATE TABLE IF NOT EXISTS `MonetPolData_EPIFPCHF` AS
    SELECT
        Manipulation1.GroupBy,
        Manipulation1.PolNo,
        Manipulation1.Tariff,
        Manipulation1.Branch,
        Manipulation1.FundModel,
        Manipulation1.CommModel,
        Manipulation1.RIModel,
        Manipulation1.TypeOfPrem,
        Manipulation1.Count,
        Manipulation1.PeriodIF,
        Manipulation1.StartYear,
        Manipulation1.AgeEnt1,
        Manipulation1.Sex1,
        0 AS RegularContribution,
        Manipulation1.SingleContribution,
        Manipulation1.AdhocContribution,
        Manipulation1.TermPrem,
        Manipulation1.Term,
        Manipulation1.SA_fixed,
        Manipulation1.TSA,
        Manipulation1.DeathPerc,
        Manipulation1.PremFreq,
        Manipulation1.FundAccValDat + IF(Manipulation1.TypeOfPrem='RP', Manipulation1.CommAccValDat + Manipulation1.ExpAccValDat + Manipulation1.ClawBackValDat, 0) AS FundAccValDat,
        IF(Manipulation1.TypeOfPrem='RP', 0, Manipulation1.CommAccValDat) AS CommAccValDat,
        IF(Manipulation1.TypeOfPrem='RP', 0, Manipulation1.ExpAccValDat) AS ExpAccValDat,
        Manipulation1.SVValDat,
        IF(Manipulation1.TypeOfPrem='RP', 0, Manipulation1.ECValDat) AS ECValDat,
        IF(Manipulation1.TypeOfPrem='RP', 0, Manipulation1.PCValDat) AS PCValDat,
        IF(Manipulation1.TypeOfPrem='RP', 0, Manipulation1.ClawBackValDat) AS ClawBackValDat,
        Manipulation1.Product,
        Manipulation1.Currency,
        Manipulation1.Country,
        Manipulation1.tariffCode
    FROM `Inforce policies`
    INNER JOIN `Manipulation 1` AS Manipulation1 ON `Inforce policies`.`Policy Nr` = Manipulation1.PolNo
    WHERE Manipulation1.Product = 'Swiss' AND (Manipulation1.FundAccValDat + IF(Manipulation1.TypeOfPrem='RP', Manipulation1.CommAccValDat + Manipulation1.ExpAccValDat + Manipulation1.ClawBackValDat, 0)) > 0
    ORDER BY Manipulation1.PolNo;