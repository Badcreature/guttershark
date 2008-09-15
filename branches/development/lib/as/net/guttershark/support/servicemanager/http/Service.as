package net.guttershark.support.servicemanager.http
{
	import flash.utils.Proxy;
	
	import net.guttershark.support.servicemanager.shared.Limiter;	

	/**
	 * The Service class represents an HTTP service and is managed
	 * by the ServiceManager class - this class is generally not used directly.
	 */
	final public class Service extends Proxy
	{
		
		private var limiter:Limiter;
		private var url:String;
		private var attempts:int;
		private var timeout:int;
		private var drf:String;
		
		/**
		 * Constructor for Service instances.
		 * @param id The id of this service.
		 * @param href The endpoing URL.
		 * @param method The HTTP method. GET/POST.
		 * @param defaultResultFormat The default responses data format.
		 */
		public function Service(url:String,attempts:int=3,timeout:int=1000,limiter:Boolean=false,defaultResponseFormat:String="variables")
		{
			this.url = url;
			this.attempts = attempts;
			this.timeout = timeout;
			this.drf = defaultResponseFormat;
			if(limiter) this.limiter = new Limiter();
		}
		
		/**
		 * Sends a service call, from parameters in the callProps object.
		 * 
		 * @param callProps An Object with keys that control the service call, result handling, timeouts, etc.
		 */
		public function send(callProps:Object):void
		{
			//p.attempts
			//p.timeout
			//p.limiter
			//p.onResult
			//p.onFault
			//p.onTimeout
			//p.onLimited
			//p.method
			//p.responseFormat
			//p.route
			//p.data
			if(!callProps.attempts) callProps.attempts = attempts;
			if(!callProps.timeout) callProps.timeout = timeout;
			if(!callProps.responseFormat) callProps.responseFormat = drf;
			if(!callProps.method) callProps.method = "get";
			var sc:ServiceCall = new ServiceCall(url,callProps);
			if(callProps.onCreate) callProps.onCreate();
			sc.execute();
		}
		
		/**
		 * Dispose of this service.
		 */
		public function dispose():void
		{
			limiter = null;
			url = null;
			attempts = 0;
			timeout = 0;
			drf = null;
		}

		/**
		 * Friendly description.
		 */
		public function toString():String
		{
			return "[Service "+this.url+"]";
		}
	}
}
