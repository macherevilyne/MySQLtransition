INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT polno AS PolicyNumber,
       'Invalid Last IMCAmortized' AS Error,
       LastIMCAmortized AS Value,
       Status
FROM PolicyData
WHERE ((LastIMCAmortized <= 0 OR LastIMCAmortized IS NULL)
        AND Status = 'Issued'
        AND PolStart <= [ValuationDate]
        AND Product = 'FAS SEK')
   OR ((LastIMCAmortized < 0 OR LastIMCAmortized IS NULL)
        AND (Status = 'Issued' OR Status = 'Terminated')
        AND Product = 'FAS SEK')
   OR ((LastIMCAmortized <> 0 OR LastIMCAmortized IS NULL)
        AND Product <> 'FAS SEK');