DROP TABLE IF EXISTS `MonetPolData BE NB`;
CREATE TABLE IF NOT EXISTS `MonetPolData BE NB` AS
    SELECT MonetPolData_BE.*
    FROM MonetPolData_BE
    LEFT JOIN MonetPolDataBE_BOP ON MonetPolData_BE.PolNo = MonetPolDataBE_BOP.PolNo
    WHERE MonetPolDataBE_BOP.PolNo IS NULL;