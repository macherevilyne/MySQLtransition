UPDATE `MonetInputs RF Actives`
    LEFT JOIN `MonetInputsUpdated` ON `MonetInputs RF Actives`.`PolNo` = `MonetInputsUpdated`.`PolNo`
    SET `MonetInputs RF Actives`.`PeriodIF` = `MonetInputsUpdated`.`PeriodIF`
WHERE (((`MonetInputs RF Actives`.Status)="active"));