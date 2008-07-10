package net.guttershark.managers
{

	import flash.system.Capabilities;

	/**
	 * The PlayerManager class provides static shortcut methods for finding
	 * things about the currently running player.
	 */
	public class PlayerManager
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