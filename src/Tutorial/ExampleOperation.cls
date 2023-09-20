Class Tutorial.ExampleOperation Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method Test(pRequest As Ens.StringRequest, Output pResponse As Ens.StringResponse) As %Status
{
    Set pResponse=##class(Ens.StringResponse).%New()
    if (pRequest.StringValue="")
    {
    Set pResponse.StringValue="ERROR"
    Set tSC=$$$ERROR($$$GeneralError, "Test error case")
    }
    else
    {
    Set pResponse.StringValue="OK"
    Set tSC=$$$OK
    }
    $$$LOGINFO(pResponse.StringValue)
    Return tSC
}

XData MessageMap
{
<MapItems>
        <MapItem MessageType="Ens.StringRequest">
            <Method>Test</Method>
        </MapItem>
    </MapItems>
}

}
