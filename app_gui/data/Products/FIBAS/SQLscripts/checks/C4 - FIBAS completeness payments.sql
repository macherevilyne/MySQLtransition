INSERT INTO CompletnessTable(`ClaimID`, `Error`)
SELECT `RC Claims`.`Policy number`, "RC has a payment which is not in claims report" AS `Error`
FROM (`RC Claims`
    LEFT JOIN `ClaimsPolicy` ON `RC Claims`.`Policy number` = `ClaimsPolicy`.`policy_id`)
        LEFT JOIN `Claims` ON `ClaimsPolicy`.`claim_id` = `Claims`.`claim_id`
GROUP BY `RC Claims`.`Policy number`
HAVING (((Sum(`RC Claims`.`Amount`))<0) AND ((Sum(`Claims`.`reserveringen_betaald`))>=0));