package net.guttershark.akamai 
{
	
	import flash.net.URLLoader;
	import flash.events.EventDispatcher;	
	import flash.net.URLRequest;	
	import flash.events.Event;	
	
	import net.guttershark.util.XMLLoader;
	import net.guttershark.core.IDisposable;

	/**
	 * The Ident class is used for hitting an Akamai Ident service to determine
	 * the best IP to use for an Akamai Flash Media Server. The Ident
	 * service returns back an XML file with an IP address in it.
	 * Ident service takes geographical positions into account and returns 
	 * the best IP address to use for a Flash Media Server on Akamai's network.
	 * 
	 * @see	#findBestIPForAkamaiApplication()
	 */
	public class Ident implements IDisposable
	{

		/**
		 * The IP address that was found from the Akamai Ident Service.
		 */
		public var ip:String;
		
		/**
		 * XML Loader.
		 */
		private var _contentLoader:XMLLoader;
		
		/**
		 * Constructor for Ident instances.
		 */
		public function Ident()
		{
			_contentLoader = new XMLLoader();
			_contentLoader.contentLoader.addEventListener(Event.COMPLETE,onxml,false,11,false);
		}
		
		/**
		 * Find the best IP for an Akamai Application.
		 * 
		 * @param	akamaiURI	Your akamai application URI. 
		 * 
		 * @example Using Ident:
		 * <listing>	
		 * import net.guttershark.akamai.Ident;
		 * import flash.events.Event;
		 * var i:Ident = new Ident();
		 * i.contentLoader.addEventListener(Event.COMPLETE, onc);
		 * function onc(e:Event):void
		 * {
		 *    trace(e.target.data.ip);
		 *    trace(i.ip);
		 * }
		 * i.findBestIPForAkamaiApplication("http://cp44952.edgefcs.net/");
		 * </listing>
		 * 
		 * @see net.guttershark.akamai.AkamaiNCManager
		 */
		public function findBestIPForAkamaiApplication(akamaiAppURL:String):void
		{
			//matches one of these:
			//http://cp44952.edgefcs.net/
			//http://cp44952.edgefcs.net
			//https://cp44952.edgefcs.net/
			//https://cp44952.edgefcs.net
			var reg:RegExp = new RegExp("^https?\://cp[0-9]{1,9}\.edgefcs\.net/?$","i");
			if(!akamaiAppURL) throw new Error("The Akamai host cannot be null");
			if(!akamaiAppURL.match(reg)) throw new Error("The supplied Akamai Application URL is not correctly formatted. Here is a RegExp that demonstrates how to format it: ^https?\://cp[0-9]{1,9}\.edgefcs\.net/?$");
			_contentLoader.load(new URLRequest(akamaiAppURL + "/fcs/ident/"));
		}
		
		/**
		 * on xml load.
		 */
		private function onxml(e:Event):void
		{
			_contentLoader.contentLoader.removeEventListener(Event.COMPLETE, onxml);
			this.ip = XML(e.target.data).ip.toString();
		}
		
		/**
		 * Dispose of internal objects from memory.
		 */
		public function dispose():void
		{
			_contentLoader = null;
			ip = null;
		}
		
		/**
		 * The content loader object.
		 */
		public function get contentLoader():URLLoader
		{
			return _contentLoader.contentLoader;
		}
	}
}