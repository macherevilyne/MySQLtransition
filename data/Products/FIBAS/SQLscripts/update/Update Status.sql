UPDATE `MonetInputs Status`
LEFT JOIN `MonetInputsUpdated` ON `MonetInputs Status`.`PolNo` = `MonetInputsUpdated`.`PolNo`
    SET `MonetInputs Status`.`PeriodIF` = `MonetInputsUpdated`.`PeriodIF`,
        `MonetInputs Status`.Status = `MonetInputsUpdated`.`Status`,
        `MonetInputs Status`.PeriodDisable = `MonetInputsUpdated`.`PeriodDisable`,
        `MonetInputs Status`.`PercentageDisable` = `MonetInputsUpdated`.`PercentageDisable`,
        `MonetInputs Status`.`MonthlyBenefit` = `MonetInputsUpdated`.`MonthlyBenefit`,
        `MonetInputs Status`.ClaimReserveValDate = `MonetInputsUpdated`.`ClaimReserveValDate`,
        `MonetInputs Status`.`OccurrenceYear` = `MonetInputsUpdated`.`OccurrenceYear`,
        `MonetInputs Status`.RIModel = `MonetInputsUpdated`.`RIModel`;