package
{
	import flash.display.MovieClip;
	
	import fl.motion.easing.Quadratic;
	
	import gs.TweenMax;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.control.PreloadController;
	import net.guttershark.managers.AssetManager;
	import net.guttershark.managers.EventManager;
	import net.guttershark.managers.KeyboardEventManager;
	import net.guttershark.support.preloading.events.PreloadProgressEvent;
	import net.guttershark.util.Bandwidth;
	import net.guttershark.util.CPU;	

	public class Main extends DocumentController
	{
		
		public var bar:MovieClip;

		public function Main()
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml",sniffCPU:true,sniffBandwidth:true,onlineStatus:true,autoInitModel:true};
		}
		
		override protected function setupComplete():void
		{
			trace("CPU SPEED:", CPU.Speed);
			pc = new PreloadController(550);
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
			trace("PIXELS: " + e.pixels + " PERCENT: " + e.percent);
			TweenMax.to(bar,1,{width:e.pixels,ease:Quadratic.easeInOut});
		}

		public function onPCComplete():void
		{
			var mc:MovieClip = AssetManager.gi().getMovieClipFromSWFLibrary("swftest", "Test");
			addChild(mc);
		}
		
		private function onSpace():void
		{
			trace("SPACE PRESSED");
		}
	}
}
