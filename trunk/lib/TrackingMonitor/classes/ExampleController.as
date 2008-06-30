package  
{
	import flash.display.MovieClip;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.events.EventManager;

	public class ExampleController extends DocumentController
	{

		public var testButton:MovieClip;
		private var em:EventManager;

		public function ExampleController()
		{
			em = EventManager.gi();
			em.handleEvents(testButton,this,"onTestButton",false,true,true);
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {trackingSimulateXMLFile:"./tracking.xml",trackingMonitor:true};
		}
		
		/*public function onTestButtonClick():void
		{
			trace("test button click");
		}*/
		
		override protected function setupComplete():void
		{
			trace("setup complete");
			trace(flashvars.trackingMonitor);
		}	}}