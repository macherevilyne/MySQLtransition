DROP VIEW IF EXISTS `V12: Due benefits`;
CREATE VIEW `V12: Due benefits` AS
    SELECT
        Bestandsreport.Branch,
        Bewegungsreport.Währung AS Currency,
        Bewegungsreport.`Policy Nr`,
        Bewegungsreport.`Due Benefit End`,
        Bewegungsreport.`Current Account End`,
        Bewegungsreport.`Transaction Account End`,
        Bewegungsreport.`Fund Reserve End`,
        Bestandsreport.`Surrender Value`,
        Bestandsreport.Status,
        Bestandsreport.Start,
        CalcProduct(Bewegungsreport.Gewinnverband) AS Product
    FROM
        Bewegungsreport
    LEFT JOIN
        Bestandsreport ON Bewegungsreport.`Policy Nr` = Bestandsreport.`Policy Nr`
    WHERE
        (Bewegungsreport.`Due Benefit End` < 0) AND (Bestandsreport.Status = 'true')
    ORDER BY
        Bewegungsreport.`Policy Nr`;