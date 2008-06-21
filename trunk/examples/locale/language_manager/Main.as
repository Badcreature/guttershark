package 
{
	
	import flash.net.URLRequest;
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.lang.LocalizableClip;
	import net.guttershark.managers.LanguageManager;
	
	public class Main extends DocumentController
	{
		
		public var helloWorldExample:LocalizableClip;
		public var bye:LocalizableClip;
		public var test:MovieClip;

		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			LanguageManager.gi().loadLanguage(new URLRequest("./english.xml"),"en");
			LanguageManager.gi().loadLanguage(new URLRequest("./french.xml"),"fr");
			LanguageManager.gi().languageCode = "fr";
			LanguageManager.gi().addLocalizableClip(helloWorldExample);
			LanguageManager.gi().addLocalizableClip(test.bye);
			setTimeout(LanguageManager.gi().updateAll, 1000);
			setTimeout(backToEn,3000);
		}
		
		private function backToEn():void
		{
			LanguageManager.gi().languageCode = "en";
			LanguageManager.gi().updateAll();
		}	}}