UPDATE MonetInputsJOOL
LEFT JOIN PolicyValuesByStatus ON MonetInputsJOOL.PolNo = PolicyValuesByStatus.PolNo
SET
    MonetInputsJOOL.FundAccValDat = IF(Status = 'Other', 0, PolicyValuesByStatus.Value_EUR),
    MonetInputsJOOL.SVValDat = IF(Status = 'Other', 0, PolicyValuesByStatus.Value_EUR);