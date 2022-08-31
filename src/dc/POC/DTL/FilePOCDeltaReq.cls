Class dc.POC.DTL.FilePOCDeltaReq Extends Ens.DataTransformDTL [ DependsOn = (Ens.StreamContainer, EnsLib.HTTP.GenericMessage) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Ens.StreamContainer' targetClass='EnsLib.HTTP.GenericMessage' create='new' language='objectscript' >
<assign value='source.Stream.ReadLine()' property='tmpH' action='set' />
<assign value='source.Stream.ReadLine()' property='tmp' action='set' />
<code>
<![CDATA[ set tmp=$ZSTRIP($P(tmp,"|",2),">C")]]></code>
<assign value='target.HTTPHeaders.SetAt("GET","httprequest") ' property='tSC' action='set' />
<assign value='target.HTTPHeaders.SetAt("/csp/healthshare/poc/","CSPApplication") ' property='tSC' action='set' />
<assign value='target.HTTPHeaders.SetAt("1.1","HttpVersion")' property='tSC' action='set' />
<assign value='target.HTTPHeaders.SetAt("customerAccountId="_tmp,"RawParams")' property='tSC' action='set' />
<assign value='target.HTTPHeaders.SetAt("1","IParams")' property='tSC' action='set' />
<assign value='target.HTTPHeaders.SetAt("customerAccountId="_tmp,"IParams_1")' property='tSC' action='set' />
<assign value='target.HTTPHeaders.SetAt(context.SourceName,"EnsConfigName")' property='tSC' action='set' />
<assign value='target.HTTPHeaders.SetAt(0,"content-length")' property='tSC' action='set' />
<assign value='##class(dc.POC.ProcessPOCHelper).GetHostname()' property='tHostname' action='set' />
<assign value='target.HTTPHeaders.SetAt(tHostname,"host")' property='tSC' action='set' />
<assign value='target.HTTPHeaders.SetAt("utf-8","CharEncoding")' property='tSC' action='set' />
<assign value='target.HTTPHeaders.SetAt("UTF8","TranslationTable")' property='tSC' action='set' />
<assign value='target.HTTPHeaders.SetAt("text/plain; charset=utf-8","content-type")' property='tSC' action='set' />
<assign value='##class(dc.POC.ProcessPOCHelper).GetSiteID(source)' property='tSiteID' action='set' />
<assign value='$Piece(source.OriginalFilename,"_",2)' property='tTransType' action='set' />
<assign value='target.HTTPHeaders.SetAt("/csp/healthshare/poc/"_context.SourceName_"/"_tTransType_"?SiteID="_tSiteID,"URL")' property='tSC' action='set' />
</transform>
}

}
