package
{
	
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

		}
	}
}