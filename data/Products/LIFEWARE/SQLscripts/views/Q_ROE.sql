DROP VIEW IF EXISTS `Q_ROE`;
CREATE VIEW `Q_ROE` AS
    SELECT
        ROE.`EUR`,
        ROE.`Currency`
    FROM T_CurrencyTemplate
    LEFT JOIN ROE ON T_CurrencyTemplate.`Currency` = ROE.`Currency`
    ORDER BY T_CurrencyTemplate.`ID`;
