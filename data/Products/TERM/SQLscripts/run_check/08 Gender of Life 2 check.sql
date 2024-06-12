INSERT INTO ErrorTable (`Policy No`, `Error`, `Val`)
SELECT `Monet Inputs Term`.PolNo,
       CASE
           WHEN `Sex2` IS NULL THEN 'Gender of Life 2 is empty'
           WHEN `Joined` = 'Yes' AND (`Sex2` <> 'Male' AND `Sex2` <> 'Female') THEN 'Invalid Gender of Life 2'
       END AS Error,
       `Monet Inputs Term`.Sex2 AS Val
FROM `Monet Inputs Term`
WHERE `Monet Inputs Term`.Joined = 'Yes' AND (`Sex2` IS NULL OR (`Sex2` <> 'Male' AND `Sex2` <> 'Female'));