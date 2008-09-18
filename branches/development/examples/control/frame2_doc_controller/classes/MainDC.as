package
{
	import net.guttershark.control.DocumentController;
	import net.guttershark.display.buttons.MovieClipButton;		

	public class MainDC extends DocumentController
	{
		
		public var bt:MovieClipButton;

		public function MainDC()
		{
			trace("main DC");
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			//return {model:"test.xml"};
			return {};
		}
		
		override protected function setupComplete():void
		{
			trace("setupComplete");
			em.handleEvents(bt, this, "onBT");
		}
		
		public function onBTClick():void
		{
			trace("WORD");
		}	}}