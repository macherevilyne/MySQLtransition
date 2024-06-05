DROP VIEW IF EXISTS `Q_LWSummary`;
CREATE VIEW `Q_LWSummary` AS
    SELECT
        SUM(Q_SumsByGV.Amount) AS Policies,
        SUM(Q_SumsByGV.FundReserve) AS `Fund value`
    FROM Q_SumsByGV;
