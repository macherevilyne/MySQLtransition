DROP VIEW IF EXISTS `Q_OpenTransactionsBOP`;
CREATE VIEW `Q_OpenTransactionsBOP` AS
    SELECT
        Bewegungsreport.`Policy Nr`,
        CalcProduct(Bewegungsreport.`Gewinnverband`) AS Product,
        Bewegungsreport.`Currency`,
        Bewegungsreport.`Current Account Begin`,
        IF(Bewegungsreport.`Due Regular Premium Begin` < 0, Bewegungsreport.`Due Regular Premium Begin`, 0) AS RPinAdvance,
        IF(Bewegungsreport.`Due Single Premium Begin` < 0, Bewegungsreport.`Due Single Premium Begin`, 0) AS SPinAdvance,
        Bewegungsreport.`Due Benefit Begin`
    FROM Bewegungsreport
    WHERE (CalcProduct(Bewegungsreport.`Gewinnverband`) NOT LIKE 'PB%') AND (Bewegungsreport.`Current Account Begin` > 100);