DROP TABLE IF EXISTS `MonetPolData NewBiz OIP`;
CREATE TABLE IF NOT EXISTS `MonetPolData NewBiz OIP` AS
    SELECT
        Manipulation1.GroupBy AS Expression1,
        Manipulation1.PolNo AS Expression2,
        Manipulation1.Tariff AS Expression3,
        Manipulation1.Branch AS Expression4,
        Manipulation1.FundModel AS Expression5,
        Manipulation1.CommModel AS Expression6,
        Manipulation1.RIModel AS Expression7,
        Manipulation1.TypeOfPrem AS Expression8,
        Manipulation1.Count AS Expression9,
        0 AS PeriodIF,
        Manipulation1.StartYear AS Expression10,
        Manipulation1.AgeEnt1 AS Expression11,
        Manipulation1.Sex1 AS Expression12,
        Manipulation1.RegularContribution AS Expression13,
        Manipulation1.SingleContribution AS Expression14,
        Manipulation1.AdhocContribution AS Expression15,
        Manipulation1.TermPrem AS Expression16,
        Manipulation1.Term AS Expression17,
        Manipulation1.SA_fixed AS Expression18,
        Manipulation1.TSA AS Expression19,
        Manipulation1.DeathPerc AS Expression20,
        Manipulation1.PremFreq AS Expression21,
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
        (Manipulation1.Gewinnverband = "OIP")
    ORDER BY
        Manipulation1.PolNo;