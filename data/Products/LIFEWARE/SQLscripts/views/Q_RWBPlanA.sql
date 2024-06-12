DROP VIEW IF EXISTS `Q_RWBPlanA`;
CREATE VIEW `Q_RWBPlanA` AS
    SELECT
        SUM(MonetPolData_BE.`ClawBackValDat`) AS ClawBackValDat,
        MonetPolData_BE.`tariffCode`
    FROM MonetPolData_BE
    WHERE MonetPolData_BE.`tariffCode` LIKE 'RWB%'
    GROUP BY MonetPolData_BE.`tariffCode`;
