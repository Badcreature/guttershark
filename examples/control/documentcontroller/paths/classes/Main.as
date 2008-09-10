package 
{
	import fl.controls.Button;	
	
	import net.guttershark.model.Model;	
	import net.guttershark.control.DocumentController;	
	
	public class Main extends DocumentController 
	{
		
		public var test:Button;

		public function Main()
		{
			super();
		}
		
		override protected function initPathsForStandalone():void
		{
			trace("init paths for standalone");
			ml.addPath("root","http://tagsf.com/");
			ml.addPath("assets","assets/");
			ml.addPath("bitmaps","bitmaps/");
			trace(ml.getPath("root","assets"));
		}
		
		override protected function initModel():void
		{
			super.initModel();
			trace("init model");
		}
		
		override protected function setupComplete():void
		{
			super.setupComplete();
			em.handleEvents(test, this, "onTest");
			trace("setup complete");
		}
		
		public function onTestClick():void
		{
			trace(ml.getPath("root","assets","bitmaps","bitmaps"));
		}	}}