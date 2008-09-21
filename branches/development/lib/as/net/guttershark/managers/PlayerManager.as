package net.guttershark.managers
{
	import flash.system.System;		import flash.system.Capabilities;

	/**
	 * The PlayerManager class provides static shortcut methods for finding
	 * things about the currently running player.
	 */
	public final class PlayerManager
	{
		
		/**
		 * Retrieve the FlashPlayer Version the application is running under.
		 */
		public static const FLASHPLAYER_VERSION:String = Capabilities.version;
		
		/**
		 * Retrieve the ActionScript Virtual Machine Version the application is running under.
		 */
		public static const AVM_VERSION:String = System.vmVersion;
		
		/**
		 * Retrieve the FlashPlayers Localized Language Code.
		 * 
		 * <p>e.g. <code>cs,da,nl,en,fi,fr,de,hu,it,ja,ko,no,xu,pl,pt,ru,zh-CN,es,sv,zh-TW,tr</code></p>.
		 */
		public static const LANGUAGE:String = Capabilities.language;
		
		/**
		 * is client a PC?
		 * @return Boolean
		 */
		public static function isPC():Boolean
		{
			var v:String = String(Capabilities.version).toLowerCase();
			return (v.indexOf("win")>-1);
		}

		/**
		 * Check whether or not the current player is running on a mac.
		 */
		public static function isMac():Boolean
		{
			var v:String = String(Capabilities.version).toLowerCase();
			return (v.indexOf("mac")>-1);
		}	
		
		/**
		 * Check whether or not the current player is running on a pc.
		 */
		public static function isLinux():Boolean
		{
			var v:String = String(Capabilities.version).toLowerCase();
			return (v.indexOf("linux")>-1);
		}
		
		/**
		 * If the flash player is the external player.
		 */
		public static function isIDEPlayer():Boolean
		{
			if(Capabilities.playerType=="External") return true;
			return false;
		}
		
		/**
		 * When run as a standlone (projector, or flex builder)
		 */
		public static function isStandAlonePlayer():Boolean
		{
			if(Capabilities.playerType=="StandAlone") return true;
			return false;
		}
		
		/**
		 * IF the player is the active x player.
		 */ 
		public static function isActiveX():Boolean
		{
			if(Capabilities.playerType=="ActiveX")return true;
			return false;
		}
		
		/**
		 * If the player is just a regular plugin.
		 */
		public static function isPlugIn():Boolean
		{
			if(Capabilities.playerType=="PlugIn")return true;
			return false;
		}
		
		/**
		 * Get the version of the flash player.
		 */
		public static function versionOfPlayer():String
		{
			return Capabilities.version;
		}
		
		/**
		 * Check whether or not the current player supports fullscreen.
		 */
		public static function hasFullscreenMode():Boolean
		{
			var v:Array = Capabilities.version.split(" ")[1].split(",");
			var major:Number = Number(v[0]);
			var minor:Number = Number(v[1]);
			var sub : Number = Number(v[2]);
			if(major > 9) return true;
			else if (major < 9) return false;
			if ((minor == 0 && sub >= 28) || minor > 0) return true;
			else return false;
		}
		
		/**
		 * Is the current player the debugger.
		 */
		public static function isDebugger():Boolean
		{
			return Capabilities.isDebugger;
		}
		
		/**
		 * Whether or not the current player is >= a major version.
		 * 
		 * @param version The major version to test for (9,8,7,etc);
		 */
		public static function isMajorVersionOrBetter(version:Number):Boolean
		{
			if(Number(Capabilities.version.split(" ")[1].split(",")[0]) >= version) return true;
			return false;
		}
	}
}