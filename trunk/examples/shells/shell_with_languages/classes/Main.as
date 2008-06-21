package
{

	import flash.events.Event;
	
	import net.guttershark.model.SiteXMLParser;	
	import net.guttershark.preloading.PreloadController;	
	import net.guttershark.control.DocumentController;
	import net.guttershark.lang.LocalizableClip;
	import net.guttershark.managers.LanguageManager;
	
	public class Main extends DocumentController 
	{
		
		private var preloadController:PreloadController;
		public var helloWorldExample:LocalizableClip;
		
		public function Main():void
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {siteXML:"site.xml"};
		}
		
		override protected function setupComplete():void
		{
			preloadController = new PreloadController();
			var siteXMLParser:SiteXMLParser = new SiteXMLParser(siteXML);
			preloadController.addItems(siteXMLParser.getAssetsForPreload());
			preloadController.addEventListener(Event.COMPLETE, onComplete);
			preloadController.start();
		}
		
		private function onComplete(e:Event):void
		{
			var english:XML = preloadController.library.getXML("english");
			var french:XML = preloadController.library.getXML("french");
			LanguageManager.gi().addLanguageXML(english,"en");
			LanguageManager.gi().addLanguageXML(french,"fr");
			LanguageManager.gi().addLocalizableClip(helloWorldExample);
			LanguageManager.gi().languageCode = "fr";
		}
	}}