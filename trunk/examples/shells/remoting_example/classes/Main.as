package
{
	
	import net.guttershark.model.SiteXMLParser;	
	import net.guttershark.control.DocumentController;	
	
	public class Main extends DocumentController 
	{
		
		public function Main()
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {siteXML:"site.xml",sniffBandwidth:true,sniffCPU:true};
		}
		
		override protected function setupComplete():void
		{
			var siteXMLParser:SiteXMLParser = new SiteXMLParser(siteXML);
			remotingManager = siteXMLParser.createRemotingManagerForEndpoint("endpoint1");
			trace(remotingManager.getService(Services.SERVICE1));
			trace(remotingManager.getService(Services.SERVICE2));
		}
	}
}