UPDATE MonetInputsJOOL_Spread
SET FundAccValDat = FundAccValDat * (1 - `Perc Bonds` * `Spread shock`);