DROP TABLE IF EXISTS `MonetPolData PB NB`;
CREATE TABLE IF NOT EXISTS `MonetPolData PB NB` AS
    SELECT MonetPolData_PB.*
    FROM MonetPolData_PB
    LEFT JOIN `MonetPolData_PB BoP` ON MonetPolData_PB.PolNo = `MonetPolData_PB BoP`.PolNo
    WHERE `MonetPolData_PB BoP`.PolNo IS NULL;