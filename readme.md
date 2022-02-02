# IRIS 2021.2 IntegratedML & EmbeddedPythonを試せるコンテナ

このサンプルでは、デフォルトで以下のイメージを利用しています。

```
containers.intersystems.com/intersystems/irishealth-ml:2021.2.0.649.0
```

また、コンテナ作成時にサンプルプロダクションのインポートや初期設定（SQLゲートウェイ irisuser の作成）を行っています。
（EmbeddedPythonを簡単に試せるようにクラス定義とサンプルデータの作成も行っています）

不要な場合は [docker-compose.yml](./docker-compose.yml)の5～7行目を以下のように修正してご利用ください。

```
    build: containers.intersystems.com/intersystems/irishealth-ml:2021.2.0.649.0
      #context: .
      #dockerfile: Dockerfile
```

このコンテナは、永続的な%SYSを利用しています。不要な場合は[docker-compose.yml](./docker-compose.yml) の13行目を削除してご利用ください。

## コンテナ開始・停止手順

1) シェルの実行（初回のみ）

    永続的な%SYSを利用する場合は、data ディレクトリの権限を変更するため以下シェルを実行してください。

    ```
    ./setup.sh
    ```

2) ライセンスキーの準備

    コンテナ用キーを data ディレクトリ以下に配置してください。
    コンテナ作成時にキーをコピーしてIRISに適用します。


3) コンテナビルド＆開始

    ```
    docker-compose up -d --build
    ```

4) コンテナ停止

    ```
    docker-compose stop
    ```

5) コンテナ破棄

    ```
    docker-compose down
    ```


## EmbeddedePythonを試す

[Dockerfile](Dockerfile)を利用してコンテナを開始した場合、USERネームスペースに [Sample.Person](/src/Sample/Person.cls)がインポートされるため、以下の操作が行えます。

1) IRISにログインする

    ```
    docker exec -it integartedml bash
    iris session iris
    ```

2) Pythonシェルに切替る

    ```
    do ##class(%SYS.Python).Shell()
    ```
3) Pythonシェル上でIRISのSample.Personのインスタンス生成から保存を試す

    ```
    import iris
    p=iris.cls("Sample.Person")._New()
    p.Name="山田太郎"
    p.Email="taro@mail.com"
    status=p._Save()
    print(status)
    ```

4) 管理ポータルやSQLToolsなどから1件Sample.PersonをINSERTする

    > SQLToolsエクステンションを使ってIRISに接続する方法は[コミュニティの記事](https://jp.community.intersystems.com/node/489316)をご参照ください。

    ```
    INSERT INTO Sample.Person (Name,Email) VALUES('鈴木花子','hana@mail.com')
    ```

5) 4.で作成したデータをPythonシェルからオープンする

    ```
    p=iris.cls("Sample.Person")._OpenId(2)
    print(p.Name+" - "+ p.Email)
    ```

    ObjectScriptで書かれたメソッドを実行する
    ```
    print(p.CreateEmail("hanako"))
    ```

6) PythonシェルでSQLを実行する

    ```
    rs=iris.sql.exec("SELECT Name,Email from Sample.Person")
    for idx,row in enumerate(rs):
        print(f"[{idx}]:{row}")
    ```

    引数取る場合は ? を使います
    ```
    stmt=iris.sql.prepare("SELECT Name,Email from Sample.Person where ID<?")
    rs=stmt.execute(2)
    for idx,row in enumerate(rs):
        print(f"[{idx}]:{row}")
    ```


7) dataframeへの変換を試す

    > 2021.2では、日本語を含むレコードからDataframeへ変換する処理に不具合があるため、英字データのみでご確認ください。

    ```
    TRUNCATE TABLE Sample.Person
    INSERT INTO Sample.Person (Name,Email) VALUES('hanako','hana@mail.com')
    INSERT INTO Sample.Person (Name,Email) VALUES('taro','taro@mail.com')
    ```

    SELECT実行結果をDataframeに変換します。

    ```
    rs=iris.sql.exec("SELECT Name,Email from Sample.Person")
    rs.dataframe()
    ```

8) IRISのターミナルから language=python で記述されたメソッドを実行する（[Sample.Person](/src/Sample/Person.cls)13行目以降のメソッド）

    ```
    //Sample.Personオープン
    set p=##class(Sample.Person).%OpenId(1)
    // インスタンスメソッド実行
    do p.PythonPrint()

    あなたの名前は：山田太郎　メールは：taro@mail.com
    ```

9) IRISから *py を実行する
 
    [Sample.Alcohol](/src/Sample/Alcohol.cls)のデータを利用してビールと発泡酒の消費量のグラフを作成します。

    ```
    set sys=##class(%SYS.Python).Import("sys")
    do sys.path.append("/code")
    set bar=##class(%SYS.Python).Import("barchart")
    do bar.buildGraph("/data/a.jpg","beer","lowmaltbeer")
    ```
    data ディレクトリ以下に a.jpg が作成されます。

    ※ [Dockerfile](/Dockerfile)を使用せずにコンテナを開始した場合は、matplotlib をインストールしてからお試しください。

## IntegratedMLを試す

|認知症の予測データ|実行するSQL例|
|:--|:--|
|[dementia_dataset.csv](/code/dementia_dataset.csv)|[dementia.sql](/code/dementia.sql)|

|青森秋田盛岡の気象情報と世帯別アルコール＆豆類購入価格|実行するSQL例|
|:--|:--|
|[AomoriAkitaMorioka.csv](/code/AomoriAkitaMorioka.csv)|[AomoriAkitaMorioka.sql](/code/AomoriAkitaMorioka.sql)|


