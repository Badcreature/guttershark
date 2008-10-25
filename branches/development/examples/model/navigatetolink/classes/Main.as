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
			return {model:"model.xml"};
		}
		
		override protected function setupComplete():void
		{
			ml.navigateToLink("google");
		}	}}