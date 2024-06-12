DROP VIEW IF EXISTS `Q_SurrenderCharges`;
CREATE VIEW `Q_SurrenderCharges` AS
SELECT
    PolicyData.polno,
    PolicyData.PolStart,
    PolicyData.Product,
    PolicyData.SCIMCAmortized,
    CostParameters.JOOL_Comm_PERC
FROM
    PolicyData
LEFT JOIN
    CostParameters ON PolicyData.polno = CostParameters.polno
WHERE
    PolicyData.Product = 'FAS SEK';