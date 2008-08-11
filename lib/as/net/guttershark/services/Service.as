package net.guttershark.services 
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * The Service Class represents a unique URL that acts as an HTTP service and is managed
	 * by the ServiceManager class. This class is generally not used directly.
	 */
	public class Service extends Proxy
	{
		
		private var id:String;
		private var href:String;
		private var method:String;
		private var defaultResultFormat:String;
		
		/**
		 * Constructor for Service instances.
		 * @param	id	The id of this service.
		 * @param	href	The endpoing URL.
		 * @param	method	The HTTP method. GET/POST.
		 * @param	defaultResultFormat	The default responses data format.
		 */
		public function Service(id:String,href:String,defaultResultFormat:String)
		{
			this.id = id;
			this.href = href;
			this.method = method;
			this.defaultResultFormat = defaultResultFormat;
		}
		
		/**
		 * Calls the service.
		 */
		private function call(service:String,args:Object,props:Object):void
		{
			var sc:ServiceCall = new ServiceCall();
			sc.execute(href,id,service,args,props,defaultResultFormat);
		}

		/**
		 * @private
		 * called from within the service manager for query string calls.
		 */
		public function callCustom(service:String,args:Object,props:Object):void
		{
			call(service,args,props);
		}

		/**
		 * toString representation.
		 */
		public function toString():String
		{
			return "[Service "+this.id+"]";
		}
		
		/**
		 * @private
		 * 
		 * callProperty - proxy override (__resolve)
		 * service.find([],onResult,onFault);
		 */
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			var a:* = args[0];
			var props:Object = args[1];
			props.useRoutes = true;
			call(methodName,a,props);
			return null;
		}

		/**
		 * @private
		 * 
		 * hasProperty - override getters to return false always
		 */
  		flash_proxy override function hasProperty(name:*):Boolean
		{
			return false;
		}
		
		/**
		 * @private
		 * 
		 * getProperty - override getters to return null always
		 */
		flash_proxy override function getProperty(name:*):* 
		{
			return null;
		}	}}