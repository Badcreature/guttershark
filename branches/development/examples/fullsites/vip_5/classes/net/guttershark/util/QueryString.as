package net.guttershark.util
{

	import flash.utils.Proxy;	
	import flash.utils.Dictionary;	
	import flash.external.*;
	import flash.system.Capabilities;
	import flash.utils.flash_proxy;
	
	import net.guttershark.core.IDisposable;
	
	/**
	 * The QueryString class is used for reading query string parameters
	 * in the web browsers address bar. This class will only work when flash
	 * is embedded in a browser.
	 * 
	 * <p>The QueryString class uses the flash_proxy namespace to override
	 * the getProperty method call. Which allows you to dynamically access any property
	 * defined in the query string without any complaint. Properties that are
	 * in the query string are read only</p>
	 * 
	 * @example Using the QueryString class when the swf is in a browser:
	 * <listing>	
	 * var qs:QueryString = new QueryString();
	 * trace(qs.myQueryStringVariable);
	 * trace(qs.section);
	 * trace(qs.videoID);
	 * </listing>
	 * 
	 * @example Using the QueryString class outside of a browser:
	 * <listing>	
	 * var qs:QueryString = new QueryString();
	 * var fakeQS:Dictionary = new Dictionary();
	 * fakeQS['videoID'] = 100;
	 * qs.querystringData = fakeQS;
	 * trace(qs.videoID);
	 * </listing>
	 * 
	 * <p>In the above example, the <code>myQueryStringVariable</code> correlates
	 * directly to a query string variable. If that variable is present in the
	 * address bar, you will get that value, if it is not present, you will
	 * receive <code>null</code>.</p>
	 */
	dynamic public class QueryString extends Proxy implements IDisposable
	{

		private var paramsCache:Dictionary;
		private var read:Object;
		
		/**
		 * Read all parameters. Returns an associative array with each parameters.
		 * Parameters are cached after 1 execution. You can force a re-read.
		 * 
		 * <p><strong>This method will return <code>null</code> if you are running the flash file as a
		 * standalone, or in the Flash IDE.</strong></p>
		 */
		private function readParams():void
		{
			var _params:Dictionary = new Dictionary(true);
			var _queryString:String;
			if(Capabilities.playerType == "Standalone" || Capabilities.playerType == "External") return;
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
		}
		
		/**
		 * Allows you to set the query string data. This is avaiable
		 * for situations when you are testing an application in the Flash IDE,
		 * but still need to rely on query string parameters. You can provide
		 * a hardcoded query string dictionary so that this class won't break
		 * your work, or cause you to have to treat logic differently just to
		 * work in the IDE.
		 */
		public function set querystringData(data:Dictionary):void
		{
			Assert.NotNull(data, "Parameter data cannot be null");
			paramsCache = data;
		}
		
		/**
		 * Read a property from deeplink data.
		 */
		flash_proxy override function getProperty(name:*):*
		{
			if(!read) readParams();
			if(paramsCache[name]) return paramsCache[name];
			else return null;
		}
		
		/**
		 * Dispose of the internally cached query string parameters.
		 */
		public function dispose():void
		{
			paramsCache = null;
			read = false;
		}
	}
}