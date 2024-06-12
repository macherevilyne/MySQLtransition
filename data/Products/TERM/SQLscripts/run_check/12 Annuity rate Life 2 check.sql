INSERT INTO ErrorTable (`Policy No`, `Error`, `Warning`, `Val`)
SELECT
    `Monet Inputs Term`.PolNo,
    IFNULL(`Monet Inputs Term`.MortgageRate2, 'Annuity rate Life 2 empty') AS Error,
    IF(`Monet Inputs Term`.MortgageRate2 <= 0, 'Invalid annuity rate Life 2', NULL) AS Warning,
    `Monet Inputs Term`.MortgageRate2 AS Val
FROM `Monet Inputs Term`
WHERE
    `Monet Inputs Term`.Joined = 'Yes'
    AND (
        (`Monet Inputs Term`.BenefitType2 = 'Annuity' AND (`MortgageRate2` < 0.03 OR `MortgageRate2` > 0.08))
        OR (`Monet Inputs Term`.BenefitType2 = 'Increasing' AND (`MortgageRate2` > 0 AND `MortgageRate2` <= 0.025))
        OR (`Monet Inputs Term`.BenefitType2 IN ('Annuity', 'Increasing') AND `MortgageRate2` IS NULL)
    );