UPDATE `MonetPolData_GermanUL`
    RIGHT JOIN `MonetPolData ExpPL (GermanUL)` ON MonetPolData_GermanUL.PolNo = `MonetPolData ExpPL (GermanUL)`.PolNo
    SET
        `MonetPolData ExpPL (GermanUL)`.PeriodIF = CASE WHEN MonetPolData_GermanUL.PeriodIF IS NULL THEN `MonetPolData ExpPL (GermanUL)`.PeriodIF ELSE MonetPolData_GermanUL.PeriodIF END,
        `MonetPolData ExpPL (GermanUL)`.FundAccValDat = CASE
            WHEN `MonetPolData ExpPL (GermanUL)`.StartYear = [Start year for new biz] AND `MonetPolData ExpPL (GermanUL)`.SingleContribution IS NULL THEN 0
            ELSE `MonetPolData ExpPL (GermanUL)`.SingleContribution + CASE
                WHEN `MonetPolData ExpPL (GermanUL)`.RegularContribution IS NULL THEN 0
                ELSE `MonetPolData ExpPL (GermanUL)`.RegularContribution
            END
        END,
        `MonetPolData ExpPL (GermanUL)`.CommAccValDat = CASE
            WHEN `MonetPolData ExpPL (GermanUL)`.CommAccValDat + 12 * `MonetPolData ExpPL (GermanUL)`.ECValDat + 0.065 * (`MonetPolData ExpPL (GermanUL)`.CommAccValDat + 6 * `MonetPolData ExpPL (GermanUL)`.ECValDat) > 0 THEN 0
            ELSE `MonetPolData ExpPL (GermanUL)`.CommAccValDat + 12 * `MonetPolData ExpPL (GermanUL)`.ECValDat + 0.065 * (`MonetPolData ExpPL (GermanUL)`.CommAccValDat + 6 * `MonetPolData ExpPL (GermanUL)`.ECValDat)
        END,
        `MonetPolData ExpPL (GermanUL)`.ExpAccValDat = CASE
            WHEN `MonetPolData ExpPL (GermanUL)`.ExpAccValDat + 12 * `MonetPolData ExpPL (GermanUL)`.PCValDat + 0.065 * (`MonetPolData ExpPL (GermanUL)`.ExpAccValDat + 12 * `MonetPolData ExpPL (GermanUL)`.PCValDat) > 0 THEN 0
            ELSE `MonetPolData ExpPL (GermanUL)`.ExpAccValDat + 12 * `MonetPolData ExpPL (GermanUL)`.PCValDat + 0.065 * (`MonetPolData ExpPL (GermanUL)`.ExpAccValDat + 12 * `MonetPolData ExpPL (GermanUL)`.PCValDat)
        END,
        `MonetPolData ExpPL (GermanUL)`.SVValDat = CASE
            WHEN `FA` < 0 THEN 0
            ELSE `FA`
        END * (1 - 0.025 * (60 - CASE WHEN `PerIF` > 60 THEN 60 ELSE `PerIF` END) / 60),
        `MonetPolData ExpPL (GermanUL)`.ClawBackValDat = CASE
            WHEN `MonetPolData ExpPL (GermanUL)`.ClawBackValDat - 12 * `MonetPolData ExpPL (GermanUL)`.ECValDat < 0 THEN 0
            ELSE `MonetPolData ExpPL (GermanUL)`.ClawBackValDat - 12 * `MonetPolData ExpPL (GermanUL)`.ECValDat
        END,
        `MonetPolData ExpPL (GermanUL)`.DeathPerc = MonetPolData_GermanUL.DeathPerc;