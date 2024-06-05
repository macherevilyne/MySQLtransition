DROP VIEW IF EXISTS `Q_FIBAS_TermLife`;
CREATE VIEW `Q_FIBAS_TermLife` AS
SELECT 
    COUNT(`Policies`.`policy number`) AS `Anzahlvonpolicy number`,
    `Policies`.`Quantum status`,
    '{producttype}' AS `producttype`,
    `Policies`.`benefit_duration_term_life`,
    SUM(`Policies`.`RP insurance amount`) AS `SummevonRP insurance amount`,
    SUM(`Policies`.`RP net premium FIB`) AS `SummevonRP net premium FIB`,
    SUM(`Policies`.`SP insurance amount`) AS `SummevonSP insurance amount`,
    SUM(`Policies`.`SP net premium FIB`) AS `SummevonSP net premium FIB`,
    SUM((`Policies`.`RP insurance amount` + `Policies`.`SP insurance amount`) * 
        IF(`Policies`.`benefit_duration_term_life` = "Standaard", 12,
           IF(`Policies`.`benefit_duration_term_life` = "Kort", 24,
              IF(`Policies`.`benefit_duration_term_life` = "Basic", 60, 240)))) AS `RiskSum`
FROM 
    `Policies`
GROUP BY 
    `Policies`.`Quantum status`,
    '{producttype}',
    `Policies`.`benefit_duration_term_life`
HAVING 
    (((`Policies`.`Quantum status`) = "Active")
    AND (('{producttype}') = "new")
    AND ((`Policies`.`benefit_duration_term_life`) IS NOT NULL));