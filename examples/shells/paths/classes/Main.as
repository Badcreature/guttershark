package 
{
	import fl.controls.Button;	
	
	import net.guttershark.model.Model;	
	import net.guttershark.control.DocumentController;	
	
	public class Main extends DocumentController 
	{
		
		private var ml:Model;
		public var test:Button;

		public function Main()
		{
			super();
		}

		override protected function setupComplete():void
		{
			super.setupComplete();
			test.addEventListener("click",onc);
			trace("setup complete");
		}
		
		private function onc(e:*):void
		{
			trace(ml.getPath("root","assets","bitmaps","bitmaps"));
		}
		
		override protected function initModel():void
		{
			trace("init model");
			ml = Model.gi();
		}
		
		override protected function initPathsForStandalone():void
		{
			trace("init paths for standalone");
			ml.addPath("root","http://tagsf.com/");
			ml.addPath("assets","assets/");
			ml.addPath("bitmaps","bitmaps/");
			trace(ml.getPath("root","assets"));
		}	}}