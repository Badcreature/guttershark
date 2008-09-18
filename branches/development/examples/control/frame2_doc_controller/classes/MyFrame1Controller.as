package 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import net.guttershark.control.Frame1Controller;	

	public class MyFrame1Controller extends Frame1Controller 
	{
		
		public var preloader:MovieClip;
		public var percentLabel:TextField;

		public function MyFrame1Controller()
		{
			super();
		}
		
		override protected function onProgress(pixels:int, percent:Number):void
		{
			trace("loading",pixels,percent);
			preloader.width = pixels;
			percentLabel.text = percent.toString() + "%";
		}
		
		override protected function get pixelsToFill():int
		{
			return 550;
		}
		
		override protected function gotoStartFrame():void
		{
			//trace("preload complete, start the app/site.");
			gotoAndStop(2); //the reall
			dispose();
		}
		
		override protected function dispose():void
		{
			super.dispose();
			trace("dispose");
			preloader = null;
			percentLabel = null;
		}	}}