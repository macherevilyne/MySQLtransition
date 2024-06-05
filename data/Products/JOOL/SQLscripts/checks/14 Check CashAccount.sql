INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT polno AS PolicyNumber,
       CASE
           WHEN CashAccount IS NULL THEN 'CashAccount null'
           WHEN Status <> 'Issued' AND Status <> 'Terminated' THEN 'Cash Account for never active policy'
           WHEN CashAccount < 0 THEN 'CashAccount negative'
           ELSE NULL
       END AS Error,
       CashAccount AS Value,
       Status
FROM PolicyData
WHERE (CashAccount IS NULL OR CashAccount < 0)
   OR (CashAccount <> 0 AND (Status <> 'Issued' AND Status <> 'Terminated'));