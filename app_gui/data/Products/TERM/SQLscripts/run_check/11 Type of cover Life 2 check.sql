INSERT INTO ErrorTable (`Policy No`, `Error`, `Val`)
SELECT
    `Monet Inputs Term`.PolNo,
    'Invalid type of cover Life 2' AS Error,
    `Monet Inputs Term`.BenefitType2 AS Val
FROM `Monet Inputs Term`
WHERE
    `Monet Inputs Term`.Joined = 'Yes'
    AND NOT (`BenefitType2` IN ('Level', 'Reducing', 'Mortgage', 'Increasing', 'Linear'));