Class dc.rest.GenericService Extends EnsLib.REST.GenericService
{

ClassMethod OnPage() As %Status [ Internal, ServerOnly = 1 ]
{
	Try {
		Do ##class(dc.rest.RequestLogger).NewRequest(%request)
	}
	Catch exception {
		If exception.%IsA("%Exception.SystemException") {
			Do BACK^%ETN // Log error in error log
		} Else {
			Throw exception // We will just throw these to outer error handler
		}
		Quit
	}
	Set tSC = ##super()
	Quit tSC
}

}
