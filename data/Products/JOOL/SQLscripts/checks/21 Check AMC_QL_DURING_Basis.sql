INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT polno AS PolicyNumber,
       'Invalid AMC QL DURING Basis' AS Error,
       AMC_QL_DURING_Basis AS Value,
       Status
FROM CostParameters
LEFT JOIN PolicyData ON CostParameters.polno = PolicyData.polno
WHERE (AMC_QL_DURING_Basis NOT IN ('MaxValPrem', 'Premium', 'Value', 'MaxValFixed', 'Fixed')
    AND (Status = 'Issued' OR Status = 'Terminated'))
    OR (AMC_QL_DURING_Basis IS NULL AND (Status = 'Issued' OR Status = 'Terminated'));