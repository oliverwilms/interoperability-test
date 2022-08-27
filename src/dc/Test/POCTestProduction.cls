Class dc.Test.POCTestProduction Extends %UnitTest.TestProduction
{

/// Class name of the production.  It must contain the production class name.
Parameter PRODUCTION = "dc.Demo.Production";

/// If any errors appear in the Event Log during execution of the production, the test will fail.
/// If errors are expected to happen, override this parameter. 
/// You may also want to check them manually by overriding the method <method>CheckErrors</method>.
Parameter IGNOREPRODUCTIONERRORS = 1;  // 1 because I want to execute method <method>CheckErrors</method>.

}
