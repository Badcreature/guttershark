package
{
	import flash.display.MovieClip;
	
	import fl.motion.easing.Quadratic;
	
	import gs.TweenMax;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.events.EventManager;
	import net.guttershark.events.delegates.PreloadControllerEventListenerDelegate;
	import net.guttershark.managers.KeyboardEventManager;
	import net.guttershark.model.Model;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.preloading.events.PreloadProgressEvent;
	import net.guttershark.util.Bandwidth;
	import net.guttershark.util.CPU;	

	public class Main extends DocumentController
	{

		private var pc:PreloadController;
		private var km:KeyboardEventManager;
		private var ml:Model;
		private var em:EventManager;
		public var bar:MovieClip;

		public function Main()
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"site.xml",sniffCPU:true,sniffBandwidth:true,onlineStatus:true};
		}
		
		override protected function setupComplete():void
		{
			trace("CPU SPEED:", CPU.Speed);
			pc = new PreloadController(550);
			em = EventManager.gi();
			em.addEventListenerDelegate(PreloadController,PreloadControllerEventListenerDelegate);
			ml = Model.gi();
			km = KeyboardEventManager.gi();
			km.addMapping(stage," ",onSpace);
			startPreload();
		}
		
		override protected function onBandwidthSniffComplete():void
		{
			trace("bandwidth complete");
			trace("BANDWIDTH:",Bandwidth.Speed);
		}
		
		private function startPreload():void
		{
			pc.addItems(ml.getAssetsForPreload());
			em.handleEvents(pc, this, "onPC");
			pc.start();
		}
		
		public function onPCProgress(e:PreloadProgressEvent):void
		{
			//trace("PIXELS: " + e.pixels + " PERCENT: " + e.percent);
			TweenMax.to(bar,1,{width:e.pixels,ease:Quadratic.easeInOut});
		}

		public function onPCComplete():void
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
