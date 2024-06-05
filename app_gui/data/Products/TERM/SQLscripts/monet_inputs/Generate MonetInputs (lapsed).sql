DROP TABLE IF EXISTS `Monet Inputs Lapses EB`;
CREATE TABLE IF NOT EXISTS `Monet Inputs Lapses EB` AS
SELECT `Monet Inputs Previous year`.*
FROM `Monet Inputs Previous year`
LEFT JOIN `Monet Inputs Term` ON `Monet Inputs Previous year`.`PolNo` = `Monet Inputs Term`.`PolNo`
WHERE `Monet Inputs Term`.`PolNo` IS NULL;