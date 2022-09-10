Class dc.POC.DTL.AuthReq Extends Ens.DataTransformDTL [ DependsOn = EnsLib.HTTP.GenericMessage ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HTTP.GenericMessage' targetClass='EnsLib.HTTP.GenericMessage' create='new' language='objectscript' >
</transform>
}

}
