DROP TABLE IF EXISTS `MonetInputs BusinessSteering (EUR)`;
CREATE TABLE IF NOT EXISTS `MonetInputs BusinessSteering (EUR)` AS
    SELECT
        MonetPolData_BE.GroupBy,
        MonetPolData_BE.PolNo,
        MonetPolData_BE.Tariff,
        MonetPolData_BE.Branch,
        MonetPolData_BE.FundModel,
        MonetPolData_BE.CommModel,
        MonetPolData_BE.RIModel,
        MonetPolData_BE.TypeOfPrem,
        MonetPolData_BE.Count,
        MonetPolData_BE.PeriodIF,
        MonetPolData_BE.StartYear,
        MonetPolData_BE.AgeEnt1,
        MonetPolData_BE.Sex1,
        MonetPolData_BE.RegularContribution,
        CASE WHEN MonetPolData_BE.PremFreq = 99 THEN MonetPolData_BE.SingleContribution ELSE 0 END AS SingleContribution,
        CASE WHEN MonetPolData_BE.PremFreq = 99 THEN 0 ELSE MonetPolData_BE.SingleContribution END AS AdhocContribution,
        MonetPolData_BE.TermPrem,
        MonetPolData_BE.Term,
        MonetPolData_BE.SA_fixed,
        MonetPolData_BE.TSA,
        MonetPolData_BE.DeathPerc,
        MonetPolData_BE.PremFreq,
        MonetPolData_BE.FundAccValDat,
        MonetPolData_BE.CommAccValDat,
        MonetPolData_BE.ExpAccValDat,
        MonetPolData_BE.SVValDat,
        MonetPolData_BE.ECValDat,
        MonetPolData_BE.PCValDat,
        MonetPolData_BE.ClawBackValDat,
        MonetPolData_BE.Product,
        MonetPolData_BE.Currency,
        MonetPolData_BE.Country,
        MonetPolData_BE.tariffCode,
        Bestandsreport.Start
    FROM
        MonetPolData_BE
    LEFT JOIN
        Bestandsreport ON MonetPolData_BE.PolNo = Bestandsreport.`Policy Nr`
    WHERE
        Bestandsreport.Start >= 'ReplaceWithActualStartDate' AND Bestandsreport.Start < 'ReplaceWithActualValDate';