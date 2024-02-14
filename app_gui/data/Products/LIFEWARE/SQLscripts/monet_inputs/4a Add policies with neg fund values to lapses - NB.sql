DROP TABLE IF EXISTS `MonetPolData Lapses NB`;
CREATE TABLE IF NOT EXISTS `MonetPolData Lapses NB` AS
    SELECT
        `MonetPolData`.`GroupBy`,
        `MonetPolData`.`PolNo`,
        `MonetPolData`.`Tariff`,
        `MonetPolData`.`Branch`,
        `MonetPolData`.`FundModel`,
        `MonetPolData`.`CommModel`,
        `MonetPolData`.`RIModel`,
        `MonetPolData`.`TypeOfPrem`,
        `MonetPolData`.`Count`,
        `MonetPolData`.`PeriodIF`,
        `MonetPolData`.`StartYear`,
        `MonetPolData`.`AgeEnt1`,
        `MonetPolData`.`Sex1`,
        `MonetPolData`.`RegularContribution`,
        `MonetPolData`.`SingleContribution`,
        `MonetPolData`.`AdhocContribution`,
        `MonetPolData`.`TermPrem`,
        `MonetPolData`.`Term`,
        `MonetPolData`.`SA_fixed`,
        `MonetPolData`.`TSA`,
        `MonetPolData`.`PremFreq`,
        `MonetPolData`.`FundAccValDat`,
        `MonetPolData`.`CommAccValDat`,
        `MonetPolData`.`ExpAccValDat`,
        `MonetPolData`.`SVValDat`,
        `MonetPolData`.`ECValDat`,
        `MonetPolData`.`PCValDat`,
        `MonetPolData`.`ClawBackValDat`
    FROM MonetPolData
    WHERE
        `MonetPolData`.`StartYear` = 2009 AND
        `MonetPolData`.`FundAccValDat` < 0;