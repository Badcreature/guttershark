package
{

	import fl.video.VideoPlayer;
	import fl.motion.easing.Quadratic;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import net.guttershark.model.Model;
	import net.guttershark.akamai.AkamaiNCManager;
	import net.guttershark.control.DocumentController;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.preloading.events.PreloadProgressEvent;
	import net.guttershark.preloading.AssetLibrary;
	
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
			TweenMax.to(bar,1,{width:e.pixels,ease:Quadratic.easeInOut});
		}
		
		private function onPreloadComplete(e:*):void
		{
			var mc:MovieClip = AssetLibrary.gi().getMovieClipFromSWFLibrary("swftest", "Test");
			addChild(mc);
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {siteXML:"site.xml", akamaiHost:"http://cp44952.edgefcs.net/"};
		}
		
		override protected function akamaiIdentComplete(ip:String):void
		{
			trace("AKAMAI IP:", ip);
			AkamaiNCManager.FMS_IP = ip;
			VideoPlayer.iNCManagerClass = "net.guttershark.akamai.AkamaiNCManager";
		}
	}
}
