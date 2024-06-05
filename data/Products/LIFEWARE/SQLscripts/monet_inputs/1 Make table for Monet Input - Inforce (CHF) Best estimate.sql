DROP TABLE IF EXISTS `MonetPolData_BECHF`;
CREATE TABLE IF NOT EXISTS `MonetPolData_BECHF` AS
    SELECT
        `Manipulation 1`.GroupBy,
        `Manipulation 1`.PolNo,
        `Manipulation 1`.Tariff,
        `Manipulation 1`.Branch,
        `Manipulation 1`.FundModel,
        `Manipulation 1`.CommModel,
        `Manipulation 1`.RIModel,
        `Manipulation 1`.TypeOfPrem,
        `Manipulation 1`.Count,
        `Manipulation 1`.PeriodIF,
        `Manipulation 1`.StartYear,
        `Manipulation 1`.AgeEnt1,
        `Manipulation 1`.Sex1,
        `Manipulation 1`.RegularContribution,
        `Manipulation 1`.SingleContribution,
        `Manipulation 1`.AdhocContribution,
        `Manipulation 1`.TermPrem,
        `Manipulation 1`.Term,
        `Manipulation 1`.SA_fixed,
        `Manipulation 1`.TSA,
        `Manipulation 1`.DeathPerc,
        `Manipulation 1`.PremFreq,
        `Manipulation 1`.FundAccValDat,
        `Manipulation 1`.CommAccValDat,
        `Manipulation 1`.ExpAccValDat,
        `Manipulation 1`.SVValDat,
        `Manipulation 1`.ECValDat,
        `Manipulation 1`.PCValDat,
        `Manipulation 1`.ClawBackValDat,
        `Manipulation 1`.BirthDate1,
        `Manipulation 1`.ValuationDate,
        `Manipulation 1`.Currency,
        `Manipulation 1`.Country,
        `Manipulation 1`.tariffCode
    FROM `Inforce policies`
        INNER JOIN `Manipulation 1` ON `Inforce policies`.`Policy Nr` = `Manipulation 1`.PolNo
    WHERE `Manipulation 1`.FundAccValDat > 0 AND `Manipulation 1`.Product = 'Swiss'
    ORDER BY `Manipulation 1`.PolNo;