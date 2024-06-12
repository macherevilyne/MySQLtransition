DROP VIEW IF EXISTS `Q_TotalPremiumPerYear`;
CREATE VIEW `Q_TotalPremiumPerYear` AS
SELECT 
    `Policies`.`policy number`,
    `Policies`.`Quantum Status` AS `QLStatus`,
    `Policies`.`Commencement date` AS `DOC`,
    `Policies`.`RP_commencement_date` AS `DOCRP`,
    DATE_ADD(STR_TO_DATE((SELECT `DOC`), '%d-%m-%Y'), INTERVAL `total_term` MONTH) AS `DOT`,
    DATE_ADD(STR_TO_DATE(`Policies`.`cancellation date`, '%d-%m-%Y'), INTERVAL 1 DAY) AS `Cancel Date`,
    IF(STR_TO_DATE((SELECT `DOC`), '%d-%m-%Y') > STR_TO_DATE(`BOY`, '%d-%m-%Y'), STR_TO_DATE((SELECT `DOC`), '%d-%m-%Y'), STR_TO_DATE(`BOY`, '%d-%m-%Y')) AS `Start`,
    IF(ISNULL(STR_TO_DATE((SELECT `Cancel Date`), '%d-%m-%Y')) OR TIMESTAMPDIFF(MONTH, STR_TO_DATE((SELECT `DOT`), '%d-%m-%Y'), STR_TO_DATE((SELECT `Cancel Date`), '%d-%m-%Y')) > 0,
        IF(TIMESTAMPDIFF(MONTH, STR_TO_DATE((SELECT `DOT`), '%d-%m-%Y'), STR_TO_DATE(`EOY`, '%d-%m-%Y')) > 0, STR_TO_DATE((SELECT `DOT`), '%d-%m-%Y'),
            IF(TIMESTAMPDIFF(MONTH, STR_TO_DATE((SELECT `Cancel Date`), '%d-%m-%Y'), STR_TO_DATE(`EOY`, '%d-%m-%Y')) > 0, STR_TO_DATE((SELECT `Cancel Date`), '%d-%m-%Y'), STR_TO_DATE(`EOY`, '%d-%m-%Y'))),
        IF(TIMESTAMPDIFF(MONTH, STR_TO_DATE((SELECT `Cancel Date`), '%d-%m-%Y'), STR_TO_DATE(`EOY`, '%d-%m-%Y')) > 0, STR_TO_DATE((SELECT `Cancel Date`), '%d-%m-%Y'), STR_TO_DATE(`EOY`, '%d-%m-%Y'))) AS `End`,
    DATE_ADD(STR_TO_DATE((SELECT `DOC`), '%d-%m-%Y'), INTERVAL YEAR(STR_TO_DATE(`BOY`, '%d-%m-%Y')) - YEAR(STR_TO_DATE((SELECT `DOC`), '%d-%m-%Y')) YEAR) AS `Anniversary`,
    IF(TIMESTAMPDIFF(MONTH, STR_TO_DATE((SELECT `Start`), '%d-%m-%Y'), STR_TO_DATE((SELECT `End`), '%d-%m-%Y')) < 0, 0, TIMESTAMPDIFF(MONTH, STR_TO_DATE((SELECT `Start`), '%d-%m-%Y'), STR_TO_DATE((SELECT `End`), '%d-%m-%Y'))) AS `Period`,
    IF(TIMESTAMPDIFF(MONTH, STR_TO_DATE((SELECT `Start`), '%d-%m-%Y'), STR_TO_DATE((SELECT `Anniversary`), '%d-%m-%Y')) >= 0 AND TIMESTAMPDIFF(MONTH, STR_TO_DATE((SELECT `Anniversary`), '%d-%m-%Y'), STR_TO_DATE((SELECT `End`), '%d-%m-%Y')) > 0, 1, 0) AS `InPeriod`,
    `Policies`.`Premium payment` AS `Freq`,
    IF((SELECT `Freq`) = "Monthly premium" OR (SELECT `Freq`) = "Combination direct", (SELECT `Period`),
        IF((SELECT `Freq`) = "Yearly premium", (SELECT `InPeriod`), 0)) AS `Amount`,
    IF((SELECT `Freq`) = "Combination postponed",
        IF(TIMESTAMPDIFF(MONTH, STR_TO_DATE((SELECT `DOCRP`), '%d-%m-%Y'), STR_TO_DATE((SELECT `Start`), '%d-%m-%Y')) > 0, (SELECT `Amount`),
            IF(TIMESTAMPDIFF(MONTH, STR_TO_DATE((SELECT `DOCRP`), '%d-%m-%Y'), STR_TO_DATE((SELECT `End`), '%d-%m-%Y')) > 0, TIMESTAMPDIFF(MONTH, STR_TO_DATE((SELECT `DOCRP`), '%d-%m-%Y'), STR_TO_DATE((SELECT `End`), '%d-%m-%Y')), 0)), 0) AS `AmountPostPoned`,
    IF(ISNULL(`RP net premium`), 0, `RP net premium`) + IF(ISNULL(`En Block 2011`), 0, `En Block 2011`) AS `QP`,
    IF(ISNULL(`SP net premium`), 0, `SP net premium`) AS `QP Single`,
    (SELECT `QP`) * ((SELECT `Amount`) + (SELECT `AmountPostPoned`)) AS `TotalRegular`,
    IF(STR_TO_DATE((SELECT `Anniversary`), '%d-%m-%Y') = STR_TO_DATE((SELECT `DOC`), '%d-%m-%Y'), (SELECT `QP Single`), 0) - IF(YEAR(STR_TO_DATE((SELECT `Cancel Date`), '%d-%m-%Y')) = YEAR(STR_TO_DATE(`BOY`, '%d-%m-%Y')), (SELECT `QP Single`), 0) AS `TotalSingle`
FROM 
    `Policies`
WHERE 
    ((`Policies`.`Quantum Status` = "Active" OR `Policies`.`Quantum Status` = "Lapsed"));