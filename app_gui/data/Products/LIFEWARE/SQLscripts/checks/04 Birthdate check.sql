INSERT INTO `Error Table` (`Policy Nr`, Error, Warning, `Data Value`)
SELECT
    Bestandsreport.`Policy Nr`,
    CASE
        WHEN Bestandsreport.Birthdate IS NULL THEN 'Birthdate empty'
        ELSE ''
    END AS Error,
    CASE
        WHEN Bestandsreport.Birthdate IS NULL THEN ''
        WHEN (YEAR(STR_TO_DATE(`Bestandsreport`.`Start`, '%d.%m.%Y')) - YEAR(STR_TO_DATE(`Bestandsreport`.`Birthdate`, '%d.%m.%Y'))) > 80 OR (YEAR(STR_TO_DATE(`Bestandsreport`.`Start`, '%d.%m.%Y')) - YEAR(STR_TO_DATE(`Bestandsreport`.`Birthdate`, '%d.%m.%Y'))) < 15 THEN 'Age >80 or Age<15'
        ELSE ''
    END AS Warning,
    TIMESTAMPDIFF(YEAR, STR_TO_DATE(`Bestandsreport`.`Birthdate`, '%d.%m.%Y'), STR_TO_DATE(`Bestandsreport`.`Start`, '%d.%m.%Y')) AS Ausdr1
FROM Bestandsreport
WHERE
    Bestandsreport.Birthdate IS NULL OR
    (YEAR(STR_TO_DATE(`Bestandsreport`.`Start`, '%d.%m.%Y')) - YEAR(STR_TO_DATE(`Bestandsreport`.`Birthdate`, '%d.%m.%Y'))) > 80 OR
    (YEAR(STR_TO_DATE(`Bestandsreport`.`Start`, '%d.%m.%Y')) - YEAR(STR_TO_DATE(`Bestandsreport`.`Birthdate`, '%d.%m.%Y'))) < 15;