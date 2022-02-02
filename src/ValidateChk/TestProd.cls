Class ValidateChk.TestProd Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="ValidateChk.TestProd" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="EnsLib.JavaGateway.Service" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="LINE通知" Category="検証後データ確認,F値" ClassName="ValidateChk.BO.SendLineOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="token">eZPpfv7rQty1oZhVGW+S2VMoKUMeK9sNv8Aev/5jkrtEUvfsg7NrdYGBJxc2mi45K9SQX4AjPYbe1TuyRhIyG2Gmne5GPw1NxiIQH+P8gnP1KAaI0M+n71/p3nGgMYArrXlN77TqJ6GtYbtOUgRu2AdB04t89/1O/w1cDnyilFU=</Setting>
    <Setting Target="Adapter" Name="HTTPServer">api.line.me</Setting>
    <Setting Target="Adapter" Name="SSLConfig">line</Setting>
    <Setting Target="Adapter" Name="URL">/v2/bot/message/broadcast</Setting>
  </Item>
  <Item Name="F値のチェック" Category="検証後の確認,F値" ClassName="ValidateChk.BP.CheckFMeasureBPL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="検証後データ確認" Category="検証後データ確認,F値" ClassName="EnsLib.SQL.Service.GenericService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Adapter" Name="DSN">irisuser</Setting>
    <Setting Target="Adapter" Name="ParamSQLTypes"></Setting>
    <Setting Target="Adapter" Name="Query">SELECT ID1,VALIDATION_RUN_NAME, METRIC_NAME, METRIC_VALUE FROM INFORMATION_SCHEMA.ML_VALIDATION_METRICS</Setting>
    <Setting Target="Host" Name="TargetConfigNames">F値のチェック</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">ID1</Setting>
  </Item>
  <Item Name="Teams通知" Category="検証後データ確認,F値" ClassName="ValidateChk.BO.SendTemsOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="token">6b699760-6c53-40e1-9b1b-8dc9a36adf79@74abaa74-2829-4279-b25c-5743687b0bf5/IncomingWebhook/7c3f7efe90d446968b393d037e1882e5/e275c4a8-d4ce-4793-b15f-122d532aaa12</Setting>
    <Setting Target="Adapter" Name="HTTPServer">intersystemscorporation.webhook.office.com</Setting>
    <Setting Target="Adapter" Name="SSLConfig">teams</Setting>
    <Setting Target="Adapter" Name="URL">/webhookb2</Setting>
  </Item>
</Production>
}

}
