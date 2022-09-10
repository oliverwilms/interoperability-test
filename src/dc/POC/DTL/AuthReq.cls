Class dc.POC.DTL.AuthReq Extends Ens.DataTransformDTL [ DependsOn = EnsLib.HTTP.GenericMessage ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HTTP.GenericMessage' targetClass='EnsLib.HTTP.GenericMessage' create='new' language='objectscript' >
<assign value='target.HTTPHeaders.SetAt("application/json;charset=UTF-8","CONTENT-TYPE")' property='tSC' action='set' />
<assign value='##class(%GlobalCharacterStream).%New()' property='tStream' action='set' />
<assign value='{"access_token":"my_token"}' property='tToken' action='set' />
<assign value='tStream.Write(tToken)' property='tSC' action='set' />
<assign value='target.StreamSet(tStream)' property='tSC' action='set' />
</transform>
}

}
