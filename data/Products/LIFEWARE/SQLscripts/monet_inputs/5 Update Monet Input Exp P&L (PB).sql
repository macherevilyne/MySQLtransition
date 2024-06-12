UPDATE `MonetPolData ExpPL (PB)`
    LEFT JOIN MonetPolData_PB ON `MonetPolData ExpPL (PB)`.PolNo = MonetPolData_PB.PolNo
    SET
        `MonetPolData ExpPL (PB)`.PeriodIF = IFNULL(MonetPolData_PB.PeriodIF, `MonetPolData ExpPL (PB)`.PeriodIF),
        `MonetPolData ExpPL (PB)`.FundAccValDat = CASE
            WHEN `MonetPolData ExpPL (PB)`.StartYear = [Start year for new biz] AND `MonetPolData ExpPL (PB)`.SingleContribution IS NULL THEN 0
            ELSE IFNULL(`MonetPolData ExpPL (PB)`.SingleContribution, 0) + IFNULL(`MonetPolData ExpPL (PB)`.RegularContribution, 0)
        END,
        `MonetPolData ExpPL (PB)`.CommAccValDat = CASE
            WHEN `MonetPolData ExpPL (PB)`.CommAccValDat + 12 * `MonetPolData ExpPL (PB)`.ECValDat + 0.065 * (`MonetPolData ExpPL (PB)`.CommAccValDat + 6 * `MonetPolData ExpPL (PB)`.ECValDat) > 0 THEN 0
            ELSE `MonetPolData ExpPL (PB)`.CommAccValDat + 12 * `MonetPolData ExpPL (PB)`.ECValDat + 0.065 * (`MonetPolData ExpPL (PB)`.CommAccValDat + 6 * `MonetPolData ExpPL (PB)`.ECValDat)
        END,
        `MonetPolData ExpPL (PB)`.ExpAccValDat = CASE
            WHEN `MonetPolData ExpPL (PB)`.ExpAccValDat + 12 * `MonetPolData ExpPL (PB)`.PCValDat + 0.065 * (`MonetPolData ExpPL (PB)`.ExpAccValDat + 12 * `MonetPolData ExpPL (PB)`.PCValDat) > 0 THEN 0
            ELSE `MonetPolData ExpPL (PB)`.ExpAccValDat + 12 * `MonetPolData ExpPL (PB)`.PCValDat + 0.065 * (`MonetPolData ExpPL (PB)`.ExpAccValDat + 12 * `MonetPolData ExpPL (PB)`.PCValDat)
        END,
        `MonetPolData ExpPL (PB)`.SVValDat = CASE
            WHEN `FA` < 0 THEN 0
            ELSE `FA`
        END * (1 - 0.025 * (60 - CASE WHEN `PerIF` > 60 THEN 60 ELSE `PerIF` END) / 60),
        `MonetPolData ExpPL (PB)`.ClawBackValDat = CASE
            WHEN `MonetPolData ExpPL (PB)`.ClawBackValDat - 12 * `MonetPolData ExpPL (PB)`.ECValDat < 0 THEN 0
            ELSE `MonetPolData ExpPL (PB)`.ClawBackValDat - 12 * `MonetPolData ExpPL (PB)`.ECValDat
        END,
        `MonetPolData ExpPL (PB)`.Branch = MonetPolData_PB.Branch;