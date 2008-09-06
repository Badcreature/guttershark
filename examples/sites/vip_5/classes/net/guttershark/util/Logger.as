package net.guttershark.util
{
	
	/**
	 * The Logger class is a utility class for logging output, and filtering log messages.
	 * 
	 * @example Simple logging setup:
	 * <listing>	
	 * Logger.Level = Logger.DEBUG;
	 * Logger.info("This is my message");
	 * </listing>	
	 * 
	 * <p>The above example is the most basic example. You can also add in "filters" to 
	 * filter out traces. The second parameter to any method on the Logger class 
	 * can be any filter you want.</p>
	 * 
	 * @example Setup with filters in place:
	 * <listing>	
	 * Logger.Level = Logger.DEBUG; //wide open
	 * Logger.Filters = ["Preloading","Startup"];
	 * Logger.info("This is my message","Preloading");
	 * Logger.warn("This is my message2","Startup");
	 * Logger.warn("This is my message2","Startup","Preloading");
	 * Logger.debug("This is my message3","OtherFilter");
	 * </listing>
	 * 
	 * <p>In this example there are two filters on the logger (Startup, Preloading).
	 * Any filter message that comes through the logger that matches on of the allowable
	 * filters will get traced. Others will be suppressed. So the "This is my message3" 
	 * will not  be shown because it's not an allowable filter.</p>
	 */
	public class Logger
	{
		
		/**
		 * Shortcut for the DEBUG level.
		 * Logger.Level = Logger.DEBUG;
		 */
		public static var DEBUG:int = 0;
		
		/**
		 * Shortcut for INFO level.
		 * Logger.Level = Logger.INFO
		 */
		public static var INFO:int = 1;
		
		/**
		 * Shortcut for WARN level.
		 * Logger.Level = Logger.WARN;
		 */
		public static var WARN:int = 2;
		
		/**
		 * Shortcut for ERROR level.
		 * Logger.Level = Logger.ERROR
		 */
		public static var ERROR:int = 3;
		
		/**
		 * Shortcut for FATAL level.
		 * Logger.Level = Logger.FATAL
		 */
		public static var FATAL:int = 4;
		
		/**
		 * Shortcut for NONE level.
		 * Logger.Level = Logger.NONE
		 */
		public static var NONE:int = 5;
		
		/**
		 * Show timestamps in the log messages.
		 */
		public static var ShowTimestamp:Boolean = false;
		
		/**
		 * Filters that are set on this logger.
		 */
		public static var Filters:Array = [];
		
		/**
		 * The current log level.
		 */
		public static var Level:int  = Logger.DEBUG;
		
		/**
		 * Log a DEBUG level message
		 */
		public static function debug(obj:Object, ...channels):void
		{
			if(checkLevels(Logger.DEBUG,channels))
			{
				logIt("DEBUG",channels,obj);
			}
		}
		
		/**
		 * Log an INFO level message
		 */
		public static function info(obj:Object, ...channels):void
		{
			if(checkLevels(Logger.INFO,channels))
			{
				logIt("INFO",channels,obj);
			}
		}
		
		/**
		 * Log an WARN level message
		 */
		public static function warn(obj:Object, ...channels):void
		{
			if(checkLevels(Logger.WARN,channels))
			{
				logIt("WARN",channels,obj);
			}
		}
		
		/**
		 * Log an ERROR level message.
		 */
		public static function error(obj:*, ...channels):void
		{
			if(checkLevels(Logger.ERROR,channels))
			{
				logIt("ERROR",channels,obj);
			}
		}
		
		/**
		 * Log a FATAL level message
		 */
		public static function fatal(obj:Object, ...channels):void
		{
			if(checkLevels(Logger.FATAL,channels))
			{
				logIt("FATAL",channels,obj);
			}
		}
		
		/**
		 * Private method to consolidate logic into one place.
		 */
		private static function logIt(level:String, channels:*, obj:Object):void
		{
			try
			{
				if(channels is Array)
					if(ShowTimestamp)
						trace(new Date().toUTCString(), level + " : (" + channels.join(",") + ") : " + obj.toString());
					else
						trace(level + " : (" + channels.join(",") + ") : " + obj.toString());
			}
			catch(e:*){}
		}
		
		/**
		 * Checks the internal state of the logger to pass or allow message traces.
		 */
		private static function checkLevels(level:int,channels:* = null):Boolean
		{
			if(Logger.Level <= level)
			{
				if(Logger.Filters[0] != null)
				{
					if(channels == null || channels[0] == null)
						return false;
					else if(channels is Array)
					{
						var len:int = channels.length;
						for(var i:int = 0; i < len; i++)
						{
							if(Logger.Filters.indexOf(channels[i]) > -1)
							{
								return true;
							}
						}
					}
				}
				else
				{
					return true;
				}
			}
			return false;
		}
	}
}