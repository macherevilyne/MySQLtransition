CREATE FUNCTION PremiumFreq(RP DOUBLE, SP DOUBLE, freq INT) RETURNS INT
BEGIN
    DECLARE premiumFreq INT;
    IF RP IS NULL THEN
        SET premiumFreq = 99; -- Single
    ELSE
        SET premiumFreq = freq;
    END IF;
    RETURN premiumFreq;
END;