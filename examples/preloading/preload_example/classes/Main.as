package  
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.*;
	
	import net.guttershark.preloading.Asset;
	import net.guttershark.preloading.events.AssetCompleteEvent;
	import net.guttershark.preloading.events.PreloadProgressEvent;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.control.DocumentController;	
	import net.guttershark.model.Model;
	import net.guttershark.preloading.AssetLibrary;
	
	import gs.TweenMax;
	
	public class Main extends DocumentController 
	{

		private var preloadController:PreloadController;
		public var preloader:MovieClip;

		public function Main()
		{
			super();
		}

		override protected function flashvarsForStandalone():Object
		{
			return {siteXML:"site.xml"};
		}

		override protected function setupComplete():void
		{
			var siteXMLParser:Model = new Model(siteXML);
			preloadController = new PreloadController(400);
			preloadController.addItems(siteXMLParser.getAssetsForPreload());
			preloadController.addEventListener(PreloadProgressEvent.PROGRESS, onProgress);
			preloadController.addEventListener(Event.COMPLETE,onPreloaderComplete);
			preloadController.addEventListener(AssetCompleteEvent.COMPLETE, onItemComplete);
			preloadController.start(); //start it;
			//preloadController.stop(); //pause it
			//setTimeout(preloadController.start,4000); //resume it
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
			addChild(AssetLibrary.gi().getMovieClipFromSWFLibrary("swftest", "Test"));
			addChild(AssetLibrary.gi().getBitmap("jpg1"));
		}
	}
}
