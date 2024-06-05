DROP VIEW IF EXISTS `Q_Sumsinsured`;
CREATE VIEW `Q_Sumsinsured` AS
SELECT
    PolNo,
    Country,
    FundAccValDat,
    DeathPerc,
    DeathPerc * FundAccValDat AS SI,
    (DeathPerc - 1) * FundAccValDat AS SAR
FROM
    MonetInputsJOOL
ORDER BY
    (DeathPerc - 1) * FundAccValDat DESC;