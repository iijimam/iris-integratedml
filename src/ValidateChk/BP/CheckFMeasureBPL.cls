/// 
Class ValidateChk.BP.CheckFMeasureBPL Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.StreamContainer' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='Value' type='%Library.Numeric' instantiate='0' />
<property name='Metric' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='950' >
<code name='値設定' xpos='200' ypos='250' >
<![CDATA[ set record={}.%FromJSON(request.Stream.Read())
 set context.Metric=record."METRIC_NAME"
 set context.Value=record."METRIC_VALUE"]]>
</code>
<if name='F値？' condition='context.Metric="Micro-averaged F-Measure"' xpos='200' ypos='350' xend='200' yend='850' >
<true>
<if name='0.95未満？' condition='context.Value&lt;0.95' xpos='335' ypos='500' xend='335' yend='750' >
<true>
<call name='Teams通知' target='Teams通知' async='0' xpos='605' ypos='650' >
<request type='Ens.StreamContainer' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' />
</call>
</true>
<false>
<trace name='良い状態' value='"現状維持"' xpos='335' ypos='650' />
</false>
</if>
</true>
</if>
</sequence>
</process>
}

}
