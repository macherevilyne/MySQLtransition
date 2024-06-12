INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT polno AS PolicyNumber, 'Invalid Single Contribution' AS Error, SingleContribution AS Value, Status
FROM PolicyData
WHERE ((SingleContribution IS NULL OR SingleContribution <= 0)
        AND Status = 'Issued' AND PolStart <= [ValuationDate])
   OR ((SingleContribution IS NULL OR SingleContribution < 0)
        AND (Status = 'Terminated' OR Status = 'Issued'));