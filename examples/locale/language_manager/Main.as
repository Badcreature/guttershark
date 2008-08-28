package 
{
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.ui.lang.LocalizableClip;
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
			LanguageManager.gi().loadLanguage("./french.xml","fr");
			LanguageManager.gi().loadLanguage("./english.xml","en");
			LanguageManager.gi().languageCode = "fr";
			
			//this line will not do anything, as the language has not loaded.
			LanguageManager.gi().addLocalizableClip(helloWorldExample,"helloWorldExample",true);
			setTimeout(t,3000); //set a timeout here to ensure that the language codes are loaded. just for demonstration purposes.
		}
		
		private function t():void
		{
			LanguageManager.gi().addLocalizableClip(helloWorldExample,"helloWorldExample",true);
			LanguageManager.gi().addLocalizableClip(test.bye,"bye");
			setTimeout(LanguageManager.gi().updateAll, 1000);
			setTimeout(backToEn,3000);	
		}
		
		private function backToEn():void
		{
			LanguageManager.gi().languageCode = "en";
			LanguageManager.gi().updateAll();
		}	}}