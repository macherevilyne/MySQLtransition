CREATE FUNCTION MonetTariffNew(StartDate DATE, PremType VARCHAR(255), GV VARCHAR(255)) RETURNS VARCHAR(255)
BEGIN
    DECLARE tariff VARCHAR(255);
    IF GV = 'OIP' THEN
        IF StartDate < STR_TO_DATE('01-10-2009', '%d-%m-%Y') THEN
            SET tariff = 'OIP-001';
        ELSE
            SET tariff = 'OIP-002';
        END IF;
    ELSEIF GV LIKE 'SIB%' OR GV LIKE 'ISIB%' THEN
        SET tariff = 'PB-001';
    ELSEIF GV = 'QGA' THEN
        SET tariff = 'PB-001';
    ELSEIF GV = 'QGB' THEN
        SET tariff = 'PB-002';
    ELSEIF GV IN ('EXPO', 'FLPB', 'INF', 'MABEL', 'PEP', 'WTE-AT', 'WTE-DE') OR GV LIKE 'APL%' OR GV LIKE 'FCM%' OR GV LIKE 'MAUCO%' OR GV LIKE 'MPB%' OR GV LIKE 'NPB%' OR GV LIKE 'PRD%' OR GV = 'QCPB' OR GV = 'QLIB' OR GV LIKE 'QLPB%' OR GV LIKE 'QNPB%' OR GV LIKE 'QRB%' OR GV LIKE 'QSCB%' OR GV LIKE 'TPF%' OR GV LIKE 'UPB%' THEN
        SET tariff = 'PB-001';
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