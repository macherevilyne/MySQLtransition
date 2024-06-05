UPDATE
    MonetTermsheet
INNER JOIN AMCCurrent ON MonetTermsheet.tariffCode = AMCCurrent.`Tariff Symbol`
SET MonetTermsheet.AMCperc = AMCCurrent.AMCcurrent;