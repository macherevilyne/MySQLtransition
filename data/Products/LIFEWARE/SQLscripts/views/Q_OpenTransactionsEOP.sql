DROP VIEW IF EXISTS `Q_OpenTransactionsEOP`;
CREATE VIEW `Q_OpenTransactionsEOP` AS
    SELECT
        Bewegungsreport.`Policy Nr`,
        CalcProduct(Bewegungsreport.`Gewinnverband`) AS Product,
        Bewegungsreport.`Währung` AS Ausdr1,
        Bewegungsreport.`Current Account End`,
        IF(Bewegungsreport.`Due Regular Premium End` < 0, Bewegungsreport.`Due Regular Premium End`, 0) AS RPinAdvance,
        IF(Bewegungsreport.`Due Single Premium End` < 0, Bewegungsreport.`Due Single Premium End`, 0) AS SPinAdvance,
        Bewegungsreport.`Due Benefit End`
    FROM Bewegungsreport
    WHERE (CalcProduct(Bewegungsreport.`Gewinnverband`) NOT LIKE 'PB%') AND (Bewegungsreport.`Current Account End` > 100);
