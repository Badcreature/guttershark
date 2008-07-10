package
{
	import net.guttershark.events.delegates.PreloadControllerEventListenerDelegate;	
	import net.guttershark.events.EventManager;	
	
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

		private var pc:PreloadController;
		private var em:EventManager;
		private var ml:Model;
		
		public var bar:MovieClip;
		

		public function Main()
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"site.xml", akamaiHost:"http://cp44952.edgefcs.net/"};
		}
		
		override protected function setupComplete():void
		{
			em = EventManager.gi();
			em.addEventListenerDelegate(PreloadController,PreloadControllerEventListenerDelegate);
			pc = new PreloadController(550);
			ml = Model.gi();
			startPreload();
		}
		
		private function startPreload():void
		{
			pc.addItems(ml.getAssetsForPreload());
			em.handleEvents(pc, this, "onPC");
			pc.start();
		}

		public function onPCProgress(e:PreloadProgressEvent):void
		{
			TweenMax.to(bar,1,{width:e.pixels,ease:Quadratic.easeInOut});
		}
		
		public function onPCComplete():void
		{
			em.disposeEventsForObject(pc);
			var mc:MovieClip = AssetLibrary.gi().getMovieClipFromSWFLibrary("swftest", "Test");
			addChild(mc);
		}
		
		override protected function akamaiIdentComplete(ip:String):void
		{
			trace("AKAMAI IP:", ip);
			AkamaiNCManager.FMS_IP = ip;
			VideoPlayer.iNCManagerClass = "net.guttershark.akamai.AkamaiNCManager";
		}
	}
}
