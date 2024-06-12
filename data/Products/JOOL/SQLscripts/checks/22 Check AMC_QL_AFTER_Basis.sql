INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT polno AS PolicyNumber,
       'Invalid AMC QL AFTER Basis' AS Error,
       AMC_QL_AFTER_Basis AS Value,
       Status
FROM CostParameters
LEFT JOIN PolicyData ON CostParameters.polno = PolicyData.polno
WHERE (AMC_QL_AFTER_Basis NOT IN ('MaxValPrem', 'Premium', 'Value', 'MaxValFixed', 'Fixed')
    AND (Status = 'Issued' OR Status = 'Terminated'))
    OR (AMC_QL_AFTER_Basis IS NULL AND (Status = 'Issued' OR Status = 'Terminated'));