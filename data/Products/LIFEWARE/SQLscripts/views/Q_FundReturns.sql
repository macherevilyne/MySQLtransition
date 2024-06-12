DROP VIEW IF EXISTS `Q_FundReturns`;
CREATE VIEW `Q_FundReturns` AS
    SELECT Bestandsreport.`Policy Nr`,
        IF(PremFreq = 99, 0, PeriodIF / 12 * PremFreq * RegularContribution) AS RegularPremSum,
        MonetPolData.TypeOfPrem,
        CalcProduct(Gewinnverband) AS Product,
        Bestandsreport.singlePremiumSum,
        MonetPolData.FundAccValDat,
        IF(singlePremiumSum IS NULL, 0, singlePremiumSum) + IF(RegularPremSum IS NULL, 0, RegularPremSum) AS TotPrem,
        FundAccValDat / TotPrem AS FundReturn
    FROM MonetPolData
    RIGHT JOIN Bestandsreport ON MonetPolData.PolNo = Bestandsreport.`Policy Nr`
    WHERE MonetPolData.PeriodIF > 60;