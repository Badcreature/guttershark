package net.guttershark.managers
{
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import net.guttershark.support.servicemanager.http.Service;
	import net.guttershark.support.servicemanager.remoting.RemotingConnection;
	import net.guttershark.support.servicemanager.remoting.RemotingService;
	import net.guttershark.util.Singleton;
	
	/**
	 * The ServiceManager simplifies remoting requests and http
	 * requests with support for retries, timeouts, and some features that
	 * are specific to one or the other.
	 * 
	 * @example A basic remoting request example.
	 * <listing>	
	 * import net.guttershark.managers.ServiceManager;
	 * import net.guttershark.support.serviceamanager.shared.CallResult;
	 * import net.guttershark.support.serviceamanager.shared.CallFault;
	 * 
	 * var sm:ServiceManager = ServiceManager.gi();
	 * 
	 * sm.createRemotingService("users","http://localhost/amfphp/gateway.php",3,1,3000,true);
	 * 
	 * //make a remoting call.
	 * sm.users.getAllUsers({onResult:onr,onFault:onf});
	 * function onr(cr:CallResult):void{}
	 * function onf(cf:CallFault):void{}
	 * </listing>
	 * 
	 * @example A basic http request example:
	 * <listing>	
	 * import net.guttershark.managers.ServiceManager;
	 * import net.guttershark.support.serviceamanager.shared.CallResult;
	 * import net.guttershark.support.serviceamanager.shared.CallFault;
	 * var sm:ServiceManager = ServiceManager.gi();
	 * sm.createHTTPService("codeigniter","http://localhost/codeigniter/index.php/",3,3000,false,"variables");
	 * sm.codeigniter({routes:["user","name"],onResult:onr,onFault:onf}); // -> http://localhost/codeigniter/index.php/user/name
	 * </listing>
	 * 
	 * <p>When you are creating a service (http or remoting) the parameters
	 * you give to the service are the "defaults", but you can override the
	 * attempts,timeout,limiter parameter by supplying it in the callProps
	 * object.</p>
	 * 
	 * <p><strong>See the Service and RemotingService classes for additional detailed
	 * information and examples of the types of requests you can make as well as
	 * supported call properties.</strong></p>
	 * 
	 * @see net.guttershark.support.servicemanager.http.Service Service class.
	 * @see net.guttershark.support.servicemanager.remoting.RemotingService RemotingService class.
	 */
	final public dynamic class ServiceManager extends Proxy
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:ServiceManager;
		
		/**
		 * Stored services.
		 */
		private var services:Dictionary;
		
		/**
		 * RemotingConnections that can be re-used for a service that connects
		 * to the same gateway.
		 */
		private var rcp:Dictionary;
		
		/**
		 * @private
		 */
		public function ServiceManager()
		{
			Singleton.assertSingle(ServiceManager);
			services = new Dictionary();
			rcp = new Dictionary();
		}
		
		/**
		 * Singleton access.
		 */
		public static function gi():ServiceManager
		{
			if(!inst) inst = Singleton.gi(ServiceManager);
			return inst;
		}
		
		/**
		 * Creates a new remoting service internally that you can access as a property on the service manager instance.
		 * 
		 * @param id The id for the service - you can access the service dyanmically as well, like serviceManager.{id}.
		 * @param gateway The gateway url for the remoting server.
		 * @param endpoint The service endpoint, IE: com.test.Users.
		 * @param objectEncoding The object encoding, 0 or 3.
		 * @param attempts The number of attempts that will be allowed for each service call - this sets the default, but can be overwritten by a callProps object.
		 * @param timeout The time allowed for each call, before making another attempt.
		 * @param limiter Use a call limiter.
		 * @param username A username to supply for a credentials header.
		 * @param password A password to supply for a credentals header.
		 */
		public function createRemotingService(id:String,gateway:String,endpoint:String,objectEncoding:int,attempts:int=1,timeout:int=10000,limiter:Boolean=false,overwriteIfExists:Boolean=true,username:String=null,password:String=null):void
		{
			if(services[id] && !overwriteIfExists) return;
			var rc:RemotingConnection;
			if(rcp[gateway] && overwriteIfExists) rcp[gateway].dispose();
			if(!rcp[gateway] || overwriteIfExists) rc = rcp[gateway] = new RemotingConnection(gateway,objectEncoding); 
			else rc = rcp[gateway];
			if(username && password) rc.setCredentials(username,password);
			if(services[id] && !overwriteIfExists) return;
			services[id] = new RemotingService(rc,endpoint,attempts,timeout,limiter);
		}
		
		/**
		 * Creates a new http service internally that you can access as a property on the service manager instance.
		 * 
		 * @param id The id for the service - you can access the service dyanmically as well, like serviceManager.{id}.
		 * @param url The http url for the service.
		 * @param attempts The number of attempts that will be allowed for each service call - this sets the default, but can be overwritten by a callProps object.
		 * @param timeout The time allowed for each call, before making another attempt.
		 * @param limiter Use a call limiter. (currently not available for HTTP, but plans to add in, in the future.)
		 * @param defaultResponseFormat	The default response format ("variables","xml","text","binary"), see net.guttershark.support.servicemanager.http.ResponseFormat.
		 */
		public function createHTTPService(id:String, url:String, attempts:int=1, timeout:int=10000, limiter:Boolean=false, defaultResponseFormat:String="variables"):void
		{
			if(services[id]) return;
			var s:Service = new Service(url,attempts,timeout,limiter,defaultResponseFormat);
			services[id] = s;
		}
		
		/**
		 * Get's a service from the internal dictionary of services.
		 * 
		 * <p>This is only intended to be used when you need to get a service
		 * defined by a variable, and not a hard coded property on the service manager.</p>
		 * 
		 * @example Intended use for this method:
		 * <listing>	
		 * var sm:ServiceManager = ServiceManager.gi();
		 * sm.createRemotingService("amfphp","http://localhost/amfphp/gateway.php","HelloWorld");
		 * 
		 * //only intended for use when a variable decides the service it will use.
		 * var a:String = "amfphp";
		 * trace(sm.getService(a)); //return amfphp service.
		 * 
		 * //the default, recommended way
		 * trace(sm.amfphp); //returns amfphp service.
		 * </listing>
		 * 
		 * @param id The service id.
		 */
		public function getService(id:String):*
		{
			if(!services[id]) throw new Error("Service {"+id+"} does not exist.");
			return services[id];
		}
		
		/**
		 * Check whether or not a service has been created.
		 * 
		 * @param id The service id to check for.
		 */
		public function serviceExist(id:String):Boolean
		{
			return !(services[id]==null);
		}
		
		/**
		 * Dispose of a service.
		 *
		 * @param id The service id.
		 */
		public function disposeService(id:String):void
		{
			if(!services[id]) return;
			services[id].dispose();
			services[id] = null;
		}
				
		/**
		 * @private
		 * 
		 * getProperty - override getters to return null always.
		 */
		flash_proxy override function getProperty(name:*):*
		{
			if(services[name]) return services[name];
			else throw new Error("Service {"+name+"} not available");
		}
		
		/**
		 * @private
		 */
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			if(!services[methodName]) throw new Error("Service {"+methodName+"} not found.");
			if(services[methodName] is RemotingService) throw new Error("RemotingService cannot be called this way. Please see the documentation in ServiceManager.");
			var callProps:Object = args[0];
			services[methodName].send(callProps);
		}
	}
}