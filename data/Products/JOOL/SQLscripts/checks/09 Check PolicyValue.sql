INSERT INTO ErrorTable (PolicyNumber, Error, Warning, Value, Status)
SELECT polno AS PolicyNumber,
       CASE
           WHEN PolicyValue IS NULL THEN 'PolicyValue null'
           WHEN Status <> 'Issued' AND Status <> 'Terminated' THEN 'Policy Value for never active policy'
           WHEN PolicyValue < -100000 THEN 'PolicyValue strongly negative'
           ELSE NULL
       END AS Error,
       CASE
           WHEN PolicyValue < 0 THEN 'Negative PolicyValue'
           ELSE NULL
       END AS Warning,
       PolicyValue AS Value,
       Status
FROM PolicyData
WHERE (PolicyValue IS NULL OR PolicyValue < 0)
   OR (PolicyValue <> 0 AND (Status <> 'Issued' AND Status <> 'Terminated'));