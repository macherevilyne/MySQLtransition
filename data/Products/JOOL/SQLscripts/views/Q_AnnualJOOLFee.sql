DROP VIEW IF EXISTS `Q_AnnualJOOLFee`;
CREATE VIEW `Q_AnnualJOOLFee` AS
SELECT
    CostParameters.polno,
    PolicyData.PolicyCurrency,
    PolicyData.Status,
    PolicyData.PolicyValue,
    CostParameters.AMC_QL_AFTER_PERC,
    CostParameters.AMC_QL_AFTER_Basis,
    CostParameters.AMC_QL_AFTER_FIXED,
    CostParameters.APF_QL, ROE.EUR
FROM CostParameters
INNER JOIN PolicyData ON CostParameters.polno = PolicyData.polno
LEFT JOIN ROE ON PolicyData.PolicyCurrency = ROE.Currency
WHERE PolicyData.Status = 'Issued';
