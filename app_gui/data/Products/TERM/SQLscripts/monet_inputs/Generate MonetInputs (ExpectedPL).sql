DROP TABLE IF EXISTS `Monet Inputs ExpPL`;
CREATE TABLE IF NOT EXISTS `Monet Inputs ExpPL` AS
SELECT `Monet Inputs Previous year`.*
FROM `Monet Inputs Previous year`
    LEFT JOIN `Monet Inputs Term` ON `Monet Inputs Previous year`.`PolNo` = `Monet Inputs Term`.`PolNo`
WHERE `Monet Inputs Term`.PolNo IS NOT NULL;
CREATE INDEX idx_PolNo_ExpPL ON `Monet Inputs ExpPL` (PolNo);