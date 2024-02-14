DROP VIEW IF EXISTS `Check 2 - new branches in termsheet`;
CREATE VIEW `Check 2 - new branches in termsheet` AS
    SELECT
        MonetPolData.Branch,
        MonetPolData.TypeOfPrem,
        Count(MonetPolData.PolNo) AS CountOfPolNo
    FROM
        MonetPolData
    LEFT JOIN
        `Monet TermSheet` ON MonetPolData.Branch = `Monet TermSheet`.Branch
    WHERE
        `Monet TermSheet`.Branch IS NULL
    GROUP BY
        MonetPolData.Branch, MonetPolData.TypeOfPrem;