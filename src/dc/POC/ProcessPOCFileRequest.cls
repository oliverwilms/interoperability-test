/// Business process that will submit message from 
/// POU/POC systems received via SFTP to DMLSS and sends response from DMLSS to POC/POU systems in expected format via SFTP.
Class dc.POC.ProcessPOCFileRequest Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.StreamContainer' response='Ens.Response' height='3950' width='2825' >
<context>
<property name='DeltaRequest' type='dc.POC.DeltaRequest' instantiate='0' />
<property name='OrderRequest' type='dc.POC.DeltaRequest' instantiate='1' />
<property name='ShipmentStatusRequest' type='dc.POC.DeltaRequest' instantiate='0' />
<property name='CSVResponse' type='Ens.StreamContainer' instantiate='1' />
<property name='JSONRequest' type='EnsLib.HTTP.GenericMessage' instantiate='1' />
<property name='CSVJSONString' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='TransactionType' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='1000' />
</parameters>
</property>
<property name='JSONStream' type='%GlobalBinaryStream' instantiate='1' />
<property name='requestHeaders' type='%String' collection='array' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='' />
</parameters>
</property>
<property name='JSONResponse' type='EnsLib.HTTP.GenericMessage' instantiate='0' />
<property name='JSONObject' type='%String' instantiate='0' />
<property name='JSONResponse1' type='EnsLib.HTTP.GenericMessage' instantiate='0' />
<property name='OrderJSONReq' type='%Library.DynamicObject' instantiate='0' />
<property name='JSONRequest1' type='EnsLib.HTTP.GenericMessage' instantiate='0' />
<property name='SiteID' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='SiteOperation' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='SiteAuthOperation' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='100' />
</parameters>
</property>
<property name='AuthJSONStream' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='AuthToken' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50000' />
</parameters>
</property>
<property name='AuthJSONResponse' type='EnsLib.HTTP.GenericMessage' instantiate='0' />
<property name='ResponseFileOperation' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='SourceName' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='3550' >
<assign name="TransactionType" property="context.TransactionType" value="##class(dc.POC.ProcessPOCHelper).GetTransactionType(request)" action="set" xpos='200' ypos='250' />
<assign name="Source Name" property="context.SourceName" value="process.%PrimaryRequestHeader.SourceConfigName" action="set" xpos='200' ypos='350' />
<trace name='URL - Transaction Type' value='context.TransactionType_","_context.SourceName' xpos='200' ypos='450' />
<assign name="extract Site ID" property="context.SiteID" value="##class(dc.POC.ProcessPOCHelper).GetSiteID(request)" action="set" xpos='200' ypos='550' />
<assign name="Site Operation" property="context.SiteOperation" value="&quot;POCRequestToDMLSS&quot;_context.SiteID" action="set" xpos='200' ypos='650' />
<assign name="Response File Operation" property="context.ResponseFileOperation" value="&quot;POCResponseFile&quot;_context.SiteID" action="set" xpos='200' ypos='750' />
<assign name="Site Auth Operation" property="context.SiteAuthOperation" value="&quot;POCAuthRequestToDMLSS&quot;_context.SiteID" action="set" xpos='200' ypos='850' />
<trace name='Site ID' value='context.SiteID' xpos='200' ypos='950' />
<if name='Check request stream length' condition='(request.Stream.SizeGet() = 0) || (context.SiteID="")' xpos='200' ypos='1050' xend='200' yend='3450' >
<true>
<code name='Bad message handler' xpos='200' ypos='1200' >
<![CDATA[ set tmp = ##class(%Library.GlobalBinaryStream).%New()
 set tSC = tmp.%Save()
 
 set context.JSONResponse=##class(EnsLib.HTTP.GenericMessage).%New(tmp,,request.HTTPHeaders)
 Do context.JSONResponse.HTTPHeaders.SetAt("HTTP/1.1 400 INVALID REQUEST","StatusLine")
 
 set tSC= context.JSONResponse.%Save()
]]>
</code>
<assign name="response" property="response" value="context.JSONResponse" action="set" xpos='200' ypos='1300' />
</true>
<false>
<call name='Get authentication token' target='@context.SiteAuthOperation' async='0' xpos='470' ypos='1200' >
<request type='EnsLib.HTTP.GenericMessage' >
<assign property="tmpOBJ" value="##class(%GlobalBinaryStream).%New()" action="set" />
<assign property="tSC" value="tmpOBJ.Write(&quot;username=username&amp;password=password&amp;grant_type=password&amp;client_id=POC&quot;)" action="set" />
<assign property="callrequest" value="##class(EnsLib.HTTP.GenericMessage).%New(tmpOBJ)" action="set" />
<assign property="tSC" value="callrequest.HTTPHeaders.SetAt(&quot;1.1&quot;,&quot;httpversion&quot;)" action="set" />
<assign property="tSC" value="callrequest.HTTPHeaders.SetAt(&quot;POST&quot;,&quot;httprequest&quot;)" action="set" />
<assign property="tSC" value="callrequest.HTTPHeaders.SetAt(&quot;application/x-www-form-urlencoded&quot;,&quot;content-type&quot;)" action="set" />
<assign property="tSC" value="callrequest.HTTPHeaders.SetAt(tmpOBJ.Size,&quot;content-length&quot;)" action="set" />
</request>
<response type='EnsLib.HTTP.GenericMessage' >
<assign property="context.AuthJSONStream" value="callresponse.Stream" action="set" />
<assign property="context.AuthJSONResponse" value="callresponse" action="set" />
</response>
</call>
<trace name='Auth StatusLine' value='context.AuthJSONResponse.HTTPHeaders.GetAt("StatusLine")' xpos='470' ypos='1300' />
<if name='Status Check' condition='context.AuthJSONResponse.HTTPHeaders.GetAt("StatusLine") = "HTTP/1.1 200 OK"' xpos='470' ypos='1400' xend='470' yend='3250' >
<true>
<code name='Prepare auth header' xpos='740' ypos='1550' >
<![CDATA[ set DynOBJ={}.%FromJSON(context.AuthJSONStream)
 set tTokenType=DynOBJ."token_type"
 set tAccessToken=DynOBJ."access_token"
 set context.AuthToken=tTokenType_" "_tAccessToken]]>
