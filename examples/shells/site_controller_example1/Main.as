/**
 * Copyright Mccann Worldgroup 2008
 */
package
{
	
	import fl.motion.easing.Quadratic;
	import flash.ui.Keyboard;
	import flash.display.MovieClip;
	import flash.utils.*;
	import flash.events.Event;
	
	import net.guttershark.util.Bandwidth;	
	import net.guttershark.util.CPU;
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
			startPreload();
			trace("CPU SPEED:", CPU.Speed);
			trace("BANDWIDTH:",Bandwidth.Speed);
			keyboardEventManager.addKeyMapping(this,Keyboard.SPACE, onSpace);
			keyboardEventManager.scope = this;
		}
		
		private function onSpace():void
		{
			trace("SPACE PRESSED");
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
			sitePreloader.addEventListener(Event.COMPLETE, onComplete);
			sitePreloader.addEventListener(PreloadProgressEvent.PROGRESS, onProgress);
			sitePreloader.start();
			sitePreloader.prioritize(a1);
		}

		private function onProgress(e:PreloadProgressEvent):void
		{
			//trace("PIXELS: " + e.pixels + " PERCENT: " + e.percent);
			TweenMax.to(bar,1,{width:e.pixels,ease:Quadratic.easeInOut});
		}

		private function onComplete(e:*):void
		{
			//trace("TOTALLY COMPLETE");
			var mc:MovieClip = sitePreloader.library.getMovieClipFromSWFLibrary("test", "Test");
			addChild(mc);
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {siteXML:"site.xml",sniffCPU:true,sniffBandwidth:true,onlineStatus:true};
		}
		
		override protected function queryStringForStandalone():Dictionary
		{
			var deep:Dictionary = new Dictionary(true);
			deep['deeplink1'] = "hello";
			return deep;
		}
		
		override protected function applicationOnline():void
		{
			trace("ONLINE");
		}
		
		override protected function applicationOffline():void
		{
			trace("OFFLINE");
		}
	}
}
