Class dc.POC.ProcessPOCHelper
{

/// <assign name="TransactionType" property="context.TransactionType" value="request.HTTPHeaders.GetAt(&quot;URL&quot;)" action="set" xpos='200' ypos='250' />
ClassMethod GetTransactionType(pRequest As Ens.Request = "") As %String
{
	Set ^DEBUG($I(^DEBUG)) = pRequest
	If pRequest.%IsA("Ens.StreamContainer") {
		#DIM pRequest2 As Ens.StreamContainer
		Set tTransactionType = $Piece(pRequest.OriginalFilename,"_",2)  // 657A5_GetInternalCustomerCatalog_202110211432.csv
		Set ^DEBUG($G(^DEBUG),"OriginalFilename") = pRequest.OriginalFilename
	}
	Set ^DEBUG($G(^DEBUG),"tTransactionType") = $Get(tTransactionType)
	Quit $Get(tTransactionType)
}

/// <assign name="extract Site ID" property="context.SiteID" value="$P(request.HTTPHeaders.GetAt(&quot;RawParams&quot;),&quot;=&quot;,2)" action="set" xpos='200' ypos='450' />
ClassMethod GetSiteID(pRequest As Ens.Request = "") As %String
{
	Set ^DEBUG($I(^DEBUG)) = pRequest
	If pRequest.%IsA("Ens.StreamContainer") {
		#DIM pRequest2 As Ens.StreamContainer
		Set temp = $TRANSLATE(pRequest.OriginalFilename,"\","/")
		Set tLen = $Length(temp,"/")
		Set tFnam = $P($Piece(temp,"/",tLen),"_",1)
		Set tSiteID = tFnam
		Set ^DEBUG($G(^DEBUG),"OriginalFilename") = pRequest.OriginalFilename
	}
	Set ^DEBUG($G(^DEBUG),"tSiteID") = $Get(tSiteID)
	Quit $Get(tSiteID)
}

ClassMethod GetResponseFilename(pRequest As Ens.Request = "") As %String
{
	Set ^DEBUG($I(^DEBUG)) = pRequest
	If pRequest.%IsA("Ens.StreamContainer") {
		#DIM pRequest2 As Ens.StreamContainer
		Set temp = $TRANSLATE(pRequest.OriginalFilename,"\","/")
		Set tLen = $Length(temp,"/")
		Set tFnam = $Piece(temp,"/",tLen)
		Set tLen = $Length(temp,".")
		Set tBefore = $Piece(tFnam,".",1,tLen-1)
		Set tRespFnam = "Response_"_tBefore
		Set ^DEBUG($G(^DEBUG),"ResponseFilename") = tRespFnam
	}
	Set ^DEBUG($G(^DEBUG),"tRespFnam") = $Get(tRespFnam)
	Quit $Get(tRespFnam)
}

ClassMethod GetHostname(pArg As %String = "") As %String
{

	Set tHostname=$SYSTEM.INetInfo.LocalHostName()
	Quit tHostname
}

ClassMethod ReadFile(pFile As %String) As %String
{
	If ($Get(pFile) = "") Quit ""
	Set timeout = 2
	Try {
		Open pFile:("R"):timeout  // read
		If $test {
			Use pFile
			Read host
			Close pFile
		}
	} Catch {
	}
	Set tReturn = $Get(host)
	Quit tReturn
}

}
