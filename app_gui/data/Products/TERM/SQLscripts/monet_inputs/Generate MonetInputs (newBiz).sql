DROP TABLE IF EXISTS `Monet Inputs Term NB`;
CREATE TABLE IF NOT EXISTS `Monet Inputs Term NB` AS
SELECT
    `Monet Inputs Term`.*
FROM
    `Monet Inputs Term`
LEFT JOIN
    `Monet Inputs Previous year` ON `Monet Inputs Term`.`PolNo` = `Monet Inputs Previous year`.`PolNo`
WHERE
    `Monet Inputs Previous year`.`PolNo` IS NULL;