Class dc.POC.REST Extends %CSP.REST
{

Parameter CONTENTTYPE = {..#CONTENTTYPEJSON};

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
      <Route Url="/Auth/GetAuthtoken" Method="GET" Call="GetAuthtoken" Cors="true"/>
      <Route Url="/Auth/GetAuthtoken" Method="POST" Call="GetAuthtoken" Cors="true"/>
</Routes>
}

ClassMethod GetAuthtoken() As %Status
{
      Try {
          Set ^DEBUG($Increment(^DEBUG))="REST"
  } Catch e {
    If e.Data["'ModuleNotFoundError'" {
      Return $$$ERROR($$$GeneralError, "Python module 'faker' not installed. Please install it with pip3.")
    }
    Return e.AsStatus()
  }

  Set result = {
    "status": "OK"
  }
  Do result.%ToJSON()
  Return $$$OK
}

}
