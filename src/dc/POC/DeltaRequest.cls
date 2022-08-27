Class dc.POC.DeltaRequest Extends Ens.Request
{

/// GetInternalCustomerCatalogDelta
Property CatalogDelta As %String;

/// customerAccountId
Property AccountId As %String;

Storage Default
{
<Data name="DeltaRequestDefaultData">
<Subscript>"DeltaRequest"</Subscript>
<Value name="1">
<Value>CatalogDelta</Value>
</Value>
<Value name="2">
<Value>AccountId</Value>
</Value>
</Data>
<DefaultData>DeltaRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
