CREATE FUNCTION ReinsuranceModel(StartDate DATE, BrokerHouse VARCHAR(255), Reinsured BOOLEAN) RETURNS VARCHAR(255)
BEGIN
    DECLARE reinsuranceModel VARCHAR(255);
    IF NOT Reinsured THEN
        SET reinsuranceModel = 'NotReinsured';
    ELSEIF StartDate < STR_TO_DATE('31-12-2007', '%d-%m-%Y') THEN
        SET reinsuranceModel = BrokerHouse;
    ELSEIF StartDate < STR_TO_DATE('31-12-2008', '%d-%m-%Y') THEN
        CASE BrokerHouse
            WHEN 'MPC' OR 'MPC Prime Basket' THEN
                IF StartDate < STR_TO_DATE('01-09-2008', '%d-%m-%Y') THEN
                    SET reinsuranceModel = 'MPC 2008';
                ELSE
                    SET reinsuranceModel = 'MPC 200809';
                END IF;
            ELSE
                SET reinsuranceModel = CONCAT(BrokerHouse, ' 2008');
        END CASE;
    ELSE
        CASE BrokerHouse
            WHEN 'MPC' OR 'MPC Prime Basket' THEN
                SET reinsuranceModel = 'MPC 200809';
            ELSE
                SET reinsuranceModel = 'NotReinsured';
        END CASE;
    END IF;
    RETURN reinsuranceModel;
END;