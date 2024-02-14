DROP TABLE IF EXISTS `Monet Inputs Invest`;
CREATE TABLE IF NOT EXISTS `Monet Inputs Invest` AS
SELECT `Monet Inputs Term`.*,
       `Results_Records_Invest`.`ReserveValDat`
FROM `Monet Inputs Term`
    INNER JOIN `Results_Records_Invest` ON `Monet Inputs Term`.PolNo = `Results_Records_Invest`.`PolNo`
WHERE `Results_Records_Invest`.`ReserveValDat`>0;
