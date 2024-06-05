DROP VIEW IF EXISTS `Q_ListNegativePolicies`;
CREATE VIEW `Q_ListNegativePolicies` AS
SELECT
    PolicyData.polno,
    PolicyData.Status,
    PolicyData.PolicyCurrency,
    PolicyData.PolicyValue,
    (PolicyData.PolicyValue * ROE.EUR) AS PolValueEUR
FROM PolicyData
LEFT JOIN ROE ON PolicyData.PolicyCurrency = ROE.Currency
WHERE (PolicyData.Status = 'Issued' OR PolicyData.Status = 'Terminated') AND PolicyData.PolicyValue < 0;
