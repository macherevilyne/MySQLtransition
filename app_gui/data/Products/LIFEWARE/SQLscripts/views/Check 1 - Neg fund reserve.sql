DROP VIEW IF EXISTS `Check 1 - Neg fund reserve`;
CREATE VIEW `Check 1 - Neg fund reserve` AS
    SELECT
        `Bestandsreport`.`Policy Nr`,
        `Bestandsreport`.`Branch`,
        `Bestandsreport`.`Broker ID`,
        `Bestandsreport`.`Start`,
        `Bestandsreport`.`Regular Premium (EUR)` AS Expr1,
        `Bestandsreport`.`Due Regular Premiums (EUR)` AS Expr2,
        `Bestandsreport`.`Due Single Premium (EUR)` AS Expr3,
        `Bestandsreport`.`Current Account (EUR)` AS Expr4,
        `Bestandsreport`.`Transaction Account (EUR)` AS Expr5,
        `Bestandsreport`.`Fund Reserve (EUR)` AS Expr6,
        `Bestandsreport`.`Surrender Value (EUR)` AS Expr7,
        `Bestandsreport`.`Clawback (EUR)` AS Expr8
    FROM
        `Bestandsreport`
    WHERE
        `Bestandsreport`.`Fund Reserve (EUR)` < 0
    ORDER BY
        `Bestandsreport`.`Fund Reserve (EUR)` DESC;