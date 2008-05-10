package
{
	import flash.events.Event;	
	import flash.utils.Dictionary;

	import net.guttershark.preloading.Asset;	
	import net.guttershark.preloading.PreloadController;	
	import net.guttershark.control.DocumentController;
	import net.guttershark.lang.LocalizableClip;
	
	public class Main extends DocumentController 
	{
		
		private var preloadController:PreloadController;
		public var helloWorldExample:LocalizableClip;

		public function Main():void
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			preloadController = new PreloadController();
			var assets:Array = [
				new Asset("assets/english.xml","english"),
				new Asset("assets/french.xml","french")
			];
			preloadController.addItems(assets);
			preloadController.addEventListener(Event.COMPLETE, onComplete);
			preloadController.start();
		}
		
		private function onComplete(e:Event):void
		{
			var english:XML = preloadController.library.getXML("english");
			var french:XML = preloadController.library.getXML("french");
			languageManager.addLanguageXML(english,"en");
			languageManager.addLanguageXML(french,"fr");
			languageManager.addLocalizableClip(helloWorldExample);
			languageManager.languageCode = "fr";
		}
	}}