Class dc.POC.ApiUtil
{

ClassMethod GetInternalCustomerCatalogDelta(ByRef pStream As %String) As %String
{
	Set c = ","
	Set d = ":"
	Set q = """"
	Set labCT = q_"CatalogType"_q
	Set valCT = q_"InternalCustomerCatalogDelta"_q
	Set labCRS = q_"CatalogRecordSource"_q
	Set valCRS = q_556_q
	Set labCA = q_"CustomerAccountId"_q
	Set valCA = q_"222123"_q
	Set labCI = q_"CatalogItems"_q
	Set pStream = "{"_labCT_d_valCT_c_labCRS_d_valCRS_c_labCA_d_valCA_c_labCI_d_"[]}"
	Quit pStream
}

}
