CREATE FUNCTION PremiumSum(RP DOUBLE, SP DOUBLE, freq INT, term INT) RETURNS DOUBLE
BEGIN
    DECLARE premiumSum DOUBLE;
    IF RP IS NULL THEN
        SET premiumSum = SP;
    ELSE
        SET premiumSum = RP * freq * term + SP;
    END IF;
    RETURN premiumSum;
END;