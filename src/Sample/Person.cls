Class Sample.Person Extends %Persistent
{

Property Name As %String;

Property Email As %String;

ClassMethod CreateEmail(uid As %String) As %String
{
    return uid_"@mail.com"
}

Method PythonPrint() [ Language = python ]
{
    print("\nあなたの名前は：" + self.Name + "　メールは："+self.Email)
}

Storage Default
{
<Data name="PersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Email</Value>
</Value>
</Data>
<DataLocation>^Sample.PersonD</DataLocation>
<DefaultData>PersonDefaultData</DefaultData>
<IdLocation>^Sample.PersonD</IdLocation>
<IndexLocation>^Sample.PersonI</IndexLocation>
<StreamLocation>^Sample.PersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
