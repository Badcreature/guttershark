package net.guttershark.util
{
	
	import flash.utils.Dictionary;	
	import flash.external.*;
	import flash.system.Capabilities;

	/**
	 * The QueryString class is used for reading query string parameters
	 * in the web browsers address bar. This class will only work when flash
	 * is embedded in a browser.
	 * 
	 * <p>Query string parameters are cached internally after one read. You
	 * can force a re-read of parameters if needed.</p>
	 * 
	 * @example Using the QueryString class:
	 * <listing>	
	 * if(QueryString.HasParams())
	 * {
	 *   trace(QueryString.ReadParams()['myParameter']); //myParameter is a parameter from querystring.
	 * }
	 * </listing>
	 */
	public class QueryString 
	{
		
		private static var paramsCache:Dictionary;
		private static var hasp:Boolean;
		private static var read:Object;
		
		/**
		 * Test to see if there are query string parameters present.
		 */
		public static function HasParams():Boolean
		{
			if(read) return hasp;
			var _queryString:String;
			
			if(Capabilities.playerType == "Standalone" || Capabilities.playerType == "External") return false;
			
			_queryString = ExternalInterface.call("window.location.search.substring", 1);
			if(_queryString)
			{
				QueryString.ReadParams();
				hasp = true;
			}
			return hasp;
		}
		
		/**
		 * Read all parameters. Returns an associative array with each parameters.
		 * After you've called this once, the parameters are cached so further 
		 * reading doesn't actually make the ExternalInterface call.
		 * 
		 * <p>This method will return <code>null</code> if you are running the flash file as a
		 * standalone, or in the Flash IDE.
		 * 
		 * @param	forceReread		Whether or not to force an internal params cache update.
		 * @return	Dictionary	A dictionary of key/val pairs.
		 */
		public static function ReadParams(forceReread:Boolean = false):Dictionary
		{
			if(read && !forceReread) return paramsCache;
			var _params:Dictionary = new Dictionary(true);
			var _queryString:String;
			
			if(Capabilities.playerType == "Standalone" || Capabilities.playerType == "External") return null;
				
			_queryString = ExternalInterface.call("window.location.search.substring", 1);
			if(_queryString)
			{
				var params:Array = _queryString.split('&');
				var length:uint = params.length;
				for(var i:uint = 0, index:int = -1; i < length; i++)
				{
					var kvPair:String = params[i];
					if((index = kvPair.indexOf("=")) > 0)
					{
						var key:String = kvPair.substring(0,index);
						var value:String = kvPair.substring(index+1);
						_params[key] = value;
					}
				}
			}			
			paramsCache = _params;
			return _params;
		}
	}
}