INSERT INTO ErrorTable (`Policy No`, `Error`, `Warning`, `Val`)
SELECT
    `Monet Inputs Term`.PolNo,
    IF(`Monet Inputs Term`.AnnualPremium IS NULL, 'Recurring premium empty', IF(`Monet Inputs Term`.AnnualPremium <= 0, 'Invalid recurring premium', NULL)) AS Error,
    IF(`Monet Inputs Term`.AnnualPremium > 2000, 'Recurring premium > 2,000 EUR', NULL) AS Warning,
    `Monet Inputs Term`.AnnualPremium AS Val
FROM `Monet Inputs Term`
WHERE
    ((`Monet Inputs Term`.AnnualPremium IS NULL OR `Monet Inputs Term`.AnnualPremium <= 0 OR `Monet Inputs Term`.AnnualPremium > 2000)
    AND (`Monet Inputs Term`.PremFreq = 1 OR `Monet Inputs Term`.PremFreq = 12));