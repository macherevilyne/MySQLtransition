INSERT INTO DBCErrorTable(`Claim ID`, `Error`, `Variable`, `Value`, `Status`)
SELECT `Claims`.`claim_id`,
IF(ISNULL(`status`),"status empty","Invalid status") AS `Error`,
"status" AS `Variable`,
`Claims`.`status` AS `Value`,
`Claims`.`status` AS `Status`
FROM `Claims`
WHERE (((`Claims`.`status`)<>"APPEAL_PROCEDURE"
And (`Claims`.`status`)<>"CANCELED"
And (`Claims`.`status`)<>"CLOSED"
And (`Claims`.`status`)<>"DECLINED"
And (`Claims`.`status`)<>"EMPLOYMENT_EVALUATION"
And (`Claims`.`status`)<>"EMPLOYMENT_REEVALUATION"
And (`Claims`.`status`)<>"ENDED"
And (`Claims`.`status`)<>"ENDED_APPEAL_PROCEDURE"
And (`Claims`.`status`)<>"ENTERED"
And (`Claims`.`status`)<>"INSURER_ASSESSMENT"
And (`Claims`.`status`)<>"INSURER_REASSESSMENT"
And (`Claims`.`status`)<>"OWN_RISK_PERIOD"
And (`Claims`.`status`)<>"PAYMENT_AUTOMATED"
And (`Claims`.`status`)<>"PAYMENT_PREPARATION"
And (`Claims`.`status`)<>"PAYMENT_PREPARED"
And (`Claims`.`status`)<>"PREPARED_FOR_ACCEPTANCE"
And (`Claims`.`status`)<>"PREPARED_FOR_DECLINE"
And (`Claims`.`status`)<>"WAITING_FOR_INFORMATION"
And (`Claims`.`status`)<>"PAYMENT_PROPOSED"
And (`Claims`.`status`)<>"PRE_SCREENING"
And (`Claims`.`status`)<>"PAYMENT_POSTPONED"))
    Or (((Claims.status) Is Null));