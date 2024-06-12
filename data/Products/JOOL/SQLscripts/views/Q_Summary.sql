DROP VIEW IF EXISTS `Q_Summary`;
CREATE VIEW `Q_Summary` AS
SELECT
    PolicyData.Status,
    CASE
        WHEN SurrenderDate <= ValuationDate THEN 'Yes'
        ELSE 'No'
    END AS SurrenderBefore,
    SUM(PolicyData.PolicyValue) AS SumOfPolicyValue,
    SUM(PolicyData.SCIMCAmortized) AS SumOfSCIMCAmortized,
    SUM(PolicyValue * EUR) AS FVEUR,
    SUM(SCIMCAmortized * EUR) AS SCEUR
FROM
    PolicyData
LEFT JOIN
    ROE ON PolicyData.PolicyCurrency = ROE.Currency
GROUP BY
    PolicyData.Status,
    CASE
        WHEN SurrenderDate <= ValuationDate THEN 'Yes'
        ELSE 'No'
    END;