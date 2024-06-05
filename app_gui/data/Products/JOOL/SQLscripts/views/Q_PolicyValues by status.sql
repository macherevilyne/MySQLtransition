DROP VIEW IF EXISTS `Q_PolicyValues by status`;
CREATE VIEW `Q_PolicyValues by status` AS
SELECT
    PolicyValues_All.PolNo,
    CASE
        WHEN LEFT(PolicyValues_All.PolNo, 3) = 'FAS' OR LEFT(PolicyValues_All.PolNo, 3) = 'FBS' THEN 'SEK'
        WHEN LEFT(PolicyValues_All.PolNo, 3) = 'FBN' THEN 'NOK'
        ELSE 'EUR'
    END AS Curr,
    PolicyValues_All.`Market Value`,
    CASE
        WHEN PolicyValues_Issued.PolNo IS NULL THEN
            CASE
                WHEN PolicyValues_PendingDeath.PolNo IS NULL THEN
                    CASE
                        WHEN PolicyValues_PendingSurrender.PolNo IS NULL THEN 'Other'
                        ELSE 'PendingSurrender'
                    END
                ELSE 'PendingDeath'
            END
        ELSE 'Issued'
    END AS Status
FROM
    (PolicyValues_All
        LEFT JOIN PolicyValues_Issued ON PolicyValues_All.PolNo = PolicyValues_Issued.PolNo)
    LEFT JOIN PolicyValues_PendingDeath ON PolicyValues_All.PolNo = PolicyValues_PendingDeath.PolNo
    LEFT JOIN PolicyValues_PendingSurrender ON PolicyValues_All.PolNo = PolicyValues_PendingSurrender.PolNo;