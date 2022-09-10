Class dc.POC.AuthUtil
{

ClassMethod GetAuthToken(ByRef pAuth As %String) As %String
{
	Set tAccessToken = "my_token"
	Set tTokenType = "my_type"
	Set data = {}
	Set data."access_token" = tAccessToken
	Set data."token_type" = tTokenType
	Set pAuth = data.%ToJSON()
	Set tSC = $$$OK
	Quit pAuth
}

}
