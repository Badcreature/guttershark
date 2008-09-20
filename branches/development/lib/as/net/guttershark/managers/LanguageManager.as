package net.guttershark.managers 
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import net.guttershark.display.text.LocalizableClip;
	import net.guttershark.util.Assertions;
	import net.guttershark.util.Singleton;
	import net.guttershark.util.XMLLoader;	

	/**
	 * The LanguageManager class manages loading different language
	 * xml files, and handles updating your text fields with
	 * different text for a different language.
	 */
	final public class LanguageManager
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
		 * Assertions.
		 */
		private var ast:Assertions;

		/**
		 * @private
		 * Constructor for LanguageManager instances.
		 */
		public function LanguageManager()
		{
			Singleton.assertSingle(LanguageManager);
			ast = Assertions.gi();
			clips = new Dictionary();
			languages = new Dictionary();
			codes = new Dictionary();
		}
		
		/**
		 * Singleton Access.
		 */
		public static function gi():LanguageManager
		{
			if(!inst) inst = Singleton.gi(LanguageManager);
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
			ast.notNil(langXML,"Parameter {langXML} cannot be null");
			ast.notNil(langCode,"Parameter {langCode} cannot be null");
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
			ast.notNil(langXMLPath,"Parameter {langXMLPath} cannot be null");
			ast.notNil(langCode,"Parameter {langCode} cannot be null");
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
		 * @param	clip			An ILocalizableClip.
		 * @param	textID			String ID in language xml file.
		 * @param	updateOnAdd		Boolean to update localizedText on add.
		 * 
		 * @see net.guttershark.lang.ILocalizableClip ILocalizableClip Class
		 */
		public function addLocalizableClip(clip:LocalizableClip,textID:String,updateOnAdd:Boolean=false):void
		{
			ast.notNil(clip,"Parameter {clip} cannot be null");
			ast.notNil(textID,"Parameter {textID} cannot be null");
			clip.localizedID = textID;
			clips[textID] = clip;
			if(!languages[_languageCode] && updateOnAdd) trace("WARNING: updateOnAdd will not be applied. The language code {" + _languageCode + "} has no XML associated with it.");
			if(updateOnAdd && languages[_languageCode]) clip.localizedText = getTextForID(clip.localizedID);
		}
		
		/**
		 * Remove a localizable clip from the manager.
		 * 
		 * @param	clip	The ILocalizableClip to remove.
		 */
		public function removeLocalizableClip(clip:LocalizableClip):void
		{
			ast.notNil(clip,"Parameter {clip} cannot be null");
			if(clips[clip]) clips[clip] = null;
		}
		
		/**
		 * Update all ILocalizableClips in this manager.
		 */
		public function updateAll():void
		{
			for each(var clip:* in clips) clip.localizedText = getTextForID(clip.localizedID);
		}
		
		/**
		 * Set the language code to currently use. This triggers an update
		 * to all localizable clips that are registered.
		 * 
		 * @param	code	The language code to use.
		 */
		public function set languageCode(code:String):void
		{
			ast.notNil(code,"Parameter {code} cannot be null");
			if(!codes[code]) throw new Error("Language code " + code.toString() + " is not available");
			_languageCode = code;
			updateAll();
		}
		
		/**
		 * Get the text associated with an id in the current selected language
		 * xml file.
		 */
		public function getTextForID(textID:String):String
		{
			ast.notNil(textID,"Parameter {textID} cannot be null");
			if(!_languageCode) return null;
			if(!languages[_languageCode]) return null;
			if(!XML(languages[_languageCode]).text.(@id == textID)) throw new Error("No text for text id: {" + textID + "} was found");
			return XML(languages[_languageCode]).text.(@id == textID).toString();
		}
	}
}
