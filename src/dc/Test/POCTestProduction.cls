Class dc.Test.POCTestProduction Extends %UnitTest.TestProduction
{

/// Class name of the production.  It must contain the production class name.
Parameter PRODUCTION = "dc.Demo.Production";

/// If any errors appear in the Event Log during execution of the production, the test will fail.
/// If errors are expected to happen, override this parameter. 
/// You may also want to check them manually by overriding the method <method>CheckErrors</method>.
Parameter IGNOREPRODUCTIONERRORS = 1;  // 1 because I want to execute method <method>CheckErrors</method>.

/// Code to run right after the production is started. Used, for example, to call a method that initiates the test.
/// If an error status is returned, the test will be aborted and failed and the production will be stopped.
/// So if a non fatal error occurs, you may invoke ..LogErrors(status,"OnAfterProductionStart()") and return $$$OK.
Method OnAfterProductionStart() As %Status
{
	Do ..DebugTEST("OnAfterProductionStart")
	Set myUnitTest = $Get(^myUnitTests)
	If myUnitTest {
		Set pIris = 0
		Set ^myUnitTests(myUnitTest,pIris,"BaseLogId") = ..BaseLogId
	}
	Quit $$$OK
	Set request = ##class(Ens.StringRequest).%New()
	set request.StringValue="Hello Ensemble"
	Set tSC = ..SendRequest( "Tutorial.ExampleOperation" ,request, 
                                                       .response,1,40)
	Do $$$AssertEquals(response.StringValue,"OK","Response should contain OK.")
	Set request.StringValue=""
	Set tSC = ..SendRequest( "Tutorial.ExampleOperation" ,request, 
                                                        .response,1,40)
	Quit $$$OK
}

}
