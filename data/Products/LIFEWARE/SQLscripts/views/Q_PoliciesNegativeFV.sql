DROP VIEW IF EXISTS `Q_PoliciesNegativeFV`;
CREATE VIEW `Q_PoliciesNegativeFV` AS
    SELECT
        Bestandsreport.`Policy Nr`,
        CalcProduct(Bestandsreport.`Gewinnverband`) AS Product,
        Bestandsreport.`Währung` AS Ausdr1,
        Bestandsreport.`Fund Reserve`,
        Bestandsreport.`Fund Reserve` * ROE.`EUR` AS `Fund Reserve EUR`
    FROM Bestandsreport
    LEFT JOIN ROE ON Bestandsreport.`Currency` = ROE.`Currency`
    WHERE Bestandsreport.`Fund Reserve` < 0
    ORDER BY CalcProduct(Bestandsreport.`Gewinnverband`);