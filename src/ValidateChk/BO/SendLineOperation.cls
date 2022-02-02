Class ValidateChk.BO.SendLineOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter SETTINGS = "token:LINE通知設定";

/// LINE通知用トークンを指定してください
Property token As %String(MAXLEN = 1000);

Method SendMessage(pRequest As Ens.StreamContainer, ByRef pResponse As Ens.Response) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try{
        set record={}.%FromJSON(pRequest.Stream.Read())
        set message="検証名："_record."VALIDATION_RUN_NAME"_" の検証結果、F値の値が "_record."METRIC_VALUE"_" でした。"_$$$NL
        set message=message_"再学習も検討しましょう"

        set jobj={}
        set jobj.type="text"
        set jobj.text=message
        set jarray=[]
        do jarray.%Push(jobj)
        set linejson={}
        set linejson.messages=jarray
        $$$TRACE(linejson.%ToJSON())
        //Line通知はBearer tokenなのでヘッダ追加要
        set httprequest=##class(%Net.HttpRequest).%New()
        do httprequest.SetHeader("Authorization","Bearer "_..token)
        set httprequest.ContentCharset="utf-8"
        set httprequest.ContentType="application/json"
        do httprequest.EntityBody.Write($ZCVT(linejson.%ToJSON(),"O","UTF8"))
        set status=..Adapter.SendFormData(.pHttpResponse,"POST",httprequest)
        if pHttpResponse.StatusCode'=200 {
            set status=$$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(status)_":"_pHttpResponse.Data.Read())
        }
        $$$ThrowOnError(status)
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

XData MessageMap
{
<MapItems>
        <MapItem MessageType="Ens.StreamContainer">
            <Method>SendMessage</Method>
        </MapItem>
    </MapItems>
}

}
