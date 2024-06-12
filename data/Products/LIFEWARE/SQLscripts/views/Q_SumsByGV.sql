DROP VIEW IF EXISTS `Q_SumsByGV`;
CREATE VIEW `Q_SumsByGV` AS
    SELECT
        Bestandsreport.`Gewinnverband`,
        SUM(IF(Bestandsreport.`Status` = 'true', 1, 0)) AS Amount,
        SUM(Bestandsreport.`Fund Reserve`) AS FundReserve
    FROM Bestandsreport
    GROUP BY Bestandsreport.`Gewinnverband`
    HAVING Bestandsreport.`Gewinnverband` <> 'PRD AP (EUR)';