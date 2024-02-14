DROP TABLE IF EXISTS `MonetPolData_Eq1Drop`;
CREATE TABLE IF NOT EXISTS `MonetPolData_Eq1Drop` AS
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
        Manipulation1.RegularContribution,
        Manipulation1.SingleContribution,
        Manipulation1.AdhocContribution,
        Manipulation1.TermPrem,
        Manipulation1.Term,
        Manipulation1.SA_fixed,
        Manipulation1.TSA,
        Manipulation1.DeathPerc,
        Manipulation1.PremFreq,
        (1 - Manipulation1.PercStocks1 * Manipulation1.`Equity1 shock`) * Manipulation1.FundAccValDat AS FundAccValDat,
        Manipulation1.CommAccValDat,
        Manipulation1.ExpAccValDat,
        Manipulation1.SVValDat,
        Manipulation1.ECValDat,
        Manipulation1.PCValDat,
        Manipulation1.ClawBackValDat,
        Manipulation1.Product,
        Manipulation1.Currency,
        Manipulation1.Country,
        Manipulation1.tariffCode
    FROM `Inforce policies`
    INNER JOIN
        `Manipulation 1` AS Manipulation1 ON `Inforce policies`.`Policy Nr` = Manipulation1.PolNo
    WHERE
        (1 - Manipulation1.PercStocks1 * Manipulation1.`Equity1 shock`) * Manipulation1.FundAccValDat > 0 AND
        Manipulation1.Product NOT LIKE 'Swiss' AND
        Manipulation1.Product NOT LIKE 'PB%' AND
        Manipulation1.Currency = 'EUR'
    ORDER BY Manipulation1.PolNo;