CREATE FUNCTION MonetTariff(StartDate DATE, PremType VARCHAR(255), PolNo VARCHAR(255)) RETURNS VARCHAR(255)
BEGIN
    DECLARE tariff VARCHAR(255);
    IF LEFT(PolNo, 3) = 'OIP' THEN
        IF StartDate < STR_TO_DATE('01-10-2009', '%d-%m-%Y') THEN
            SET tariff = 'OIP-001';
        ELSE
            SET tariff = 'OIP-002';
        END IF;
    ELSE
        CASE PremType
            WHEN 'RP' THEN
                IF StartDate < STR_TO_DATE('31-12-2007', '%d-%m-%Y') THEN
                    SET tariff = 'FLV-001';
                ELSE
                    SET tariff = 'FLV-002';
                END IF;
            WHEN 'SP' THEN
                SET tariff = 'FLV-001';
        END CASE;
    END IF;
    RETURN tariff;
END;