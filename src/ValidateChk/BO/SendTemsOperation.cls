Class ValidateChk.BO.SendTemsOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter SETTINGS = "token:Teams通知設定";

/// Teams通知用トークンを指定してください
Property token As %String(MAXLEN = 1000);

Method SendMessage(pRequest As Ens.StreamContainer, ByRef pResponse As Ens.Response) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try{
		set url=..Adapter.URL
		if $extract(url,*)="/" {
			set ..Adapter.URL=..Adapter.URL_..token
		}
		else {
			set ..Adapter.URL=..Adapter.URL_"/"_..token
		}
		
        set record={}.%FromJSON(pRequest.Stream.Read())
        set message="検証名："_record."VALIDATION_RUN_NAME"_" の検証結果、F値の値が "_record."METRIC_VALUE"_" でした。"_$$$NL
        set message=message_"再学習も検討しましょう"

		set teamsjson={}
		set teamsjson.text=message
		$$$TRACE(teamsjson.%ToJSON())
		
		/*
			Adapter経由のPost()メソッドを今回は使用。
			フォームデータを送信しない時は、第2引数は指定なし、第3引数にJSONのストリーム／文字をセットした変数を指定
		*/
		set stream=##class(%Stream.TmpBinary).%New()
		do teamsjson.%ToJSON(stream)
		
		set status=..Adapter.Post(.pHttpResponse,,stream)
	
		if pHttpResponse.StatusCode '= 200 {
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
