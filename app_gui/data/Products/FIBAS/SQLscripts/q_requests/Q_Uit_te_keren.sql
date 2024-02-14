DROP VIEW IF EXISTS `Q_Uit_te_keren`;
CREATE VIEW `Q_Uit_te_keren` AS
SELECT 
    `DBCBErrorTable`.`Claim ID`,
    `DBCBErrorTable`.Error,
    `DBCBErrorTable`.`Status`,
    `ClaimsBasic`.`totaal_verzekerd_bedrag`,
    `ClaimsBasic`.`totaal_uit_te_keren_bedrag`
FROM 
    `DBCBErrorTable` 
LEFT JOIN 
    `ClaimsBasic` ON `DBCBErrorTable`.`Claim ID` = `ClaimsBasic`.`claim_id`
WHERE 
    `DBCBErrorTable`.`Error` = "Invalid totaal_uit_te_keren_bedrag";