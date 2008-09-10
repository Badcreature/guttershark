package 
{
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.display.lang.LocalizableClip;
	import net.guttershark.managers.LanguageManager;	

	public class Main extends DocumentController
	{
		
		private var lm:LanguageManager;
		public var helloWorldExample:LocalizableClip;
		public var bye:LocalizableClip;
		public var test:MovieClip;

		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			lm = LanguageManager.gi();
			lm.loadLanguage("./french.xml","fr");
			lm.loadLanguage("./english.xml","en");
			lm.languageCode = "fr";
			setTimeout(t,3000); //set a timeout here to ensure that the language codes are loaded. just for demonstration purposes.
		}
		
		private function t():void
		{
			lm.addLocalizableClip(helloWorldExample,"helloWorldExample",true);
			lm.addLocalizableClip(test.bye,"bye");
			setTimeout(lm.updateAll, 1000);
			setTimeout(backToEn,3000);	
		}
		
		private function backToEn():void
		{
			lm.languageCode = "en";
			lm.updateAll();
		}	}}