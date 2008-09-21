package  
{
	import flash.display.MovieClip;
	
	import gs.TweenMax;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.control.PreloadController;
	import net.guttershark.managers.AssetManager;
	import net.guttershark.managers.EventManager;
	import net.guttershark.model.Model;
	import net.guttershark.support.preloading.events.AssetCompleteEvent;
	import net.guttershark.support.preloading.events.PreloadProgressEvent;		

	public class Main extends DocumentController 
	{

		public var preloader:MovieClip;

		public function Main()
		{
			super();
		}

		override protected function flashvarsForStandalone():Object
		{
			return {model:"model.xml"};
		}

		override protected function setupComplete():void
		{
			pc = new PreloadController(400);
			pc.addItems(ml.getAssetsForPreload());
			em.handleEvents(pc, this, "onPC");
			pc.start(); //start it; for demo
			//preloadController.stop(); //pause it; for demo
			//setTimeout(preloadController.start,4000); //resume it; for demo
		}
		
		public function onPCComplete():void
		{
			em.disposeEventsForObject(pc);
			addChild(am.getMovieClipFromSWFLibrary("swftest", "Test"));
			addChild(am.getBitmap("jpg1"));
		}
		
		public function onPCProgress(pe:PreloadProgressEvent):void
		{
			trace(pe.toString());
			TweenMax.to(preloader,.5,{width:pe.pixels,overwrite:false});
		}

		public function onPCAssetComplete(ace:AssetCompleteEvent):void
		{
			trace("ASSET COMPLETE: " + ace.asset.libraryName + " " + ace.asset.source);
		}
	}
}
