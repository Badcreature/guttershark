package net.guttershark.managers 
{
	
	import flash.net.URLRequest;	
	import flash.events.Event;	
	import flash.utils.Dictionary;

	import net.guttershark.util.XMLLoader;
	import net.guttershark.lang.ILocalizableClip;

	/**
	 * The LanguageManager manages loading different language
	 * xml files, and handling updating your text fields with
	 * different text for a different language.
	 * 
	 * <p>There is a Locale class in the default Flash API. But
	 * this class is implemented to simplify things even further.</p>
	 */
	public class LanguageManager
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:LanguageManager;
		
		/**
		 * Contains clips that have been added.
		 */
		private var clips:Dictionary;
		
		/**
		 * The languages currently loaded.
		 */
		private var languages:Dictionary; //dictionary of XMLLoader objects
		
		/**
		 * The current language code.
		 */
		private var _languageCode:String;
		
		/**
		 * Codes currently available.
		 */
		private var codes:Dictionary;
		
		/**
		 * Constructor for LanguageManager instances.
		 */
		public function LanguageManager()
		{
			clips = new Dictionary();
			languages = new Dictionary();
			codes = new Dictionary();
		}

		public static function gi():LanguageManager
		{
			if(!inst) inst = new LanguageManager();
			return inst;
		}

		/**
		 * Add an XML instance as a language XML file. This is provided
		 * specifically for when you want to include multiple language files
		 * in the document preload. So you CAN include the XML in the preload,
		 * and register it here after it's all ready, instead of loading on the fly
		 * internally, which cause delays in updates of text fields.
		 * 
		 * @param	langXML	The XML to use for this language.
		 * @param	langCode	The language code to categorize this XML as.
		 * @throws	ArgumentErro If any parameters are null;
		 */
		public function addLanguageXML(langXML:XML, langCode:String):void
		{
			if(!langXML || !langCode) throw new ArgumentError("Parameters cannot be null");
			languages[langCode] = langXML;
			codes[langCode] = true;
		}
		
		/**
		 * Load a language XML file. The loading is handled internally.
		 * 
		 * @param	langXMLPath	A path to a language xml file.
		 * @param	langCode	A language code to store this XML file as.
		 */
		public function loadLanguage(langXMLPath:String, langCode:String):void
		{
			if(!langXMLPath || !langCode) throw new ArgumentError("Parameters cannot be null");
			var x:XMLLoader = new XMLLoader();
			codes[langCode] = x;
			x.contentLoader.addEventListener(Event.COMPLETE, onLangComplete);
			x.load(new URLRequest(langXMLPath));
		}
		
		/**
		 * On complete of a language XML file.
		 */
		private function onLangComplete(e:Event):void
		{
			for(var langCode:String in codes)
			{
				if(codes[langCode] is XMLLoader && codes[langCode].data != null)
				{
					languages[langCode] = codes[langCode].data as XML;
					codes[langCode] = true;
				}
			}
		}

		/**
		 * Add a localizable clip to the language manager. The clip will be updated
		 * when the selected language code changes.
		 * 
		 * @param	clip	An ILocalizableClip.
		 * 
		 * @see net.guttershark.lang.ILocalizableClip ILocalizableClip Class
		 */
		public function addLocalizableClip(clip:ILocalizableClip):void
		{
			clips[clip] = clip;
		}
		
		/**
		 * Remove a localizable clip from the manager.
		 * 
		 * @param	clip	The ILocalizableClip to remove.
		 */
		public function removeLocalizableClip(clip:ILocalizableClip):void
		{
			if(clips[clip]) clips[clip] = null;
		}
		
		/**
		 * Update all ILocalizableClips in this manager.
		 */
		public function updateAll():void
		{
			for each(var clip:* in clips)
			{
				clip.localizedText = getTextForID(clip.localizedID);
			}
		}
		
		/**
		 * Set the language code to currently use. This triggers an update
		 * to all localizable clips that are registered.
		 * 
		 * @param	code	The language code to use.
		 */
		public function set languageCode(code:String):void
		{
			if(!codes[code]) throw new Error("Language code " + code.toString() + " is not available");
			_languageCode = code;
			updateAll();
		}
		
		/**
		 * Get the text associated with an id in the current selected language
		 * xml file. Note that it's best practice to use instance names of
		 * the ILocalizableClips.
		 */
		public function getTextForID(instanceName:String):String
		{
			if(!_languageCode) return null;
			if(!languages[_languageCode]) return null;
			if(!XML(languages[_languageCode]).text.(@id == instanceName)) throw new Error("No text for instance name: {" + instanceName + "} was found");
			return XML(languages[_languageCode]).text.(@id == instanceName).toString();
		}
	}
}
