DROP TABLE IF EXISTS `MonetPolData_SpreadPB`;
CREATE TABLE IF NOT EXISTS `MonetPolData_SpreadPB` AS
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
        Manipulation1.RegularContribution * ROE.EUR AS RegularContribution,
        Manipulation1.SingleContribution * ROE.EUR AS SingleContribution,
        Manipulation1.AdhocContribution * ROE.EUR AS AdhocContribution,
        Manipulation1.TermPrem,
        Manipulation1.Term,
        IIF(Manipulation1.[Set SA_fixed to 0? (Y/N)] = 'Y', 0, Manipulation1.SA_fixed * ROE.EUR) AS SA_fixed,
        Manipulation1.TSA,
        Manipulation1.DeathPerc,
        Manipulation1.PremFreq,
        (1 - Manipulation1.PercBonds * Manipulation1.[Spread shock]) * Manipulation1.FundAccValDat * ROE.EUR AS FundAccValDat,
        Manipulation1.CommAccValDat * ROE.EUR AS CommAccValDat,
        Manipulation1.ExpAccValDat * ROE.EUR AS ExpAccValDat,
        Manipulation1.SVValDat * ROE.EUR AS SVValDat,
        Manipulation1.ECValDat * ROE.EUR AS ECValDat,
        Manipulation1.PCValDat * ROE.EUR AS PCValDat,
        Manipulation1.ClawBackValDat * ROE.EUR AS ClawBackValDat,
        Manipulation1.BirthDate1,
        Manipulation1.ValuationDate,
        Manipulation1.Currency,
        Manipulation1.Country,
        Manipulation1.tariffCode
    FROM
        (`Inforce policies` AS ip
        INNER JOIN `Manipulation 1` AS Manipulation1 ON ip.`Policy Nr` = Manipulation1.PolNo)
        LEFT JOIN ROE ON Manipulation1.Currency = ROE.Currency
    WHERE
        (1 - Manipulation1.PercBonds * Manipulation1.[Spread shock]) * Manipulation1.FundAccValDat * ROE.EUR > 0 AND Manipulation1.Product LIKE 'PB*'
    ORDER BY
        Manipulation1.PolNo;