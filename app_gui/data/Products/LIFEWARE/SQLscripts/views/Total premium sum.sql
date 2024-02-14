DROP VIEW IF EXISTS `Total premium sum`;
CREATE VIEW `Total premium sum` AS
    SELECT
        SUM(MonetPolData.`Count`) AS NoOfPol,
        SUM(MonetPolData.`RegularContribution` * MonetPolData.`PremFreq`) AS AnnualPrem,
        SUM(MonetPolData.`RegularContribution` * MonetPolData.`TermPrem` * MonetPolData.`PremFreq`) AS PremSumRP,
        SUM(MonetPolData.`SingleContribution`) AS PremSumSP,
        (SUM(MonetPolData.`RegularContribution` * MonetPolData.`TermPrem` * MonetPolData.`PremFreq`) + SUM(MonetPolData.`SingleContribution`)) AS PremSumTotal
    FROM MonetPolData;