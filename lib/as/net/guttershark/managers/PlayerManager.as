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
		 * Standalone player.
		 */
		public static const STANDALONE:String = "StandAlone";
		
		/**
		 * External player. (Flash IDE)
		 */
		public static const EXTERNAL:String = "External";
		
		/**
		 * Active X player.
		 */
		public static const ACTIVEX:String = "ActiveX";
		
		/**
		 * Regular Plugin.
		 */
		public static const PLUGIN:String = "PlugIn";
		
		/**
		 * The operating system type for windows.
		 */
		public static const WINDOWS:String = "windows";
		
		/**
		 * The operating system type for linux.
		 */
		public static const LINUX:String = "linux";
		
		/**
		 * The operating system type for mac.
		 */
		public static const MAC:String = "mac";
		
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
			return (v.indexOf("win") > -1);
		}

		/**
		 * is client a Mac?
		 * @return Boolean
		 */
		public static function isMac():Boolean
		{
			var v : String = String( Capabilities.version ).toLowerCase( );
			return (v.indexOf( "mac" ) > -1);
		}	
		
		/**
		 * is client a PC?
		 * @return Boolean
		 */
		public static function isLinux():Boolean
		{
			var v:String = String(Capabilities.version).toLowerCase();
			return (v.indexOf("linux") > -1);
		}
		
		/**
		 * The the player type string.
		 * @return	String	The player type string returned from Capabilities.playerType.
		 */
		public static function PlayerType():String
		{
			return Capabilities.playerType;
		}
		
		/**
		 * If the flash player is the external player.
		 */
		public static function IsIDEPlayer():Boolean
		{
			if(Capabilities.playerType == EXTERNAL) return true;
			return false;
		}
		
		/**
		 * When run as a standlone (projector, or flex builder)
		 */
		public static function IsStandAlonePlayer():Boolean
		{
			if(Capabilities.playerType == STANDALONE) return true;
			return false;
		}
		
		/**
		 * IF the player is the active x player.
		 */ 
		public static function IsActiveX():Boolean
		{
			if(Capabilities.playerType == ACTIVEX)return true;
			return false;
		}
		
		/**
		 * If the player is just a regular plugin.
		 */
		public static function IsPlugIn():Boolean
		{
			if(Capabilities.playerType == PLUGIN)return true;
			return false;
		}
		
		/**
		 * Get the version of the flash player.
		 */
		public static function VersionOfPlayer():String
		{
			return Capabilities.version;
		}
		
		/**
		 * Returns <code>true</code> if the client flashplayer supports fullscreen mode (>=9.0.28).
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
		 * Returns <code>true</code> is the swf is being viewed in the debug player.
		 */
		public static function isDebugger():Boolean
		{
			return Capabilities.isDebugger;
		}
		
		/**
		 * Returns <code>true</code> if client flashplayer is >= the min version.
		 */
		public static function isMinVersion(minVersion : Number) : Boolean
		{
			if(Number(Capabilities.version.split(" ")[1].split(",")[0]) >= minVersion) return true;
			return false;
		}
		
		/**
		 * Get the operating system the player is running in.
		 * @return	String	A string representation of the OS.
		 * 
		 * @see net.guttershark.managers.PlayerManager.WINDOWS
		 * @see net.guttershark.managers.PlayerManager.MAC
		 * @see net.guttershark.managers.PlayerManager.LINUX
		 */
		public static function OperatingSystem():String
		{
			var os:String = Capabilities.os;
			var ret:String;
			if(os.toLowerCase().indexOf("win")) ret = PlayerManager.WINDOWS;
			else if(os.toLowerCase().indexOf("mac")) ret = PlayerManager.MAC;
			else if(os.toLowerCase().indexOf("linux")) ret = PlayerManager.LINUX;
			return ret;
		}
	}
}