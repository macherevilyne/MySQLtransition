DROP TABLE IF EXISTS `MonetPolData NewBiz PB`;
CREATE TABLE IF NOT EXISTS `MonetPolData NewBiz PB` AS
    SELECT
        Manipulation1.GroupBy,
        Manipulation1.PolNo,
        Manipulation1.Tariff,
        Manipulation1.Branch,
        Manipulation1.FundModel,
        Manipulation1.CommModel,
        Manipulation1.RIModel,
        Manipulation1.TypeOfPrem,
        Manipulation1.Anzahl AS Ausdr1,
        0 AS PeriodIF,
        Manipulation1.StartYear,
        Manipulation1.AgeEnt1,
        Manipulation1.Sex1,
        Manipulation1.RegularContribution * [EUR] AS RegularContribution,
        Manipulation1.SingleContribution * [EUR] AS SingleContribution,
        Manipulation1.AdhocContribution * [EUR] AS AdhocContribution,
        Manipulation1.TermPrem,
        Manipulation1.Term,
        Manipulation1.SA_fixed * [EUR] AS SA_fixed,
        Manipulation1.TSA,
        Manipulation1.DeathPerc,
        Manipulation1.PremFreq,
        0 AS FundAccValDat,
        0 AS CommAccValDat,
        0 AS ExpAccValDat,
        0 AS SVValDat,
        0 AS ECValDat,
        0 AS PCValDat,
        0 AS ClawBackValDat
    FROM
        `Manipulation 1` AS Manipulation1
    LEFT JOIN
        ROE ON Manipulation1.Currency = ROE.Currency
    WHERE
        (Manipulation1.StartYear = [Calendar year for new buisness?]) AND
        (Manipulation1.Product LIKE "PB*")
    ORDER BY
        Manipulation1.PolNo;