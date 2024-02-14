CREATE TABLE IF NOT EXISTS CompletnessTable(
   `PolNo` TEXT,
   `ClaimID` TEXT,
   `Error` VARCHAR(50)
   );

INSERT INTO CompletnessTable(`ClaimID`, `Error`)
SELECT `RC Claims`.`Policy number`,
"RC policy number not in claims report" AS `Error`
FROM (`RC Claims` LEFT JOIN ClaimsPolicy ON `RC Claims`.`Policy number` = `ClaimsPolicy`.`policy_id`) LEFT JOIN Claims ON `ClaimsPolicy`.`claim_id` = `Claims`.`claim_id`
WHERE (((`Claims`.`eerste_polis_nummer`) Is Null));