</code>
<switch name='Transaction Type' xpos='740' ypos='1650' xend='740' yend='2200' >
<case condition='context.TransactionType [ "GetShipmentStatus"' name='GetShipmentStatus' >
<transform name='DTL for Shipment Status' class='dc.POC.DTL.FilePOCShipmentStatus' source='request' target='context.JSONRequest' xpos='1010' ypos='1800' />
<call name='Shipment Status to DMLSS' target='@context.SiteOperation' async='0' xpos='1010' ypos='1900' >
<request type='EnsLib.HTTP.GenericMessage' >
<assign property="tSC" value="context.ShipmentStatusRequest.HTTPHeaders.SetAt(context.AuthToken,&quot;authorization&quot;)" action="set" />
<assign property="callrequest" value="context.JSONRequest" action="set" />
</request>
<response type='EnsLib.HTTP.GenericMessage' >
<assign property="context.JSONResponse" value="callresponse.%ConstructClone()" action="set" />
</response>
</call>
</case>
<case condition='context.TransactionType [ "GetInternalCustomerCatalog"' name='CatalogDelta' >
<transform name='DTL for Catalog Delta' class='dc.POC.DTL.FilePOCDeltaReq' source='request' target='context.JSONRequest' xpos='1280' ypos='1800' />
<call name='Delta Request to DMLSS' target='@context.SiteOperation' async='0' xpos='1280' ypos='1900' >
<request type='EnsLib.HTTP.GenericMessage' >
<assign property="tSC" value="context.JSONRequest.HTTPHeaders.SetAt(context.AuthToken,&quot;authorization&quot;)" action="set" />
<assign property="callrequest" value="context.JSONRequest" action="set" />
</request>
<response type='EnsLib.HTTP.GenericMessage' >
<assign property="context.JSONResponse" value="callresponse.%ConstructClone()" action="set" />
</response>
</call>
</case>
<case condition='context.TransactionType [ "GetOrderStatus"' name='OrderStatus' >
<transform name='DTL for Order Status' class='dc.POC.DTL.FilePOCOrderStatus' source='request' target='context.JSONRequest1' xpos='1550' ypos='1800' />
<call name='Order Status to DMLSS' target='@context.SiteOperation' async='0' xpos='1550' ypos='1900' >
<request type='EnsLib.HTTP.GenericMessage' >
<assign property="tSC" value="context.JSONRequest1.HTTPHeaders.SetAt(context.AuthToken,&quot;authorization&quot;)" action="set" />
<assign property="callrequest" value="context.JSONRequest1" action="set" />
</request>
<response type='EnsLib.HTTP.GenericMessage' >
<assign property="context.JSONResponse" value="callresponse.%ConstructClone()" action="set" />
</response>
</call>
</case>
<case condition='context.TransactionType [ "InternalOrderRequest"' name='InternalOrderRequest' >
<transform name='DTL for Place Order' class='dc.POC.DTL.FilePOCPlaceOrder' source='request' target='context.OrderJSONReq' xpos='1820' ypos='1800' />
<code name='Converting to JSON' xpos='1820' ypos='1900' >
<![CDATA[ //set context.JSONRequest=request.%ConstructClone()
 //set tSC= context.JSONRequest.%Save()
 set tmp = context.SiteID
 set context.CSVJSONString=context.OrderJSONReq.%ToJSON()

 set tmpOBJ = ##class(%GlobalBinaryStream).%New()
 s tSC=tmpOBJ.Write(context.CSVJSONString)
 set tSC= tmpOBJ.%Save()
   
   set context.JSONRequest1=##class(EnsLib.HTTP.GenericMessage).%New(tmpOBJ,,context.JSONRequest.HTTPHeaders)
   
 set tSC=context.JSONRequest1.HTTPHeaders.SetAt("application/json; charset=utf-8","Content-Type")
 set tSC= context.JSONRequest1.HTTPHeaders.SetAt("POST","HttpRequest")
 set tSC= context.JSONRequest1.HTTPHeaders.SetAt("1.1","HTTPVersion") 
 set tSC= context.JSONRequest1.HTTPHeaders.SetAt("utf-8","CharEncoding")
 set tSC= context.JSONRequest1.HTTPHeaders.SetAt("UTF8","TranslationTable") 
 set tSC= context.JSONRequest1.HTTPHeaders.SetAt("SiteID="_tmp,"RawParams")
 set tSC= context.JSONRequest1.HTTPHeaders.SetAt("1","IParams")
 set tSC= context.JSONRequest1.HTTPHeaders.SetAt("SiteID="_tmp,"IParams_1") 
 set tSC= context.JSONRequest1.HTTPHeaders.SetAt("/csp/healthshare/poc/","CSPApplication") 
 set tSC= context.JSONRequest1.HTTPHeaders.SetAt(context.SourceName,"EnsConfigName") 
 set tHostname = ##class(dc.POC.ProcessPOCHelper).GetHostname()
 set tSC= context.JSONRequest1.HTTPHeaders.SetAt(tHostname,"host") 
 set tSC= context.JSONRequest1.HTTPHeaders.SetAt($L(context.CSVJSONString),"content-length") 
 set tSC= context.JSONRequest1.HTTPHeaders.SetAt("/csp/healthshare/poc/"_context.SourceName_"/PlaceOrder?SiteID="_tmp,"URL") 
 set tSC= context.JSONRequest1.%Save()
]]>
</code>
<trace name='JSON String' value='context.CSVJSONString' xpos='1820' ypos='2000' />
<call name='Place Order to DMLSS' target='@context.SiteOperation' async='0' xpos='1820' ypos='2100' >
<request type='EnsLib.HTTP.GenericMessage' >
<assign property="tSC" value="context.JSONRequest1.HTTPHeaders.SetAt(context.AuthToken,&quot;authorization&quot;)" action="set" />
<assign property="callrequest" value="context.JSONRequest1" action="set" />
</request>
<response type='EnsLib.HTTP.GenericMessage' >
<assign property="context.JSONResponse" value="callresponse.%ConstructClone()" action="set" />
</response>
</call>
</case>
<default>
<assign name="catch all" property="response" value="0" action="set" xpos='740' ypos='1800' />
</default>
</switch>
<trace name='context.JSONResponse' value='context.JSONResponse' xpos='740' ypos='2300' />
<if name='Object Check' condition='$IsObject(context.JSONResponse)' xpos='740' ypos='2400' xend='740' yend='3150' >
<true>
<if name='Status Check' condition='context.JSONResponse.HTTPHeaders.GetAt("StatusLine") = "HTTP/1.1 200 OK"' xpos='875' ypos='2550' xend='875' yend='3050' >
<true>
<switch name='Transaction Type' xpos='1145' ypos='2700' xend='1145' yend='2950' >
<case condition='context.TransactionType [ "GetInternalCustomerCatalog"' name='CatalogDelta' >
<code name='JSON Response to CSV' xpos='1280' ypos='2850' >
<![CDATA[ set tString=context.JSONResponse.Stream
 set DynOBJ={}.%FromJSON(tString)
 set tAccId=DynOBJ."CustomerAccountId"
 set tCatId=DynOBJ."CatalogType"
 set tTransType=context.TransactionType
 
 set tmpH = tTransType_"|CustomerAccountId|ItemID|ShortDescription|Manufacturer|"
 set tmpH = tmpH_"ManufacturerPartNo|NDC|NSN|PackCd|PackQty|MaxOrderQty|Price|MMCId|DeltaType|"
 set tmpH = tmpH_"PreferredProductInd"
 
 Set tSC = ##class(dc.POC.ProcessPOCHelper).Code(tmpH,.context)
 
 d context.JSONStream.WriteLine(tmpH)
 set delim = "|"
 set i=DynOBJ."CatalogItems".%GetIterator()
 while i.%GetNext(.key, .value)
 {
   //$$$TRACE("key = "_key_" , value = "_value)
   set $P(tmp,delim,1) = """"_tTransType_""""
   set $P(tmp,delim,2)= """"_tAccId_""""
   for k=3:1:$L(tmpH,delim)
   {
     set tmpvalue = value.%Get($P(tmpH,delim,k))
     //$$$TRACE("temp value:" _tmpvalue)
     if tmpvalue '= "" {
	    set tmp = tmp_delim_""""_tmpvalue_"""" }
     else { 
     	set tmp = tmp_delim_"""""" }  
   }
  // $$$TRACE(tmp)
   d context.JSONStream.WriteLine(tmp)
   s tmp=""

 }	
 set tSC= context.JSONStream.%Save()

 //set context.JSONResponse=##class(Ens.StreamContainer).%New()
 //set context.JSONReponse.OriginalFilename = context.targetFilename
 //set context.JSONReponse.Stream = context.JSONStream
 //set tSC= context.JSONResponse.%Save()]]>
</code>
</case>
<case condition='context.TransactionType [ "GetShipmentStatus"' name='GetShipmentStatus' >
<code name='JSON Response to CSV' xpos='1550' ypos='2850' >
<![CDATA[ set tString=context.JSONResponse.Stream
 set DynOBJ={}.%FromJSON(tString)
 set tAccId=DynOBJ."CustomerAccountId"
 set tOrdRefNum=DynOBJ."OrderRefNumber"
 set tShipmentType="GetShipmentStatus"
 
 set tmpH = "GetShipmentStatus|CustomerAccountId|OrderRefNumber|ItemId|PackCd|OrderQty|"
 set tmpH = tmpH_"CurrentQty|IncreaseQty|CancelQty|ShipQty|StatusCd"
 
 d context.JSONStream.WriteLine(tmpH)
 set delim="|"		
 set i=DynOBJ."ShipmentLines".%GetIterator()
 while i.%GetNext(.key, .value)
 {
   $$$TRACE("key = "_key_" , value = "_value)
   set j=value.%GetIterator()
   set tmp=tShipmentType_delim_tAccId_delim_tOrdRefNum
   for k=4:1:$L(tmpH,delim)
   {
     set tmpvalue = value.%Get($P(tmpH,delim,k))
     //$$$TRACE("temp value:" _tmpvalue)
     if tmpvalue '= "" {
	    set tmp = tmp_delim_""""_tmpvalue_"""" }
     else { 
     	set tmp = tmp_delim_"""""" }  
   }
  // $$$TRACE(tmp)
   d context.JSONStream.WriteLine(tmp)
   s tmp=""

 }	
 set tSC= context.JSONStream.%Save()
 
 //set 
 //context.JSONResponse=##class(EnsLib.HTTP.GenericMessage).%New(context.JSONStream,,request.HTTPHeaders)
 
 //set tSC= context.JSONResponse.%Save()
 ]]>
</code>
</case>
<case condition='context.TransactionType [ "GetOrderStatus"' name='OrderStatus' >
<code name='JSON Response to CSV' xpos='1820' ypos='2850' >
<![CDATA[ set tString=context.JSONResponse.Stream
 set DynOBJ={}.%FromJSON(tString)
 set tAccId=DynOBJ."CustomerAccountId"
 set tOrdRefNum=DynOBJ."OrderRefNumber"
		
 set tmpH = "GetOrderStatus|CustomerAccountId|OrderRefNumber|ItemId|DocumentNumber|"
 set tmpH = tmpH_"PackCd|OrderQty|CurrentQty|IncreaseQty|CancelQty|ShipQty|StatusCd|StatusText"
 
 d context.JSONStream.WriteLine(tmpH)
 set delim = "|"
 set i=DynOBJ."OrderLines".%GetIterator()
 while i.%GetNext(.key, .value)
 {
   $$$TRACE("key = "_key_" , value = "_value)
   set $P(tmp,delim,1) = "GetOrderStatus"
   set $P(tmp,delim,2)= tAccId
   set $P(tmp,delim,3) = tOrdRefNum
   
   for k=4:1:$L(tmpH,delim)
   {
     set tmpvalue = value.%Get($P(tmpH,delim,k))
     //$$$TRACE("temp value:" _tmpvalue)
     if tmpvalue '= "" {
	    set tmp = tmp_delim_""""_tmpvalue_"""" }
     else { 
     	set tmp = tmp_delim_"""""" }  
   }
  // $$$TRACE(tmp)
   d context.JSONStream.WriteLine(tmp)
   s tmp=""

 }	
 set tSC= context.JSONStream.%Save()
 ]]>
</code>
</case>
<case condition='context.TransactionType [ "InternalOrderRequest"' name='InternalOrderRequest' >
<code name='JSON Response to CSV' xpos='2090' ypos='2850' >
<![CDATA[  set tString=context.JSONResponse.Stream
 set DynOBJ={}.%FromJSON(tString)
 set tAccId=DynOBJ."CustomerAccountId"
 set tOrdRefNum=DynOBJ."OrderRefNumber"
		
 set tmpH = "InternalOrderRequest|CustomerAccountId|OrderRefNumber|ItemId|DocumentNumber|"
 set tmpH = tmpH_"PackCd|OrderQty|CurrentQty|IncreaseQty|CancelQty|ShipQty|StatusCd|StatusText"
 
 
 d context.JSONStream.WriteLine(tmpH)
 set delim = "|"
 set i=DynOBJ."OrderLines".%GetIterator()
 while i.%GetNext(.key, .value)
 {
   $$$TRACE("key = "_key_" , value = "_value)
   set $P(tmp,delim,1) = "InternalOrderRequest"
   set $P(tmp,delim,2)= tAccId
   set $P(tmp,delim,3) = tOrdRefNum
   
   for k=4:1:$L(tmpH,delim)
   {
     set tmpvalue = value.%Get($P(tmpH,delim,k))
     //$$$TRACE("temp value:" _tmpvalue)
     if tmpvalue '= "" {
	    set tmp = tmp_delim_""""_tmpvalue_"""" }
     else { 
     	set tmp = tmp_delim_"""""" }  
   }
  // $$$TRACE(tmp)
   d context.JSONStream.WriteLine(tmp)
   s tmp=""

 }	
 set tSC= context.JSONStream.%Save()
 
 
 
 //set 
 //context.JSONResponse=##class(EnsLib.HTTP.GenericMessage).%New(context.JSONStream,,request.HTTPHeaders)
 
 //set tSC= context.JSONResponse.%Save()
 ]]>
</code>
</case>
<default name='default' />
</switch>
</true>
<false>
<assign name="context.JSONStream" property="context.JSONStream" value="context.JSONResponse.Stream" action="set" xpos='875' ypos='2700' />
</false>
</if>
</true>
</if>
</true>
<false>
<assign name="response" property="response" value="context.AuthJSONResponse" action="set" xpos='470' ypos='1550' />
</false>
</if>
<call name='Write Response to file' target='@context.ResponseFileOperation' async='1' xpos='470' ypos='3350' >
<request type='Ens.StreamContainer' >
<assign property="callrequest.Stream" value="context.JSONStream" action="set" />
<assign property="callrequest.OriginalFilename" value="##class(dc.POC.ProcessPOCHelper).GetResponseFilename(request)" action="set" />
</request>
<response type='Ens.Response' />
</call>
</false>
</if>
</sequence>
</process>
}

}
