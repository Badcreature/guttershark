package
{
	import net.guttershark.events.delegates.PreloadControllerEventListenerDelegate;	
	
	import flash.events.Event;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.events.EventManager;
	import net.guttershark.lang.LocalizableClip;
	import net.guttershark.managers.LanguageManager;
	import net.guttershark.model.Model;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.PreloadController;		

	public class Main extends DocumentController 
	{
		
		private var ml:Model;
		private var em:EventManager;
		private var lm:LanguageManager;
		private var pc:PreloadController;
		private var al:AssetLibrary;

		public var helloWorldExample:LocalizableClip;
		
		public function Main():void
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"site.xml"};
		}
		
		override protected function setupComplete():void
		{
			em = EventManager.gi();
			em.addEventListenerDelegate(PreloadController,PreloadControllerEventListenerDelegate);
			lm = LanguageManager.gi();
			al = AssetLibrary.gi();
			ml = Model.gi();
			pc = new PreloadController();
			pc.addItems(ml.getAssetsForPreload());
			em.handleEvents(pc, this, "onPC");
			pc.start();
		}
		
		public function onPCComplete():void
		{
			var english:XML = al.getXML("english");
			var french:XML = al.getXML("french");
			LanguageManager.gi().addLanguageXML(english,"en");
			LanguageManager.gi().addLanguageXML(french,"fr");
			LanguageManager.gi().addLocalizableClip(helloWorldExample,"helloWorldExample");
			LanguageManager.gi().languageCode = "fr";
		}
	}}