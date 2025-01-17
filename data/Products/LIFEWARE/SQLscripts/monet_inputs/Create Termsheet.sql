CREATE TABLE `MonetTermsheet` AS
    SELECT
        `Tariff Symbol` AS tariffCode,
        'RP' AS TypeOfPrem,
        `IMC_RP` AS IMCperc,
        IMCmin,
        IMCmax,
        IPC_RP AS IPC,
        CASE WHEN `AMC Base` = 'Premium' THEN 0 ELSE `AMC` END AS AMCperc,
        AMCmin,
        AMCmax,
        PF,
        CASE WHEN `AMC Base` = 'Premium' THEN `AMC` ELSE 0 END AS AMCpercP,
        `UFC_RPmax` AS UFCperc,
        `UFC_RPmin` AS UFC_minperc,
        DurMaxCommY,
        `RC` AS RCperc,
        OPC AS OPCperc,
        `RPC` AS RPCperc,
        DurPCY,
        DurECY,
        0 AS TaxRatePrem,
        `CoCY` AS CoCY,
        `DurSCY - RP` AS DurSCY,
        `Surrender charge initialRate` AS SVchargePerc,
        1 - `facdeath` AS facdeath,
        1.01 AS MinDeathBenefitFactor,
        RateAmmort,
        `Surrender fee` AS SurrenderFee,
        CASE WHEN `Tariff Symbol` LIKE 'wnb*' THEN 0.007 ELSE 0 END AS KickbackQLperc,
        0 AS KickbackBrokerPerc,
        0 AS IPCbroker,
        0 AS PFbroker,
        0 AS IMCpercBroker,
        CASE WHEN `AAC Base` = 'Premium' THEN 0 ELSE `AAC` END AS AMCpercBroker,
        CASE WHEN `AAC Base` = 'Premium' THEN `AAC` ELSE 0 END AS AMCpercPBroker,
        facdeath AS Rbperc,
        Tax AS Tax_effperc,
        0 AS DurMaxLB,
        0 AS SF_LBperc,
        0 AS LBperc,
        0 AS PerLoy
    FROM `TermsheetReport`;
