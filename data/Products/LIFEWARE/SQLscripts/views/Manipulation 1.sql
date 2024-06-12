SET @ValuationDate = '2023-11-29'; -- Установить дату оценки

SELECT 
    Bestandsreport.`Policy Nr` AS PolNo, 
    Bestandsreport.Gewinnverband, 
    Bestandsreport.Currency AS `Currency`, 
    Bestandsreport.Country, 
    CalcProduct(Bestandsreport.Gewinnverband) AS Product, 
    MonetTariffNew(Bestandsreport.Start, Bestandsreport.`TypeOfPrem`, Bestandsreport.Gewinnverband) AS Tariff, 
    " " AS GroupBy, 
    CASE 
        WHEN Bestandsreport.Gewinnverband = 'OIP' THEN 'FundOIP'
        WHEN CalcProduct(Bestandsreport.Gewinnverband) LIKE 'PB*' THEN 'FundPB'
        ELSE 'Fund'
    END AS FundModel, 
    CommissionModel(Bestandsreport.Start, Bestandsreport.Branch, Bestandsreport.`TypeOfPrem`) AS CommModel, 
    ReinsuranceModel(Bestandsreport.Start, Bestandsreport.Branch, IFNULL([Branches reinsured].Branch, FALSE)) AS RIModel, 
    TypeOfPremium(
        IFNULL(Bestandsreport.`Regular Premium`, 0), 
        IFNULL(Bestandsreport.`Single Premium`, 0)
    ) AS TypeOfPrem, 
    Bestandsreport.Start, 
    YEAR(Bestandsreport.Start) AS StartYear, 
    PERIOD_DIFF(DATE_FORMAT(@ValuationDate, '%Y%m'), DATE_FORMAT(Bestandsreport.Start, '%Y%m')) AS PeriodIF, 
    CalcAge(Bestandsreport.Birthdate, Bestandsreport.Start) AS AgeEnt1, 
    IF(Bestandsreport.Gender = 'weiblich', 'Female', 'Male') AS Sex1, 
    IFNULL(Bestandsreport.`Regular Premium`, 0) AS RegularContribution, 
    IFNULL(Bestandsreport.`Single Premium`, 0) AS SingleContribution, 
    0 AS AdhocContribution, 
    IFNULL(Bestandsreport.`Contribution Term (years)`, 0) AS TermPrem, 
    Bestandsreport.`Contract Term (years)` AS Term, 
    IFNULL(Bestandsreport.Coverage, 0) AS SA_fixed, 
    IF(Bestandsreport.`Coverage Type` = 'German Law', 'GermanLaw', 'PercOfFund') AS TSA, 
    Bestandsreport.Percentage AS DeathPerc, 
    1 AS `Count`, 
    IFNULL(Bestandsreport.`Regular Premium`, 99) AS PremFreq, 
    Bestandsreport.Branch, 
    IFNULL(Bestandsreport.`Fund Reserve`, 0) AS FundAccValDat, 
    IFNULL(Bestandsreport.`EC Amortization`, 0) AS CommAccValDat, 
    IFNULL(Bestandsreport.`PC Amortization`, 0) AS ExpAccValDat, 
    IFNULL(Bestandsreport.`Surrender Value`, 0) AS SVValDat, 
    IFNULL(Bestandsreport.EC, 0) AS ECValDat, 
    IFNULL(Bestandsreport.`PC`, 0) AS PCValDat, 
    IFNULL(Bestandsreport.`Clawback`, 0) AS ClawBackValDat, 
    Bestandsreport.Birthdate AS BirthDate1, 
    @ValuationDate AS ValuationDate, 
    Bestandsreport.tariffCode
FROM 
    `Branches reinsured` 
    RIGHT JOIN Bestandsreport ON IFNULL(`Branches reinsured`.Branch, '') = Bestandsreport.Branch
WHERE 
    CalcProduct(Bestandsreport.Gewinnverband) <> 'AP';