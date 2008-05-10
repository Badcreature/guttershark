package 
{
	import flash.utils.Dictionary;	

	import net.guttershark.control.DocumentController;	
	
	public class Main extends DocumentController 
	{
		
		public function Main()
		{
			super();
		}
		
		/**
		 * When fake query string data is needed (when in the Flash IDE) use this method.
		 */
		override protected function deeplinkDataForQueryString():Dictionary
		{
			var fakeQS:Dictionary = new Dictionary();
			fakeQS['videoID'] = 100;
			return fakeQS;
		}
		
		override protected function setupComplete():void
		{
			trace(queryString.videoID);
		}
			}}