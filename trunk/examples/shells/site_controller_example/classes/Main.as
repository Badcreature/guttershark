/**
 * Copyright Mccann Worldgroup 2008
 */
package
{
	import net.guttershark.model.SiteXMLParser;	

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
		
		override protected function flashvarsForStandalone():Object
		{
			return {siteXML:"site.xml",sniffCPU:true,sniffBandwidth:true,onlineStatus:true};
		}
		
		override protected function setupComplete():void
		{
			startPreload();
			trace("CPU SPEED:", CPU.Speed);
			trace("BANDWIDTH:",Bandwidth.Speed);
			keyboardEventManager.addKeyMapping(this,Keyboard.SPACE, onSpace);
			keyboardEventManager.scope = this;
		}
		
		private function startPreload():void
		{
			sitePreloader = new PreloadController(550);
			var siteXMLParser:SiteXMLParser = new SiteXMLParser(siteXML);
			sitePreloader.addItems(siteXMLParser.getAssetsForPreload());
			sitePreloader.addEventListener(Event.COMPLETE, onPreloadComplete);
			sitePreloader.addEventListener(PreloadProgressEvent.PROGRESS, onProgress);
			sitePreloader.start();
		}
		
		private function onProgress(e:PreloadProgressEvent):void
		{
			//trace("PIXELS: " + e.pixels + " PERCENT: " + e.percent);
			TweenMax.to(bar,1,{width:e.pixels,ease:Quadratic.easeInOut});
		}

		private function onPreloadComplete(e:*):void
		{
			//trace("TOTALLY COMPLETE");
			var mc:MovieClip = sitePreloader.library.getMovieClipFromSWFLibrary("swftest", "Test");
			addChild(mc);
		}
		
		private function onSpace():void
		{
			trace("SPACE PRESSED");
		}
	}
}