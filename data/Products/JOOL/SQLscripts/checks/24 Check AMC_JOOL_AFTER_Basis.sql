INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT polno AS PolicyNumber,
       'Invalid AMC JOOL AFTER Basis' AS Error,
       AMC_JOOL_AFTER_Basis AS Value,
       Status
FROM CostParameters
LEFT JOIN PolicyData ON CostParameters.polno = PolicyData.polno
WHERE (AMC_JOOL_AFTER_Basis NOT IN ('MaxValPrem', 'Premium', 'Value', 'MaxValFixed', 'Fixed', 'ValMinusPrem')
    AND (Status = 'Issued' OR Status = 'Terminated'))
    OR (AMC_JOOL_AFTER_Basis IS NULL AND (Status = 'Issued' OR Status = 'Terminated'));