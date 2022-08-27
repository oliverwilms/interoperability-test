Class dc.Test.POCTestProduction Extends %UnitTest.TestProduction
{

/// Class name of the production.  It must contain the production class name.
Parameter PRODUCTION = "dc.Demo.Production";

/// If any errors appear in the Event Log during execution of the production, the test will fail.
/// If errors are expected to happen, override this parameter. 
/// You may also want to check them manually by overriding the method <method>CheckErrors</method>.
Parameter IGNOREPRODUCTIONERRORS = 1;  // 1 because I want to execute method <method>CheckErrors</method>.

/// Code to run right before the production is started.  This is useful to:<br>
/// <ul><li>Adjust settings - see method <method>ChangeSetting</method>.</li>
/// <li>Create directories - see method <method>CreateMainDirTree</method>.</li>
/// <li>Copy files - see method <method>CopyFile</method>.</li>
/// <li>Create credentials required by the production - see method <method>CreateCredentials</method>.</li>
/// <li>etc.</li></ul>
/// If an error status is returned, the test will be aborted and failed.
/// So if a non fatal error occurs, you may invoke ..LogErrors(status,"OnBeforeProductionStart()") and return $$$OK.
Method OnBeforeProductionStart() As %Status
{
	Quit $$$OK
}

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

/// Fill in with code to check the results for the production execution.<br>
/// This method is initialized with a local array containing user created entries of type "Info" from the Event Log, 
/// not including the start production/components entries, with the following contents:<br>
///   <b>Log</b> = last existing seq for array <b>Log()</b> <br>
///   <b>Log(seq, fieldname)</b> = fieldvalue<br>
/// To get other entries from the Event Log, or for more information about the array contents,
/// see method <method>GetEventLog</method>. <br>
/// Return $$$OK in most cases, or an error status if you want to indicate that there was a failure.  Remember 
/// that failures are automatic when unit test macros are used.<br>
Method CheckResults(ByRef Log As %String, New As %String) As %Status
{
	Set tSC = $$$OK
	Quit tSC
}

/// Override this method if you are going to check errors with custom code.
/// It's automatically invoked when parameter <parameter>IGNOREPRODUCTIONERRORS</parameter> = 1.
Method CheckErrors() As %Status
{
	Do ..DebugTEST("CheckErrors")
	// GetEventLog types are "error", "info", "infouser", "trace", "alert"
	Set s = ..GetEventLog("error", "", ..BaseLogId, .err, .new) // Retrieve all records of type "Error"
	Do ..DebugMerge("err",.err)
	Do ..DebugTEST("new = "_$Get(new))
	Set (s1,s2) = $$$AssertEquals(new,0,"Should be 0 new errors(found: "_+$Get(new)_")")
	Set text = $Get(err(1,"Text"))
	Set eText = "Test error case"
	//Set s2 = $$$AssertTrue(text[eText,"Should contain '"_eText_"'(found: '"_text_"')")
	//Set tSC = ##class(Feeder.Test).UpdateMyProp("","myErrCount",$Get(new))
	If 's1||'s2 Set tSC=..Error("Expected error entries don't match")
	Quit tSC
}

}
