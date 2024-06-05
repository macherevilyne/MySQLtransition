INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL_PrevY.`Policy Nr`,
    'Policy number has vanished' AS Error,
    'Policy Nr' AS Variable,
    Policydata_to_Quantum_ORIGINAL.`Policy Nr` AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL_PrevY.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL_PrevY.`Internal status`)
    ) AS Status
FROM
    Policydata_to_Quantum_ORIGINAL_PrevY
    LEFT JOIN Policydata_to_Quantum_ORIGINAL ON Policydata_to_Quantum_ORIGINAL_PrevY.`Policy Nr` = Policydata_to_Quantum_ORIGINAL.`Policy Nr`
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.`Policy Nr` IS NULL
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL_PrevY.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL_PrevY.`Internal status`)
            ) IN ('Active', 'Lapsed')
        )
    );