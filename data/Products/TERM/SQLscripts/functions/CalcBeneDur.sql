CREATE FUNCTION CalcBeneDur(BeneDuration VARCHAR(255))
RETURNS INT
BEGIN
    DECLARE DurDef INT;

    CASE
        WHEN BeneDuration = 'Short' THEN
            SET DurDef = 24;
        WHEN BeneDuration = 'Basic' THEN
            SET DurDef = 60;
        WHEN BeneDuration IN ('Extended', 'Enddate') THEN
            SET DurDef = 999;
        ELSE
            SET DurDef = CAST(REPLACE(BeneDuration, ' months', '') AS SIGNED);
    END CASE;

    RETURN DurDef;
END;