DROP VIEW IF EXISTS `V13: Zillmer (new) by policy`;
CREATE VIEW `V13: Zillmer (new) by policy` AS
    SELECT
        MonetPolData.PolNo,
        MonetPolData.Branch,
        CalcProduct(Gewinnverband) AS Product,
        Bestandsreport.Währung AS Currency,
        MonetPolData.ClawBackValDat,
        MonetTermsheet.UFCperc,
        ClawBackValDat * IF(UFCperc = 0, 0, IF(UFCperc <= 0.04, 1, 0.04 / UFCperc)) AS Zillmer,
        Results_records.ZillmerValDat
    FROM
        MonetPolData
    LEFT JOIN
        Bestandsreport ON MonetPolData.PolNo = Bestandsreport.`Policy Nr`
    LEFT JOIN
        Results_records ON MonetPolData.PolNo = Results_records.PolNo
    LEFT JOIN
        MonetTermsheet ON MonetPolData.tariffCode = MonetTermsheet.tariffCode AND MonetPolData.TypeOfPrem = MonetTermsheet.TypeOfPrem;