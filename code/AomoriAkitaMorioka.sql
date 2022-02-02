DROP TABLE ESTAT.SoyData

CREATE TABLE ESTAT.SoyData
(TimeCodeJP VARCHAR(50),AreaCodeJP VARCHAR(50),TimeCode INTEGER,City VARCHAR(50),
NumOfUnder18 NUMERIC(4,2),NumOfOver65 NUMERIC(4,2),NumOfOver65NonJob NUMERIC(4,2),
Tofu INTEGER,GanmoAburaage INTEGER,Natto INTEGER,
Sake NUMERIC,Shochu NUMERIC,Beer NUMERIC,Wiskey NUMERIC,Wine NUMERIC,
LowMaltBeer NUMERIC,Chuhai NUMERIC,ConsumptionSpending NUMERIC,
MeanTemperature NUMERIC(4,2),MeanHumidity INTEGER,SunshineTime NUMERIC(4,1))

LOAD DATA FROM FILE '/code/AomoriAkitaMorioka.csv'
 INTO ESTAT.SoyData
 USING {"from":{"file":{"charset":"UTF-8"}}}

 
/*確認*/
select * from %SQL_Diag.Result

/*TrainデータのView作成
データ100件未満だと少なすぎると怒られる
説明変数＝平均気温　目的変数＝がんも＆油揚げ
*/
DROP VIEW ESTAT.SoyDataTrain

CREATE VIEW ESTAT.SoyDataTrain
AS SELECT 
GanmoAburaage,MeanTemperature
FROM ESTAT.SoyData
where timecode < 2021000101

/*TestデータのView作成 */
DROP VIEW ESTAT.SoyDataTest

CREATE VIEW ESTAT.SoyDataTest
AS SELECT 
GanmoAburaage,MeanTemperature
FROM ESTAT.SoyData
where timecode > 2020001212

/* がんもどき、油揚げの購入金額を予測する */
DROP MODEL Ganmo

CREATE MODEL Ganmo PREDICTING(GanmoAburaage) from ESTAT.SoyDataTrain
TRAIN MODEL Ganmo from ESTAT.SoyDataTrain
CREATE TABLE ESTAT.ResultGanmo (PredictGanmo NUMERIC,GanmoAburaage NUMERIC)
INSERT INTO ESTAT.ResultGanmo SELECT PREDICT(Ganmo) As PredictGanmo,GanmoAburaage from ESTAT.SoyDataTest







