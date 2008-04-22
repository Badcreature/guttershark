package  
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.*;
	
	import net.guttershark.preloading.Asset;
	import net.guttershark.preloading.events.AssetCompleteEvent;
	import net.guttershark.preloading.events.PreloadProgressEvent;
	import net.guttershark.preloading.PreloadController;
	
	import gs.TweenMax;
	
	public class PreloaderTest extends MovieClip 
	{

		private var preloadController:PreloadController;
		public var preloader:MovieClip;

		public function PreloaderTest()
		{
			super();
			this.loaderInfo.addEventListener(Event.COMPLETE, onSWFComplete);
		}

		private function onSWFComplete(e:Event):void
		{
			//you should have an assets folder local to the swf with these assets in it.
			var a:Asset = new Asset("assets/swfload_test.swf","swf1");
			var assets:Array = [
				new Asset("assets/jpg1.jpg","jpg1"),
				new Asset("assets/jpg2.jpg","jpg2"),
				new Asset("assets/png1.png","png1"),
				new Asset("assets/png2.png","png2"),
				new Asset("assets/sound1.mp3","snd1"),
				a,
				new Asset("assets/Pizza_Song.flv","pizza"),
				new Asset("assets/zip1.zip","zip1")
			];
			//note that above, a insn't in the array because of the prioritize call to it.
			
			preloadController = new PreloadController(400);
			preloadController.addItems(assets);
			preloadController.addEventListener(PreloadProgressEvent.PROGRESS, onProgress);
			preloadController.addEventListener(Event.COMPLETE,onPreloaderComplete);
			preloadController.addEventListener(AssetCompleteEvent.COMPLETE, onItemComplete);
			preloadController.prioritize(a); //prioritize the swf.
			preloadController.start(); //start it;
			preloadController.stop(); //pause it
			setTimeout(preloadController.start,4000); //resume it
		}
		
		private function onProgress(pe:PreloadProgressEvent):void
		{
			trace("progress: pixels: " + pe.pixels + " percent: " + pe.percent);
			TweenMax.to(preloader,.5,{width:pe.pixels,overwrite:false});
		}
		
		private function onItemComplete(e:AssetCompleteEvent):void
		{
			trace(e.asset.libraryName + " " + e.asset.source);
		}

		private function onPreloaderComplete(e:*):void
		{
			trace("PRELOAER COMPLETE");
			addChild(preloadController.library.getMovieClipFromSWFLibrary("swf1", "Test"));
			addChild(preloadController.library.getBitmap("jpg1"));
		}
	}
}
