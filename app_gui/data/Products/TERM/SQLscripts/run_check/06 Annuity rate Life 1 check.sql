INSERT INTO ErrorTable (`Policy No`, `Error`, `Warning`, `Val`)
SELECT `Monet Inputs Term`.PolNo,
       CASE
           WHEN `MortgageRate` IS NULL THEN 'Annuity rate Life 1 empty'
           WHEN `MortgageRate` <= 0 THEN 'Invalid annuity rate Life 1'
       END AS Error,
       CASE
           WHEN `MortgageRate` > 0 THEN 'Inappropriate annuity rate'
       END AS Warning,
       `Monet Inputs Term`.MortgageRate
FROM `Monet Inputs Term`
WHERE ((`MortgageRate` BETWEEN 0.03 AND 0.08 AND `Monet Inputs Term`.BenefitType = 'Mortgage') = FALSE)
   OR ((`Monet Inputs Term`.BenefitType = 'Increasing') AND (`MortgageRate` > 0 AND `MortgageRate` <= 0.025) = FALSE);