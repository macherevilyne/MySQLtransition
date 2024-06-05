DROP TABLE IF EXISTS `Policydata_to_Quantum_ORIGINAL_PrevY`;
CREATE TABLE IF NOT EXISTS `Policydata_to_Quantum_ORIGINAL_PrevY` AS
    SELECT *
FROM `{db_name_previous_year}`.`Policydata_to_Quantum_ORIGINAL`;