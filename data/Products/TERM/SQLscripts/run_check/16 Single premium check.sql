INSERT INTO ErrorTable (`Policy No`, `Error`, `Warning`, `Val`)
SELECT
    `Monet Inputs Term`.PolNo,
    IF(`Monet Inputs Term`.SPadd IS NULL, 'Single premium empty', IF(`Monet Inputs Term`.SPadd <= 0, 'Invalid single premium', NULL)) AS Error,
    IF(`Monet Inputs Term`.SPadd > 10000, 'SPadd > 10,000 EUR', NULL) AS Warning,
    `Monet Inputs Term`.SPadd AS Val
FROM `Monet Inputs Term`
WHERE
    ((`Monet Inputs Term`.SPadd IS NULL OR `Monet Inputs Term`.SPadd <= 0)
    AND (`Monet Inputs Term`.PremFreq = 99))
    OR
    ((`Monet Inputs Term`.SPadd < 0 OR `Monet Inputs Term`.SPadd > 10000)
    AND (`Monet Inputs Term`.PremFreq = 1 OR `Monet Inputs Term`.PremFreq = 12 OR `Monet Inputs Term`.PremFreq = 99));