CREATE FUNCTION CalcProduct(GV VARCHAR(255)) RETURNS VARCHAR(255)
BEGIN
    DECLARE result VARCHAR(255);
    SET result =
        CASE
            WHEN GV = 'OIP' THEN 'OIP'
            WHEN GV IN ('LUX', 'KID') THEN 'Swiss'
            WHEN GV = 'POLAND' THEN 'POLAND'
            WHEN GV = 'SPAIN' THEN 'SPAIN'
            WHEN GV = 'CZECH (FINC)' THEN 'CZECH'
            WHEN GV IN ('SIB', 'SIBA', 'SIBAB', 'SIBNL', 'ISIB', 'APL (EUR)', 'EXPO', 'FCM (EUR)', 'INF', 'MABEL', 'NPB (EUR)', 'PEP', 'PRD (EUR)', 'QCPB', 'QLPB (EUR)', 'QNPB (EUR)', 'QSCB (EUR)', 'TPF (EUR)', 'WTE-AT', 'WTE-DE') THEN 'PB'
            WHEN GV IN ('SIB (USD)', 'ISIB (USD)', 'MAUCO (USD)', 'MAUCO (QL)', 'NPB (USD)', 'QLPB (USD)', 'QNPB (USD)', 'QRB (USD)', 'UPB (USD)', 'FLPB') THEN 'PBUSD'
            WHEN GV IN ('ISIB (GBP)', 'QGA', 'QGB', 'FCM (GBP)', 'MPB (GBP)', 'QLIB', 'QLPB (GBP)', 'QNPB (GBP)', 'QRB (GBP)', 'QSCB (GBP)', 'TPF (GBP)') THEN 'PBGBP'
            WHEN GV IN ('APL (CHF)', 'PRD (CHF)') THEN 'PBCHF'
            WHEN GV = 'PRD AP (EUR)' THEN 'AP'
            WHEN GV IN ('UL 07 - AT', 'UL MS 14 - AT', 'UL MS 15 - AT') THEN 'Austrian UL'
            WHEN GV IN ('UL 07', 'RUERUP') THEN 'German UL'
            ELSE 'Error'
        END;
    RETURN result;
END;