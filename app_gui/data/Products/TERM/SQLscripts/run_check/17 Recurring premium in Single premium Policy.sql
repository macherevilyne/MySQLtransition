INSERT INTO ErrorTable (`Policy No`, `Error`, `Val`)
SELECT
    `Monet Inputs Term`.PolNo,
    'PremFreq=99 but entry in AnnualPremium column' AS Error,
    `Monet Inputs Term`.AnnualPremium AS Val
FROM `Monet Inputs Term`
WHERE
    (`Monet Inputs Term`.AnnualPremium > 0)
    AND
    (`Monet Inputs Term`.PremFreq = 99);