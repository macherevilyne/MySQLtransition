DROP TABLE IF EXISTS `MonetPolData Lapses NB`;
CREATE TABLE IF NOT EXISTS `MonetPolData Lapses NB` AS
    SELECT 0 AS PeriodIF, `MonetPolData NewBiz`.*
    FROM `Lapsed policies`
    INNER JOIN `MonetPolData NewBiz` ON `Lapsed policies`.VersNr = `MonetPolData NewBiz`.PolNo;