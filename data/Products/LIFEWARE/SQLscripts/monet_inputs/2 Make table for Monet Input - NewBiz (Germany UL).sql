DROP TABLE IF EXISTS `MonetPolData NewBiz GermanUL`;
CREATE TABLE IF NOT EXISTS `MonetPolData NewBiz GermanUL` AS
    SELECT
        Manipulation1.GroupBy AS Expression1,
        Manipulation1.PolNo AS Expression2,
        Manipulation1.Tariff AS Expression3,
        Manipulation1.Branch AS Expression4,
        Manipulation1.FundModel AS Expression5,
        Manipulation1.CommModel AS Expression6,
        Manipulation1.RIModel AS Expression7,
        Manipulation1.TypeOfPrem AS Expression8,
        Manipulation1.Anzahl AS Ausdr1,
        0 AS PeriodIF,
        Manipulation1.StartYear AS Expression9,
        Manipulation1.AgeEnt1 AS Expression10,
        Manipulation1.Sex1 AS Expression11,
        Manipulation1.RegularContribution AS Expression12,
        Manipulation1.SingleContribution AS Expression13,
        Manipulation1.AdhocContribution AS Expression14,
        Manipulation1.TermPrem AS Expression15,
        Manipulation1.Term AS Expression16,
        Manipulation1.SA_fixed AS Expression17,
        Manipulation1.TSA AS Expression18,
        Manipulation1.DeathPerc AS Expression19,
        Manipulation1.PremFreq AS Expression20,
        0 AS FundAccValDat,
        0 AS CommAccValDat,
        0 AS ExpAccValDat,
        0 AS SVValDat,
        0 AS ECValDat,
        0 AS PCValDat,
        0 AS ClawBackValDat
    FROM
        `Manipulation 1` AS Manipulation1
    WHERE
        (Manipulation1.StartYear = [Calendar year for new buisness?]) AND
        (Manipulation1.Gewinnverband = "UL 07" OR Manipulation1.Gewinnverband = "RUERUP")
    ORDER BY
        Manipulation1.PolNo;