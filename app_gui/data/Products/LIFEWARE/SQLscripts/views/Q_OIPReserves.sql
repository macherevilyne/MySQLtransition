DROP VIEW IF EXISTS `Q_OIPReserves`;
CREATE VIEW `Q_OIPReserves` AS
    SELECT
        Results_records_old.PolNo,
        CalcProduct(Bestandsreport.`Gewinnverband`) AS Expr1,
        Results_records_old.ReserveValDat, Bestandsreport.`Fund Reserve`
    FROM Results_records_old
    LEFT JOIN Bestandsreport ON Results_records_old.PolNo = Bestandsreport.`Policy Nr`
    WHERE CalcProduct(Bestandsreport.`Gewinnverband`) = 'OIP';