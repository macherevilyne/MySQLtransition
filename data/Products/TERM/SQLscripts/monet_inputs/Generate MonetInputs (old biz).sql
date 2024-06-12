DROP TABLE IF EXISTS `Monet inputs Term OB`;
CREATE TABLE IF NOT EXISTS `Monet inputs Term OB` AS
SELECT `Monet Inputs Term`.*
FROM `Monet Inputs Term`
LEFT JOIN `Monet Inputs Term NB` ON `Monet Inputs Term`.`PolNo` = `Monet Inputs Term NB`.`PolNo`
WHERE `Monet Inputs Term NB`.`PolNo` IS NULL;