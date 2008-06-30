package
{

	import fl.motion.easing.Quadratic;
	import flash.display.MovieClip;
	import flash.events.Event;

	import net.guttershark.util.Bandwidth;	
	import net.guttershark.util.CPU;
	import net.guttershark.control.DocumentController;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.preloading.events.PreloadProgressEvent;
	import net.guttershark.model.Model;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.managers.KeyboardEventManager;
	
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
			KeyboardEventManager.gi().addMapping(stage," ",onSpace);
		}
		
		override protected function onBandwidthSniffComplete():void
		{
			trace("bandwidth complete");
			trace("BANDWIDTH:",Bandwidth.Speed);
		}
		
		private function startPreload():void
		{
			sitePreloader = new PreloadController(550);
			var siteXMLParser:Model = new Model(siteXML);
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
			var mc:MovieClip = AssetLibrary.gi().getMovieClipFromSWFLibrary("swftest", "Test");
			addChild(mc);
		}
		
		private function onSpace():void
		{
			trace("SPACE PRESSED");
		}
	}
}
