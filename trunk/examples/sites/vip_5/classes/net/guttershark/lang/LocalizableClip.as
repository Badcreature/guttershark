package net.guttershark.lang
{
	
	import flash.text.TextField;	
	import flash.display.MovieClip;	
	
	/**
	 * The LocalizableClip is a super implementation of the
	 * ILocalizableClip interface. This is in place to make you
	 * conform to putting a textfield on the stage with an
	 * instance name of "tfield."
	 */
	public class LocalizableClip extends MovieClip implements ILocalizableClip
	{

		/**
		 * The instance of the text field we're using for localized content.
		 * This is set as a public var because flash requires it to be public.
		 */
		public var tfield:TextField;
		
		private var textID:String;
		
		/**
		 * Constructor for LocalizableClip instances.
		 */
		public function LocalizableClip()
		{
			super();
			if(!this.tfield) throw new Error("The movie clip, {" + this.name + "} must have an instance of a Textfield on the stage called 'tfield'.");
		}
		
		/**
		 * Set the localized text on this clip.
		 */
		public function set localizedText(value:String):void
		{
			tfield.htmlText = value;
		}
		
		/**
		 * Read the text on the internal text field.
		 */
		public function get localizedText():String
		{
			return tfield.htmlText;
		}
		
		/**
		 * Return's the instance name of this localized clip, which correlates
		 * to a text node in a language xml file.
		 */
		public function get localizedID():String
		{
			return textID;
		}
		
		/**
		 * Sets the instance name of this localized clip, which correlates
		 * to a text node in a language xml file.
		 */
		public function set localizedID(value:String):void
		{
			textID = value;
		}
	}
}
