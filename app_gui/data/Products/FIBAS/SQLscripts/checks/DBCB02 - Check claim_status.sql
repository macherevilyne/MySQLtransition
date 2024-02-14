INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`claim_status`),"claim_status empty","Invalid claim_status") AS `Error`,
"claim_status" AS `Variable`,
`ClaimsBasic`.`claim_status` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`claim_status`)<>"APPEAL_PROCEDURE"
And (`ClaimsBasic`.`claim_status`)<>"CANCELED"
And (`ClaimsBasic`.`claim_status`)<>"CLOSED"
And (`ClaimsBasic`.`claim_status`)<>"DECLINED"
And (`ClaimsBasic`.`claim_status`)<>"EMPLOYMENT_EVALUATION"
And (`ClaimsBasic`.`claim_status`)<>"EMPLOYMENT_REEVALUATION"
And (`ClaimsBasic`.`claim_status`)<>"ENDED"
And (`ClaimsBasic`.`claim_status`)<>"ENDED_APPEAL_PROCEDURE"
And (`ClaimsBasic`.`claim_status`)<>"ENTERED"
And (`ClaimsBasic`.`claim_status`)<>"INSURER_ASSESSMENT"
And (`ClaimsBasic`.`claim_status`)<>"INSURER_REASSESSMENT"
And (`ClaimsBasic`.`claim_status`)<>"OWN_RISK_PERIOD"
And (`ClaimsBasic`.`claim_status`)<>"PAYMENT_AUTOMATED"
And (`ClaimsBasic`.`claim_status`)<>"PAYMENT_PREPARATION"
And (`ClaimsBasic`.`claim_status`)<>"PAYMENT_PREPARED"
And (`ClaimsBasic`.`claim_status`)<>"PREPARED_FOR_ACCEPTANCE"
And (`ClaimsBasic`.`claim_status`)<>"PREPARED_FOR_DECLINE"
And (`ClaimsBasic`.`claim_status`)<>"WAITING_FOR_INFORMATION"
And (`ClaimsBasic`.`claim_status`)<>"PAYMENT_PROPOSED"
And (`ClaimsBasic`.`claim_status`)<>"PRE_SCREENING"
And Not (`ClaimsBasic`.`claim_status`)="PAYMENT_POSTPONED"))
    Or (((`ClaimsBasic`.`claim_status`) Is Null));