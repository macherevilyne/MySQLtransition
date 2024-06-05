DROP VIEW IF EXISTS `Manipulation 1 old`;
CREATE VIEW `Manipulation 1 old` AS
    SELECT
        Bestandsreport.`Policy Nr` AS PolNo,
        IF(LEFT(Bestandsreport.`Policy Nr`, 3) = 'OIP', 'OIP', 'German UL') AS Product,
        MonetTariff(Bestandsreport.Start, Bestandsreport.`TypeOfPrem`, Bestandsreport.`Policy Nr`) AS Tariff,
        ' ' AS GroupBy,
        IF(LEFT(Bestandsreport.`Policy Nr`, 3) = 'OIP', 'FundOIP', 'Fund') AS FundModel,
        CommissionModel(Bestandsreport.Start, Bestandsreport.Branch, Bestandsreport.`TypeOfPrem`) AS CommModel,
        ReinsuranceModel(Bestandsreport.Start, Bestandsreport.Branch, IF(ISNULL(`Branches reinsured`.Branch), FALSE, TRUE)) AS RIModel,
        TypeOfPremium(IF(ISNULL(Bestandsreport.`Regular Premium (EUR)`), 0, Bestandsreport.`Regular Premium (EUR)`),
                       IF(ISNULL(Bestandsreport.`Single Premium (EUR)`), 0, Bestandsreport.`Single Premium (EUR)`)) AS TypeOfPrem,
        Bestandsreport.Start,
        YEAR(Bestandsreport.Start) AS StartYear,
        DATEDIFF(Bestandsreport.Start, '2013-11-01') AS PeriodIF,
        CalcAge(Bestandsreport.Birthdate, Bestandsreport.Start) AS AgeEnt1,
        IF(Bestandsreport.Gender = 'weiblich', 'Female', 'Male') AS Sex1,
        IF(ISNULL(Bestandsreport.`Regular Premium (EUR)`), 0, Bestandsreport.`Regular Premium (EUR)`) AS RegularContribution,
        IF(ISNULL(Bestandsreport.`Single Premium (EUR)`), 0, Bestandsreport.`Single Premium (EUR)`) AS SingleContribution,
        0 AS AdhocContribution,
        IF(ISNULL(Bestandsreport.`Contribution Term (years)`), 0, Bestandsreport.`Contribution Term (years)`) AS TermPrem,
        Bestandsreport.`Contract Term (years)` AS Term,
        IF(ISNULL(Bestandsreport.`Coverage (EUR)`), 0, Bestandsreport.`Coverage (EUR)`) AS SA_fixed,
        'PercOfFund' AS TSA,
        1 AS Count,
        IF(ISNULL(Bestandsreport.`Regular Premium (EUR)`), 99, Bestandsreport.`Pay Frequency (per year)`) AS PremFreq,
        Bestandsreport.Branch,
        IF(ISNULL(Bestandsreport.`Fund Reserve (EUR)`), 0, Bestandsreport.`Fund Reserve (EUR)`) AS FundAccValDat,
        IF(ISNULL(Bestandsreport.`EC Amortization (EUR)`), 0, Bestandsreport.`EC Amortization (EUR)`) AS CommAccValDat,
        IF(ISNULL(Bestandsreport.`PC Amortization (EUR)`), 0, Bestandsreport.`PC Amortization (EUR)`) AS ExpAccValDat,
        IF(ISNULL(Bestandsreport.`Surrender Value (EUR)`), 0, Bestandsreport.`Surrender Value (EUR)`) AS SVValDat,
        IF(ISNULL(Bewegungsreport.`last monthly EC Payment (EUR)`), 0, Bewegungsreport.`last monthly EC Payment (EUR)`) AS ECValDat,
        IF(ISNULL(Bewegungsreport.`last monthly PC Payment (EUR)`), 0, Bewegungsreport.`last monthly PC Payment (EUR)`) AS PCValDat,
        IF(ISNULL(Bestandsreport.`Clawback (EUR)`), 0, Bestandsreport.`Clawback (EUR)`) AS ClawBackValDat,
        Bestandsreport.Birthdate AS Birthdate1
    FROM
        Bewegungsreport
    INNER JOIN
        (`Branches reinsured`
        RIGHT JOIN
        Bestandsreport ON `Branches reinsured`.Branch = Bestandsreport.Branch)
    ON
        Bewegungsreport.`Policy Nr` = Bestandsreport.`Policy Nr`;