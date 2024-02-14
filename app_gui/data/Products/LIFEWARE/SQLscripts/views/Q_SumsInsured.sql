DROP VIEW IF EXISTS `Q_SumsInsured`;
CREATE VIEW `Q_SumsInsured` AS
    SELECT
        Bestandsreport.`Policy Nr`,
        Bestandsreport.`Currency` AS Ausdr1,
        CalcProduct(Bestandsreport.`Gewinnverband`) AS Product,
        Bestandsreport.`Status`,
        TIMESTAMPDIFF(MONTH, Bestandsreport.`Start`, Bestandsreport.`ValDate`) AS PeriodIF,
        Bestandsreport.`Contract Term (years)`,
        IFNULL(Bestandsreport.`Coverage`, 0) AS SAFix,
        Bestandsreport.`Coverage Type`,
        IFNULL(Bestandsreport.`Percentage`, 1.01) AS Perc,
        Bestandsreport.`Fund Reserve`,
        ROE.`EUR` AS ROE
    FROM Bestandsreport
    LEFT JOIN ROE ON Bestandsreport.`Currency` = ROE.`Currency`
    WHERE CalcProduct(Bestandsreport.`Gewinnverband`) <> 'AP'
        AND Bestandsreport.`Status` = 'true'
        AND TIMESTAMPDIFF(MONTH, Bestandsreport.`Start`, Bestandsreport.`ValDate`) < 12 * Bestandsreport.`Contract Term (years)`;