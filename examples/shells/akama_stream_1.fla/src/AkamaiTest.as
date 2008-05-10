/**
 * Copyright Mccann Worldgroup 2008
 */
package
{
	import net.guttershark.util.Bandwidth;	
	import net.guttershark.util.CPU;	
	import net.guttershark.akamai.AkamaiNCManager;	

	import fl.motion.easing.Quadratic;

	import flash.net.SharedObject;
	import flash.events.ProgressEvent;
	import flash.display.MovieClip;
	import flash.utils.*;
	import flash.events.Event;

	import net.guttershark.control.DocumentController;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.preloading.Asset;
	import net.guttershark.preloading.events.PreloadProgressEvent;
	import net.guttershark.preloading.events.AssetCompleteEvent;
	
	import gs.TweenMax;	
	
	public class AkamaiTest extends DocumentController
	{

		private var sitePreloader:PreloadController;
		
		public var bar:MovieClip;

		public function AkamaiTest()
		{
			super();
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS,onSWFProgress);
			this.loaderInfo.addEventListener(Event.COMPLETE, onSWFComplete);
		}
		
		private function onSWFProgress(p:ProgressEvent):void
		{
			trace("ON SWF PROGRESS");
			trace(p.bytesLoaded);
			trace(p.bytesTotal);
		}
		
		private function onSWFComplete(e:*):void
		{
			trace("COMPLETE SWF");
			trace(CPU.Speed);
			
		}

		/*MAKE SURE TO CALL SUPER HERE. see akamaiIdentComplete */
		override protected function setupComplete():void
		{
			flash.utils.setTimeout(startPreload,1000);
			trace("BANDWIDTH!!!!!!!!!!!!!!!!",Bandwidth.Speed);
		}
		
		private function startPreload():void
		{
			trace("start preloading");
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
			sitePreloader.addEventListener(AssetCompleteEvent.COMPLETE, onItemComplete);
			sitePreloader.addEventListener(PreloadProgressEvent.PROGRESS, onProgress);
			sitePreloader.start();
			sitePreloader.prioritize(a1);
		}
		
		private function onItemComplete(e:AssetCompleteEvent):void
		{
			trace("ASSET COMPLETE",e.asset.source);
		}

		private function onProgress(e:PreloadProgressEvent):void
		{
			trace("PIXELS: " + e.pixels + " PERCENT: " + e.percent);
			TweenMax.to(bar,1,{width:e.pixels,ease:Quadratic.easeInOut});
		}
		
		private function onComplete(e:*):void
		{
			trace("TOTALLY COMPLETE");
			var mc:MovieClip = sitePreloader.library.getMovieClipFromSWFLibrary("test", "Test");
			addChild(mc);
			trace(DocumentController.Instance);
			DocumentController.Instance.test();
		}
		
		public function test():void
		{
			trace("TEST");
		}

		override protected function flashvarsForStandalone():Object
		{
			trace("getting default flash vars");
			return {siteXML:"site.xml",akamaiHost:"http://cp44952.edgefcs.net/",sniffCPU:true,sniffBandwidth:true};
		}
		
		override protected function deeplinkDataForQueryString():Dictionary
		{
			trace("getting default deeplink data");
			var deep:Dictionary = new Dictionary(true);
			deep['deeplink1'] = "hello";
			return deep;
		}
				
		override protected function restoreSharedObject():void
		{
			trace("should restore shared object");
			sharedObject = SharedObject.getLocal("test");
			trace(flushSharedObject());
		}
		
		override protected function akamaiIdentComplete(ip:String):void
		{
			trace("AKAMI COMPLETE");
			AkamaiNCManager.FMS_IP = ip;
			trace(ip);
		}
	}
}
