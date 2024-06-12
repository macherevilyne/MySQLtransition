INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Cancel Date` IS NULL,
        'Cancel date empty',
        'Invalid cancel date'
    ) AS Error,
    'Cancel Date' AS Variable,
    Policydata_to_Quantum_ORIGINAL.`Cancel Date` AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
    ) AS Status
FROM
    Policydata_to_Quantum_ORIGINAL
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.`Cancel Date` IS NULL
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) IN ('Lapsed', 'Death')
        )
    )
    OR (
        STR_TO_DATE(Policydata_to_Quantum_ORIGINAL.`Cancel Date`, '%Y-%m-%d') < STR_TO_DATE(Policydata_to_Quantum_ORIGINAL.DOC, '%d-%m-%Y')
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) IN ('Lapsed', 'Death')
        )
    );