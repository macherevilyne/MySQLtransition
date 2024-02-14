DROP VIEW IF EXISTS `R1: No of pol, AP, Premsum & SI`;
CREATE VIEW `R1: No of pol, AP, Premsum & SI` AS
    SELECT
        Bestandsreport.`Policy Nr`,
        IFNULL(Bestandsreport.`Regular Premium (EUR)`, 0) AS RP,
        IFNULL(Bestandsreport.`Single Premium (EUR)`, 0) AS SP,
        AnnualPremium(IFNULL(Bestandsreport.`Regular Premium (EUR)`, 0), IFNULL(Bestandsreport.`Single Premium (EUR)`, 0), Bestandsreport.`Pay Frequency (per year)`) AS AnnualPrem,
        PremiumSum(IFNULL(Bestandsreport.`Regular Premium (EUR)`, 0), IFNULL(Bestandsreport.`Single Premium (EUR)`, 0), Bestandsreport.`Pay Frequency (per year)`, Bestandsreport.`Term`) AS PremSum,
        IFNULL(Bestandsreport.`Contribution Term (years)`, 0) AS Term,
        IFNULL(Bestandsreport.`Coverage (EUR)`, 0) AS SIFix,
        Bestandsreport.`Fund Reserve (EUR)`,
        IF(IFNULL(Bestandsreport.`SIFix`, 0) > 1.01 * Bestandsreport.`Fund Reserve (EUR)`, Bestandsreport.`SIFix`, 1.01 * Bestandsreport.`Fund Reserve (EUR)`) AS SI,
        Bestandsreport.`Status`
    FROM Bestandsreport
    WHERE Bestandsreport.`Status` = 'true';