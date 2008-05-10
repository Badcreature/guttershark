/**
 * Copyright Mccann Worldgroup 2008
 */
package
{
	import fl.video.VideoPlayer;	

	import net.guttershark.util.Bandwidth;	
	import net.guttershark.akamai.AkamaiNCManager;	

	import fl.motion.easing.Quadratic;

	import flash.display.MovieClip;
	import flash.utils.*;
	import flash.events.Event;

	import net.guttershark.control.DocumentController;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.preloading.Asset;
	import net.guttershark.preloading.events.PreloadProgressEvent;
	
	import gs.TweenMax;	
	
	public class Main extends DocumentController
	{

		private var sitePreloader:PreloadController;
		public var bar:MovieClip;

		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			flash.utils.setTimeout(startPreload,1000);
			
		}
		
		private function startPreload():void
		{
			var a1:Asset = new Asset("assets/swfload_test.swf","test");
			var assetsToLoad:Array = [
				new Asset("assets/asset_1.jpg","asset_1"),
				new Asset("assets/asset_2.jpg","asset_2"),
				new Asset("assets/Pizza_Song.flv","pizza_song"),
				new Asset("assets/test.xml","testxml"),
				a1
			];
			sitePreloader = new PreloadController(550);
			sitePreloader.addItems(assetsToLoad);
			sitePreloader.addEventListener(Event.COMPLETE, onPreloadComplete);
			sitePreloader.addEventListener(PreloadProgressEvent.PROGRESS, onProgress);
			sitePreloader.start();
			sitePreloader.prioritize(a1);
		}

		private function onProgress(e:PreloadProgressEvent):void
		{
			TweenMax.to(bar,1,{width:e.pixels,ease:Quadratic.easeInOut});
		}
		
		private function onPreloadComplete(e:*):void
		{
			var mc:MovieClip = sitePreloader.library.getMovieClipFromSWFLibrary("test", "Test");
			addChild(mc);
		}

		override protected function flashvarsForStandalone():Object
		{
			return {akamaiHost:"http://cp44952.edgefcs.net/",sniffBandwidth:true};
		}
		
		override protected function akamaiIdentComplete(ip:String):void
		{
			trace("AKAMI COMPLETE");
			AkamaiNCManager.FMS_IP = ip;
			VideoPlayer.iNCManagerClass = "net.guttershark.akamai.AkamaiNCManager";
			trace("BANDWIDTH:",Bandwidth.Speed);
			trace("AKAMAI IP:", ip);
		}
	}
}
