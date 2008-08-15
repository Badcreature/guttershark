package net.guttershark.util 
{
	import flash.external.ExternalInterface;
	
	import net.guttershark.managers.PlayerManager;

	/**
	 * The URLS Class should be used with the guttershark.js javascript
	 * file. URL's, paths, and domains should always be seutp through
	 * javascript to allow easier deployment, without having to
	 * change xml files with paths, etc.
	 */
	public class URLS 
	{
		
		/**
		 * checks if external interface is available.
		 */	
		private static function checkEI():void
		{
			if(PlayerManager.IsIDEPlayer() || PlayerManager.IsStandAlonePlayer())
			{
				throw new Error("ExternalInterface is not available");
			}
		}
		
		/**
		 * Set the Root URL. Set's it in javascript.
		 */
		public static function setRootURL(path:String):String
		{
			checkEI();
			return ExternalInterface.call("guttershark.setRootURL",path);
		}
		
		/**
		 * Get the root URL for the site. Reads from javascript.
		 */
		public static function getRootURL():String
		{
			checkEI();
			return ExternalInterface.call("guttershark.getRootURL");
		}
		
		/**
		 * Add a path for identifier.
		 * @param	id	The id for the path, IE: assets.
		 * @param	pathFromRoot	The absolute URL from root, IE: "/assets"
		 */
		public static function addPath(id:String,pathFromRoot:String):void
		{
			checkEI();
			ExternalInterface.call("guttershark.addPath",id,pathFromRoot);
		}
		
		/**
		 * Get a path by identifer. It does not return the full URL.
		 * @param	id	The id for the path.
		 * @return	The path that was saved, IE: "/assets";
		 */
		public static function getPath(id:String):String
		{
			checkEI();
			return ExternalInterface.call("guttershark.getPath",id);
		}
		
		/**
		 * Get the full URL for a path.
		 * @param	id	The id for the path.
		 * @return	The full URL (root+path).
		 */
		public static function getFullPath(id:String):String
		{
			checkEI();
			return ExternalInterface.call("guttershark.getFullPath",id);
		}	}}