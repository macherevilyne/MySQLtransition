DROP VIEW IF EXISTS `Q_Errors`;
CREATE VIEW `Q_Errors` AS
    SELECT
        `Error Table`.`Policy Nr` AS `CountOfPolicy Nr`,
        `Error Table`.Error,
        `Error Table`.`Data Value` AS `FirstOfData Value`
    FROM `Error Table`
    LEFT JOIN Bestandsreport ON `Error Table`.`Policy Nr` = Bestandsreport.`Policy Nr`
    WHERE `Error Table`.Error <> '' AND Bestandsreport.Status = 'true';