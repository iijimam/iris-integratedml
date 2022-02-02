/*
KaggleからDL
https://www.kaggle.com/shashwatwork/dementia-prediction-dataset

ヘッダはとってる（スペース入りとかあったので取ってしまった）
カラムの説明がないのでどんなデータか不明

MMSE = Mini-Mental State Exam (MMSE) Alzheimer’s / Dementia Test （https://www.dementiacarecentral.com/mini-mental-state-exam/）
（アルツハイマー病または関連する認知症の重症度を評価するための最も一般的なツールは、
フォルスタイン検査または標準化されたミニメンタルステート検査（SMMSE）としても知られているミニメンタルステート検査（MMSE）です）
CDRはClinical Dementia Ratingらしい　https://knowledge.nurse-senka.jp/233459/
SES = socioeconomic status (SES) 
eTIV:Estimated intracranial volume　推定頭蓋内容積 
nWBV = normalized whole brain volume 正規化された全脳容積;
ASF = Atlas Scaling Factor
アトラス正規化：
機能データ解析でよく用いられるアトラス正規化は、年齢や集団に適したターゲットアトラスを用いる限り、
局所および全脳形態素解析において頭部サイズのばらつきを補正するという広く遭遇する問題に対する自動的な
解決策を提供するものである。（https://pubmed.ncbi.nlm.nih.gov/15488422/）
*/

DROP TABLE Kaggle.Dementia

CREATE TABLE Kaggle.Dementia
(SubjectID VARCHAR(50),MRIID VARCHAR(50),DementiaGroup VARCHAR(50),Visit INTEGER,
MRDelay INTEGER,MF VARCHAR(2),Hand VARCHAR(2),Age INTEGER,EDUC INTEGER,
SES INTEGER,MMSE INTEGER,CDR NUMERIC(3,1),eTIV INTEGER,nWBV NUMERIC(5,3),ASF NUMERIC(5,3)
)

LOAD DATA FROM FILE '/code/dementia_dataset.csv'
 INTO Kaggle.Dementia

 
/*確認*/
select * from %SQL_Diag.Result

/*TrainデータのView作成*/
DROP VIEW Kaggle.DementiaTrain

CREATE VIEW Kaggle.DementiaTrain
AS SELECT DementiaGroup, Visit, MRDelay, MF, Hand, Age, EDUC, SES, MMSE, CDR, eTIV, nWBV, ASF
FROM Kaggle.Dementia
WHERE ID<301

/*TestデータのView作成 */
DROP VIEW Kaggle.DementiaTest

CREATE VIEW Kaggle.DementiaTest
AS SELECT DementiaGroup, Visit, MRDelay, MF, Hand, Age, EDUC, SES, MMSE, CDR, eTIV, nWBV, ASF
FROM Kaggle.Dementia
WHERE ID>301

/* 認知症の可能性予測 */
DROP MODEL Dementia
TRUNCATE TABLE Kaggle.ResultDementia

--- モデルの作成
CREATE MODEL Dementia PREDICTING(DementiaGroup) from Kaggle.DementiaTrain

--- 学習開始
TRAIN MODEL Dementia from Kaggle.DementiaTrain

--- 学習結果の確認
SELECT 
MODEL_NAME, TRAINED_MODEL_NAME, PROVIDER, TRAINED_TIMESTAMP, MODEL_TYPE, MODEL_INFO
FROM INFORMATION_SCHEMA.ML_TRAINED_MODELS

--- 予測結果を入れるテーブルの作成
CREATE TABLE Kaggle.ResultDementia (PredictDementia VARCHAR(50),DementiaGroup VARCHAR(50))

--- 予測
INSERT INTO Kaggle.ResultDementia SELECT PREDICT(Dementia) As PredictDementia,DementiaGroup from Kaggle.DementiaTest

--- 検証
VALIDATE MODEL Dementia from Kaggle.DementiaTest

--- 検証結果の確認
SELECT 
MODEL_NAME, TRAINED_MODEL_NAME, VALIDATION_RUN_NAME, METRIC_NAME, METRIC_VALUE, TARGET_VALUE
FROM INFORMATION_SCHEMA.ML_VALIDATION_METRICS

