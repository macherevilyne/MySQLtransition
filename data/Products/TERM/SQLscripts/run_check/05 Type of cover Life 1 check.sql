INSERT INTO ErrorTable (`Policy No`, `Error`, `Val`)
SELECT `Monet Inputs Term`.PolNo,
       CASE
           WHEN `BenefitType` IS NULL THEN 'Type of cover Life 1 empty'
           WHEN `BenefitType` NOT IN ('Level', 'Reducing', 'Mortgage', 'Increasing', 'Linear') THEN 'Invalid type of cover Life 1'
       END AS Error,
       `Monet Inputs Term`.BenefitType
FROM `Monet Inputs Term`
WHERE (`Monet Inputs Term`.BenefitType IS NULL)
   OR (`Monet Inputs Term`.BenefitType NOT IN ('Level', 'Reducing', 'Mortgage', 'Increasing', 'Linear'));