INSERT INTO ErrorTable (`Policy No`, `Error`, `Val`)
SELECT
    `Monet Inputs Term`.PolNo,
    IF(`Monet Inputs Term`.PremFreq IS NULL, 'Payment frequency empty', 'Invalid payment frequency') AS Error,
    `Monet Inputs Term`.PremFreq AS Val
FROM `Monet Inputs Term`
WHERE
    (`Monet Inputs Term`.PremFreq IS NULL)
    OR ((`Monet Inputs Term`.PremFreq = 12 OR `Monet Inputs Term`.PremFreq = 99 OR `Monet Inputs Term`.PremFreq = 1) = FALSE);