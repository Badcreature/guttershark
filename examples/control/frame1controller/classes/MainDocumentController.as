package
{
	import net.guttershark.control.DocumentController;
	import net.guttershark.display.buttons.MovieClipButton;

	public class MainDocumentController extends DocumentController
	{
		
		public var bt:MovieClipButton;

		public function MainDocumentController()
		{
			trace("Constructor for Main Document Controller, starting app..");
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			//etc...
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