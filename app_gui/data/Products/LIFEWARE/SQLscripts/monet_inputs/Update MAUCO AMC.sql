UPDATE MonetTermsheet
    SET MonetTermsheet.AMCperc = `MAUCO AMC`
WHERE (MonetTermsheet.tariffCode LIKE 'MAUCO%' OR MonetTermsheet.tariffCode = 'QLSF100');