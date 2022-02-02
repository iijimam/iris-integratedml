Class App.Setup
{

ClassMethod CreateSQLGW() As %Status
{
	#dim ex As %Exception.AbstractException
	set status=$$$OK
    try {
        // JDBCを利用するSQLゲートウェイの設定
        set jdbcgw=##class(%Library.SQLConnection).%New()
        set jdbcgw.Name="irisuser"
        set jdbcgw.URL="jdbc:IRIS://localhost:1972/USER"
        set jdbcgw.Usr="_SYSTEM"
        set jdbcgw.classpath=".:/usr/irissys/dev/java/lib/1.8/intersystems-jdbc-3.2.0.jar"
        set jdbcgw.driver="com.intersystems.jdbc.IRISDriver"
        set jdbcgw.isJDBC=1
        set jdbcgw.pwd="SYS"
        set status=jdbcgw.%Save()
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

}
