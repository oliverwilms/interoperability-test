/// Business process that will generate Api responses
Class dc.POC.ProcessPOCApiRequest Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' >
<sequence xend='200' yend='350' >
      <transform class='dc.POC.DTL.AuthReq' source='request' target='response' xpos='200' ypos='250' />
</sequence>
</process>
}

}
