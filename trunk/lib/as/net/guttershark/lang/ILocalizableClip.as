package net.guttershark.lang 
{

	/**
	 * The ILocalizableClip interface creates the contract for objects that are implementing
	 * localization with the LanguageManager.
	 */
	public interface ILocalizableClip
	{
		/**
		 * Set the text for this localized clip.
		 */
		function set localizedText(value:String):void;
		
		/**
		 * Get the localized text fields text value.
		 */
		function get localizedText():String;

		/**
		 * Get the localizedID of this clip. This id needs
		 * to correlate directly to a node in a language XML
		 * file.
		 */
		function get localizedID():String;
	}
}