IRISにログイン
iris session IRIS

＝＝

Pythonシェルに切替
do ##class(%SYS.Python).Shell()

＝＝

Python>>> IRISのインスタンス生成から保存
import iris
p=iris.cls("Sample.Person")._New()
p.Name="山田太郎"
p.Email="taro@mail.com"
status=p._Save()
print(status)


1件SQLで更新
INSERT INTO Sample.Person (Name,Email) VALUES('鈴木花子','hana@mail.com')

＝＝

Python>>> 花子さんオープン
p=iris.cls("Sample.Person")._OpenId(2)
print(p.Name+" - "+ p.Email)

Python>>> メソッド実行
print(p.CreateEmail(p.Email))

＝＝

Python>>> SQL実行（SELECT）
rs=iris.sql.exec("SELECT Name,Email from Sample.Person")
for idx,row in enumerate(rs):
    print(f"[{idx}]:{row}")

Python>>> 引数取る場合は ? を使います
stmt=iris.sql.prepare("SELECT Name,Email from Sample.Person where ID<?")
rs=stmt.execute(2)
for idx,row in enumerate(rs):
    print(f"[{idx}]:{row}")

＝＝

dataframeに変換もできますが、日本語を含むレコードについては現在修正中
TRUNCATE TABLE Sample.Person
INSERT INTO Sample.Person (Name,Email) VALUES('hanako','hana@mail.com')
INSERT INTO Sample.Person (Name,Email) VALUES('taro','taro@mail.com')

Python>>> SELECT実行結果をDataframeに変換
rs=iris.sql.exec("SELECT Name,Email from Sample.Person")
rs.dataframe()


＝＝

IRISのターミナルでPythonで書いたメソッド実行
//Sample.Personオープン
set p=##class(Sample.Person).%OpenId(1)
// インスタンスメソッド実行
do p.PythonPrint()

あなたの名前は：山田太郎　メールは：taro@mail.com

＝＝
*.pyをIRISから実行する

set sys=##class(%SYS.Python).Import("sys")
do sys.path.append("/code")
set bar=##class(%SYS.Python).Import("barchart")
do bar.buildGraph("/data/a.jpg","beer","lowmaltbeer")
