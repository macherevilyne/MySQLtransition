DROP VIEW IF EXISTS `Q_SummaryFundReturn`;
CREATE VIEW `Q_SummaryFundReturn` AS
    SELECT
        COUNT(Q_FundReturns.`Policy Nr`) AS CountOfPolicyNr,
        SUM(Q_FundReturns.`RegularPremSum`) AS SumOfRegularPremSum,
        Q_FundReturns.`TypeOfPrem` AS Выражение1,
        Q_FundReturns.`Product` AS Выражение2,
        SUM(Q_FundReturns.`singlePremiumSum`) AS SumOfsinglePremiumSum,
        SUM(Q_FundReturns.`FundAccValDat`) AS SumOfFundAccValDat,
        CASE
            WHEN `FundReturn` < 0.5 THEN 1
            WHEN `FundReturn` < 0.8 THEN 2
            WHEN `FundReturn` < 1 THEN 3
            WHEN `FundReturn` < 1.2 THEN 4
            ELSE 5
        END AS Expr1
    FROM Q_FundReturns
    WHERE Q_FundReturns.`TotPrem` > 0 AND Q_FundReturns.`TypeOfPrem` = 'SP'
    GROUP BY Q_FundReturns.`TypeOfPrem`, Q_FundReturns.`Product`, Expr1;