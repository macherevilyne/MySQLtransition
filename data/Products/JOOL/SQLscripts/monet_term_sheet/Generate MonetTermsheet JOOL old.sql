CREATE TABLE IF NOT EXISTS TermsheetJOOL AS
SELECT
    CostParameters.polno AS Branch,
    "PB-001" AS Tariff,
    "SP" AS TypeOfPrem,
    0 AS IMCperc,
    0 AS IMCmax,
    0 AS IMCmin,
    0 AS IMCpercBroker,
    0 AS IPC,
    0 AS IPCbroker,
    CostParameters.JOOL_Comm_PERC AS UFCperc,
    0 AS DurMaxCommY,
    CostParameters.Dur_IMC_Amortized AS DurECY,
    0 AS DurPCY,
    CostParameters.Init_StampTax_PERC AS TaxRatePrem,
    CostParameters.CoCY AS CoCY,
    CostParameters.CoCY AS RateAmmort,
    0 AS RCperc,
    0 AS RPCperc,
    IFNULL(MonetInputsJOOL.Term, 0) AS DurSCY,
    IF(
        PolicyData.PolicyValue <= 0
        OR ISNULL(MonetInputsJOOL.PeriodIF)
        OR DurSCY <= MonetInputsJOOL.PeriodIF / 12,
        0,
        IF(
            (PolicyData.PolicyValue - PolicyData.SVValDat - PolicyData.SCIMCAmortized) / PolicyData.PolicyValue * DurSCY / (DurSCY - MonetInputsJOOL.PeriodIF / 12) > DurSCY / (DurSCY - MonetInputsJOOL.PeriodIF / 12),
            DurSCY / (DurSCY - MonetInputsJOOL.PeriodIF / 12),
            (PolicyData.PolicyValue - PolicyData.SVValDat - PolicyData.SCIMCAmortized) / PolicyData.PolicyValue * DurSCY / (DurSCY - MonetInputsJOOL.PeriodIF / 12)
        )
    ) AS SVchargePerc,
    0 AS aggio,
    CostParameters.TC_QL * CostParameters.EUR AS SurrenderFee,
    CostParameters.APF_QL * CostParameters.EUR AS PF,
    CostParameters.APF_JOOL * CostParameters.EUR AS PFbroker,
    IF(MonetInputsJOOL.PeriodIF / 12 < PolicyData.Term, CostParameters.AMC_QL_DURING_PERC, CostParameters.AMC_QL_AFTER_PERC) AS AMCperc,
    IF(MonetInputsJOOL.PeriodIF / 12 < PolicyData.Term, CostParameters.AMC_JOOL_DURING_PERC, CostParameters.AMC_JOOL_AFTER_PERC) AS AMCpercBroker,
    0 AS AMCpercP,
    0 AS AMCpercPBroker,
    IF(CostParameters.AMC_QL_DURING_Basis = "MaxValFixed" OR CostParameters.AMC_QL_DURING_Basis = "Fixed", CostParameters.AMC_QL_AFTER_FIXED * CostParameters.EUR, 0) AS AMCmin,
    999999 AS AMCmax,
    0 AS facdeath,
    1.01 AS MinDeathBenefitFactor,
    0 AS KickbackQLperc,
    0 AS KickbackBrokerPerc,
    CostParameters.Surrender_StampTax_PERC AS Tax_effperc,
    0 AS PerLoy,
    0 AS DurMaxLB,
    0 AS LBperc,
    0 AS SF_LBperc,
    0 AS UFC_minperc
FROM
    CostParameters
LEFT JOIN ROE ON CostParameters.APFCurr = ROE.Currency
LEFT JOIN MonetInputsJOOL ON CostParameters.polno = MonetInputsJOOL.Branch
LEFT JOIN PolicyData ON CostParameters.polno = PolicyData.polno;