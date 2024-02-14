CREATE TABLE IF NOT EXISTS `MonetInputsJOOL AgeUpdate` AS
SELECT
    MonetInputsJOOL.PolNo,
    MonetInputsJOOL.Branch,
    MonetInputsJOOL.FundModel,
    MonetInputsJOOL.RIModel,
    MonetInputsJOOL.Tariff,
    MonetInputsJOOL.TypeOfPrem,
    MonetInputsJOOL.Count,
    IFNULL(PersonalData.PolStart, MonetInputsJOOL.PeriodIF) AS PeriodIF,
    IFNULL(PersonalData.PolStart, MonetInputsJOOL.StartYear) AS StartYear,
    IFNULL(
        PersonalData.DobVP1,
        IFNULL(PersonalData.PolStart, MonetInputsJOOL.AgeEnt1)
    ) AS AgeEnt1,
    IFNULL(PersonalData.Sex1, MonetInputsJOOL.Sex1) AS Sex1,
    MonetInputsJOOL.RegularContribution,
    MonetInputsJOOL.SingleContribution,
    MonetInputsJOOL.AdhocContribution,
    MonetInputsJOOL.TermPrem,
    MonetInputsJOOL.Term,
    MonetInputsJOOL.SA_fixed,
    MonetInputsJOOL.TSA,
    MonetInputsJOOL.DeathPerc,
    MonetInputsJOOL.PremFreq,
    MonetInputsJOOL.FundAccValDat,
    MonetInputsJOOL.CommAccValDat,
    MonetInputsJOOL.ExpAccValDat,
    MonetInputsJOOL.SVValDat,
    MonetInputsJOOL.ECValDat,
    MonetInputsJOOL.PCValDat,
    MonetInputsJOOL.ClawBackValDat,
    MonetInputsJOOL.Currency,
    MonetInputsJOOL.Country
FROM
    MonetInputsJOOL
LEFT JOIN
    PersonalData ON MonetInputsJOOL.PolNo = PersonalData.polno;