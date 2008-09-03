package  
{
	import net.guttershark.preloading.AssetTypes;	
	
	import flash.display.MovieClip;
	
	import gs.TweenMax;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.events.EventManager;
	import net.guttershark.events.delegates.PreloadControllerEventListenerDelegate;
	import net.guttershark.model.Model;
	import net.guttershark.preloading.Asset;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.preloading.events.AssetCompleteEvent;
	import net.guttershark.preloading.events.PreloadProgressEvent;	

	public class Main extends DocumentController 
	{

		private var preloadController:PreloadController;
		private var ml:Model;
		private var em:EventManager;
		public var preloader:MovieClip;

		public function Main()
		{
			super();
		}

		override protected function flashvarsForStandalone():Object
		{
			return {model:"site.xml",autoInitModel:true};
		}

		override protected function setupComplete():void
		{
			ml = Model.gi();
			ml.setRootURL("./");
			ml.addPath("assets", "/assets");
			ml.addPath("bitmap","/assets");
			em = EventManager.gi();
			em.addEventListenerDelegate(PreloadController,PreloadControllerEventListenerDelegate);
			preloadController = new PreloadController(400);
			preloadController.addItems(ml.getAssetsForPreload());
			em.handleEvents(preloadController, this, "onPC");
			preloadController.start(); //start it; for demo
			//preloadController.stop(); //pause it; for demo
			//setTimeout(preloadController.start,4000); //resume it; for demo
		}
		
		public function onPCComplete():void
		{
			em.disposeEventsForObject(preloadController);
			addChild(AssetLibrary.gi().getMovieClipFromSWFLibrary("swftest", "Test"));
			addChild(AssetLibrary.gi().getBitmap("jpg1"));
		}
		
		public function onPCProgress(pe:PreloadProgressEvent):void
		{
			trace("progress: pixels: " + pe.pixels + " percent: " + pe.percent);
			TweenMax.to(preloader,.5,{width:pe.pixels,overwrite:false});
		}

		public function onPCAssetComplete(ace:AssetCompleteEvent):void
		{
			trace("ASSET COMPLETE: " + ace.asset.libraryName + " " + ace.asset.source);
		}
	}
}
