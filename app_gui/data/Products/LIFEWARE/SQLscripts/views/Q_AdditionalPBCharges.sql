DROP VIEW IF EXISTS `Q_AdditionalPBCharges`;
CREATE VIEW `Q_AdditionalPBCharges` AS
    SELECT
        Bestandsreport.`Policy Nr`,
        Bestandsreport.Status,
        CalcProduct(Gewinnverband) AS Product, Bestandsreport.`Fund Reserve`
    FROM Bestandsreport
    WHERE Bestandsreport.Status = 'TRUE'
          AND CalcProduct(Gewinnverband) LIKE 'PB%'
          AND (Bestandsreport.`Fund Reserve` <= 0 OR Bestandsreport.`Fund Reserve` IS NULL);
