CREATE FUNCTION AnnualPremium (RP DOUBLE, SP DOUBLE, freq INT)
    RETURNS DOUBLE
BEGIN
    DECLARE annualPremium DOUBLE;
    IF RP IS NULL THEN
        SET annualPremium = 0; -- Single
    ELSE
        SET annualPremium = RP * freq;
    END IF;
    RETURN annualPremium;
END