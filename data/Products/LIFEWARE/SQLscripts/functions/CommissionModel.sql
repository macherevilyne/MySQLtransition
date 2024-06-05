CREATE FUNCTION CommissionModel(StartDate DATE, BrokerHouse VARCHAR(255), PremType VARCHAR(255)) RETURNS VARCHAR(255)
BEGIN
    DECLARE commissionModel VARCHAR(255);
    CASE PremType
        WHEN 'RP' THEN
            IF StartDate < STR_TO_DATE('31-12-2008', '%d-%m-%Y') THEN
                SET commissionModel = 'Upfront';
            ELSE
                CASE BrokerHouse
                    WHEN 'MPC' OR 'MPC Prime Basket' THEN
                        SET commissionModel = 'Upfront';
                    WHEN 'OIP' THEN
                        SET commissionModel = 'OIP01';
                    WHEN 'RWB Partners GmbH - DE' OR 'RWB Partners GmbH - AT' THEN
                        SET commissionModel = 'Upfront';
                    WHEN 'DSC Deutsche SachCapital GmbH' THEN
                        SET commissionModel = 'Upfront';
                    WHEN 'Energy Capital Invest Life AG' THEN
                        SET commissionModel = 'ECI_60_20_10_0_10';
                    WHEN 'Plentum Vertriebsgesellschaft mbH - MSP AT' OR 'Plentum Vertriebsgesellschaft mbH - Belle Epoque' OR 'Plentum Vertriebsgesellschaft mbH - MSP DE' THEN
                        SET commissionModel = 'Insolvent';
                    ELSE
                        SET commissionModel = 'Spread_60_20_20';
                END CASE;
            END IF;
        WHEN 'SP' THEN
            SET commissionModel = 'Upfront';
    END CASE;
    RETURN commissionModel;
END;