package 
{
	import flash.display.MovieClip;	
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import net.guttershark.control.DocumentController;
	import net.guttershark.lang.LocalizableClip;	
	
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
			languageManager.loadLanguage("./english.xml","en");
			languageManager.loadLanguage("./french.xml","fr");
			languageManager.languageCode = "fr";
			languageManager.addLocalizableClip(helloWorldExample);
			languageManager.addLocalizableClip(test.bye);
			setTimeout(languageManager.updateAll, 1000);
			setTimeout(backToEn,3000);
		}
		
		private function backToEn():void
		{
			languageManager.languageCode = "en";
			languageManager.updateAll();
		}	}}