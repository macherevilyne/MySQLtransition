DROP VIEW IF EXISTS `Q_RIFixedExp`;
CREATE VIEW `Q_RIFixedExp` AS
SELECT
    `Policies`.`Quantum status`,
    `Policies`.`policy terms`,
    COUNT(`Policies`.`policy number`) AS `CountOfpolicy number`
FROM
    `Policies`
WHERE
    STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y') < STR_TO_DATE('{ValDat}', '%d-%m-%Y')
    AND `Policies`.`Quantum status` = "Active"
    AND `Policies`.`policy terms` IN (
        'QL_MLB_06_2019',
        'QL_GG_2020_06',
        'QL_MLB_2021_02',
        'QL_MLB_2021_11',
        'QL_MLBZ_2022_02'
    )
GROUP BY
    `Policies`.`Quantum status`,
    `Policies`.`policy terms`;
