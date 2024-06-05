DROP VIEW IF EXISTS `Q_AnalyseTransactions`;
CREATE VIEW `Q_AnalyseTransactions` AS
    SELECT
        CalcProduct(Gewinnverband) AS Product,
        COUNT(Bewegungsreport.`Policy Nr`) AS CountOfPolicyNr,
        SUM(Bewegungsreport.`Fund Reserve Begin`) AS SumOfFundReserveBegin,
        SUM(Bewegungsreport.`Fund Reserve End`) AS SumOfFundReserveEnd,
        SUM(
            COALESCE(Bewegungsreport.`Current Account Begin`, 0) +
            COALESCE(Bewegungsreport.`Due Benefit Begin`, 0) +
            IF(Bewegungsreport.`Due Regular Premium Begin` < 0, Bewegungsreport.`Due Regular Premium Begin`, 0) +
            IF(Bewegungsreport.`Due Single Premium Begin` < 0, Bewegungsreport.`Due Single Premium Begin`, 0)
        ) AS OpenTransactionsBegin,
        SUM(
            -IF(COALESCE(Bewegungsreport.`Regular Premium`, 0) IS NULL, 0, Bewegungsreport.`Regular Premium`) -
            IF(COALESCE(Bewegungsreport.`Due Regular Premium End`, 0) IS NULL OR Bewegungsreport.`Due Regular Premium End` < 0, 0, Bewegungsreport.`Due Regular Premium End`) +
            IF(COALESCE(Bewegungsreport.`Due Regular Premium Begin`, 0) IS NULL OR Bewegungsreport.`Due Regular Premium Begin` < 0, 0, Bewegungsreport.`Due Regular Premium Begin`)
        ) AS RPInvested,
        SUM(
            -IF(COALESCE(Bewegungsreport.`Single Premium`, 0) IS NULL, 0, Bewegungsreport.`Single Premium`) -
            IF(COALESCE(Bewegungsreport.`Due Single Premium End`, 0) IS NULL OR Bewegungsreport.`Due Single Premium End` < 0, 0, Bewegungsreport.`Due Single Premium End`) +
            IF(COALESCE(Bewegungsreport.`Due Single Premium Begin`, 0) IS NULL OR Bewegungsreport.`Due Single Premium Begin` < 0, 0, Bewegungsreport.`Due Single Premium Begin`)
        ) AS SPInvested,
        SUM(
            COALESCE(Bewegungsreport.`Surrender`, 0) +
            COALESCE(Bewegungsreport.`Death`, 0) +
            COALESCE(Bewegungsreport.`Maturity`, 0)
        ) AS Benefits,
        SUM(
            COALESCE(Bewegungsreport.`Upfront commission`, 0) +
            COALESCE(Bewegungsreport.`Establishment Charge Amortization`, 0) +
            COALESCE(Bewegungsreport.`Establishment Charge Interest`, 0) +
            COALESCE(Bewegungsreport.`Initial Policy Charge (direct)`, 0) +
            COALESCE(Bewegungsreport.`Initial Management Charge (direct)`, 0) +
            COALESCE(Bewegungsreport.`Initial Policy Charge (amortized)`, 0) +
            COALESCE(Bewegungsreport.`Initial Management Charge (amortized)`, 0) +
            COALESCE(Bewegungsreport.`Premium Charge Amortization`, 0) +
            COALESCE(Bewegungsreport.`Premium Charge Interest`, 0) +
            COALESCE(Bewegungsreport.`Annual Management Charge`, 0) +
            COALESCE(Bewegungsreport.`Policy Fee`, 0) +
            COALESCE(Bewegungsreport.`Renewal Commission`, 0) +
            COALESCE(Bewegungsreport.`Recurring Premium Charge`, 0) +
            COALESCE(Bewegungsreport.`Change Charges`, 0) +
            COALESCE(Bewegungsreport.`Surrender Charges`, 0) +
            COALESCE(Bewegungsreport.`Death Risk Premium (1st order)`, 0) +
            COALESCE(Bewegungsreport.`Death Risk Bonus (2nd order)`, 0) +
            COALESCE(Bewegungsreport.`EU Risk Premium`, 0) +
            COALESCE(Bewegungsreport.`AL Risk Premium`, 0) +
            COALESCE(Bewegungsreport.`SKA Risk Premium`, 0) +
            COALESCE(Bewegungsreport.`Cheque Expenses`, 0) +
            COALESCE(Bewegungsreport.`Death Risk Sum`, 0) +
            0 * COALESCE(Bewegungsreport.`Payout Delta`, 0)
        ) AS Fees,
        SUM(
            COALESCE(Bewegungsreport.`Current Account End`, 0) +
            COALESCE(Bewegungsreport.`Due Benefit End`, 0) +
            IF(Bewegungsreport.`Due Regular Premium End` < 0, Bewegungsreport.`Due Regular Premium End`, 0) +
            IF(Bewegungsreport.`Due Single Premium End` < 0, Bewegungsreport.`Due Single Premium End`, 0)
        ) AS OpenTransactionsEnd
    FROM Bewegungsreport
    GROUP BY CalcProduct(Gewinnverband)
    HAVING CalcProduct(Gewinnverband) NOT LIKE 'PB%';