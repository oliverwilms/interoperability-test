Class dc.rest.RequestLogger Extends %Persistent
{

Property Application As %String(MAXLEN = 255);

Property Content As %CSP.Stream;

Property ContentType As %String(MAXLEN = 255);

Property QueryString As %String(MAXLEN = 255);

Property RequestFilename As %String(MAXLEN = 255);

Property RequestSiteID As %String(MAXLEN = 255);

Property RequestTimestamp As %String(MAXLEN = 255);

Property ResponseTimestamp As %String(MAXLEN = 255);

/// Server to connect to (optional). If not specified, it defaults to 'localhost'.
Property Server As %String(MAXLEN = 255);

/// Port for connection.
Property Port As %String(MAXLEN = 6);

/// URL to connect to (optional).
Property URL As %String(MAXLEN = 255);

/// The HTTP status code. This is useful to determine if the request was
/// successful. Look in the rfc for HTTP to see which codes are supported
/// and what they mean. A human readable form of this code is stored as
/// the <PROPERTY>ReasonPhrase</PROPERTY>
Property StatusCode As %Integer;

/// This is the human readable reason that goes with the <PROPERTY>StatusCode</PROPERTY>.
Property ReasonPhrase As %String(MAXLEN = 255);

/// The HTTP status line. This is the first line of the response and signals
/// if the request was successful or if there was a problem.
Property StatusLine As %String(MAXLEN = 255);

/// Strict-Transport-Security Response Header
Property HSTS As %String(MAXLEN = 255);

Property Status As %Status;

Property URLPrefix As %String(MAXLEN = 255);

ClassMethod NewRequest(pRequest As %CSP.Request) As dc.rest.RequestLogger
{
	Try {
		Set tQueryString = pRequest.GetCgiEnv("QUERY_STRING")

		Set tPort = ""
		Set tServer = ""
		Set oRequestLogger = ..%New()
		Set oRequestLogger.Application = pRequest.Application
		Set oRequestLogger.Content = pRequest.Content
		Set oRequestLogger.ContentType = pRequest.ContentType
		Set oRequestLogger.QueryString = tQueryString
		Set oRequestLogger.RequestFilename = $Get(pRequest.Data("FILENAME",1))
		Set oRequestLogger.RequestSiteID = $Get(pRequest.Data("SITEID",1))
		Set oRequestLogger.RequestTimestamp = $ZDateTime($NOW(),3,1,3)
		Set oRequestLogger.Port = tPort
		Set oRequestLogger.Server =tServer
		Set oRequestLogger.URL = pRequest.URL
		Set oRequestLogger.URLPrefix = pRequest.URLPrefix
		Set tSC = oRequestLogger.%Save()
	}
	Catch exception {
		If exception.%IsA("%Exception.SystemException") {
			Do BACK^%ETN // Log error in error log
		} Else {
			Throw exception // We will just throw these to outer error handler
		}
		Quit
	}
	Quit oRequestLogger
}

Storage Default
{
<Data name="RequestLoggerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Application</Value>
</Value>
<Value name="3">
<Value>Content</Value>
</Value>
<Value name="4">
<Value>ContentType</Value>
</Value>
<Value name="5">
<Value>QueryString</Value>
</Value>
<Value name="6">
<Value>RequestFilename</Value>
</Value>
<Value name="7">
<Value>RequestSiteID</Value>
</Value>
<Value name="8">
<Value>RequestTimestamp</Value>
</Value>
<Value name="9">
<Value>ResponseTimestamp</Value>
</Value>
<Value name="10">
<Value>Server</Value>
</Value>
<Value name="11">
<Value>Port</Value>
</Value>
<Value name="12">
<Value>URL</Value>
</Value>
<Value name="13">
<Value>StatusCode</Value>
</Value>
<Value name="14">
<Value>ReasonPhrase</Value>
</Value>
<Value name="15">
<Value>StatusLine</Value>
</Value>
<Value name="16">
<Value>HSTS</Value>
</Value>
<Value name="17">
<Value>Status</Value>
</Value>
<Value name="18">
<Value>URLPrefix</Value>
</Value>
</Data>
<DataLocation>^dc.rest.RequestLoggerD</DataLocation>
<DefaultData>RequestLoggerDefaultData</DefaultData>
<IdLocation>^dc.rest.RequestLoggerD</IdLocation>
<IndexLocation>^dc.rest.RequestLoggerI</IndexLocation>
<StreamLocation>^dc.rest.RequestLoggerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
