CREATE TABLE IF NOT EXISTS MonetInputsJOOL_Spread AS
SELECT
    polno AS PolNo,
    polno AS Branch,
    'FundPB' AS FundModel,
    'NotReinsured' AS RIModel,
    'PB-001' AS Tariff,
    'SP' AS TypeOfPrem,
    1 AS `Count`,
    TIMESTAMPDIFF(MONTH, PolStart, ValDat) AS PeriodIF,
    YEAR(PolStart) AS StartYear,
    TIMESTAMPDIFF(YEAR, DoBVP1, ValDat) AS AgeEnt1,
    IFNULL(Sex1, 'Male') AS Sex1,
    0 AS RegularContribution,
    SingleContribution * EUR AS SingleContribution,
    0 AS AdhocContribution,
    0 AS TermPrem,
    IF(Term + TIMESTAMPDIFF(YEAR, PolStart, DateLatestSP) > `PeriodIF` / 12, Term + TIMESTAMPDIFF(YEAR, PolStart, DateLatestSP), INT(`PeriodIF` / 12) + 1) AS Term,
    0 AS SA_fixed,
    'PercOfFund' AS TSA,
    1.01 AS DeathPerc,
    99 AS PremFreq,
    PolicyValue * EUR * (1 - PercBonds * `Spread shock`) AS FundAccValDat,
    -SCIMCAmortized * EUR AS CommAccValDat,
    0 AS ExpAccValDat,
    SVValDat * EUR AS SVValDat,
    LastIMCAmortized / 3 * EUR AS ECValDat,
    0 AS PCValDat,
    0 AS ClawBackValDat,
    PolicyCurrency AS `Currency`,
    IF(Product = 'FBN NOK', 'NO', 'SE') AS Country
FROM
    PolicyData
LEFT JOIN ROE ON PolicyData.PolicyCurrency = ROE.Currency
WHERE
    (PolicyValue * EUR * (1 - PercBonds * `Spread shock`) >= 0)
    AND (Status = 'Issued')
    AND (PolStart < ValDat);