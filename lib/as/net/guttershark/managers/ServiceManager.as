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
	 * The ServiceManager class supports making Remoting
	 * requests, and normal HTTP service requests, with
	 * support for retries, timeouts, and some features that
	 * are specific to one or the other.
	 * 
	 * @example Setting up a remoting service:
	 * <listing>	
	 * import net.guttershark.managers.ServiceManager;
	 * import net.guttershark.support.serviceamanager.shared.CallResult;
	 * import net.guttershark.support.serviceamanager.shared.CallFault;
	 * 
	 * var sm:ServiceManager = ServiceManager.gi();
	 * 
	 * //this sets up a remoting service.
	 * sm.createRemotingService("users","http://localhost/amfphp/gateway.php",3,1,3000,true);
	 * 
	 * //make a remoting call.
	 * sm.users.getAllUsers({onResult:onr,onFault:onf});
	 * function onr(cr:CallResult):void{}
	 * function onf(cf:CallFault):void{}
	 * </listing>
	 * 
	 * <p>The above example is the most basic remoting call,but there are
	 * other callbacks you can supply, as well as supply the number
	 * of attempts that will be attempted, and the time before a call
	 * is considered timed-out (to initiate a retry).</p>
	 * 
	 * <p>Supported properties on the callProps object for a <strong>remoting service call</strong>:</p>
	 * <ul>
	 * <li>params (Array) - The parameters to send to the remoting service.</li>
	 * <li>onCreate (Function) - A function to call, as soon as a remoting call instance was created (the request hasn't gone out yet though.).</li>
	 * <li>onResult (Function) - A function to call, and pass a CallResult object to.</li>
	 * <li>onFault (Function) - A function to call, and pass a CallFault object to.</li>
	 * <li>onRetry (Function) - A function to call for every retry of a service call.</li>
	 * <li>onTimeout (Function) - A function to call after every retry has been attempted, and no result or fault was returned.</li>
	 * <li>attempts (int) - The number of retry attempts allowed.</li>
	 * <li>timeout (int - milliseconds) - The amount of time allowed for each call before another attempt is made.</li>
	 * <li>returnArgs (Boolean) - Return the original <em><code>callprops.params</code></em> sent through the
	 * request as the second parameter to your onResult, or onFault callback</li>
	 * </ul>
	 * 
	 * @example An extended remoting call example, with all callProp objects filled in:
	 * <listing>	
	 * import net.guttershark.managers.ServiceManager;
	 * import net.guttershark.support.serviceamanager.shared.CallResult;
	 * import net.guttershark.support.serviceamanager.shared.CallFault;
	 * 
	 * var sm:ServiceManager = ServiceManager.gi();
	 * 
	 * //this sets up a remoting service.
	 * sm.createRemotingService("users","http://localhost/amfphp/gateway.php",3,1,3000,true);
	 * 
	 * //make a remoting call.
	 * sm.users.getUserByName({param:["sam"],onResult:onr,onFault:onf,onCreate:onc,onRetry:onrt,onTimeout:ont,attempts:2,timeout:3000,returnArgs:true});
	 * function onr(cr:CallResult,params:Array):void{} //onResult
	 * function onf(cf:CallFault,params:Array):void{} //onFault
	 * function onc():void{} //onCreate
	 * function onrt():void{} //onRetry
	 * function ont:void(){} //onTimeout
	 * </listing>
	 * 
	 * <p>A remoting service supports something called a "limiter" which means
	 * that if a request is being made to a service with X parameters, another
	 * request to that service CANNOT be made until a result,timeout,or fault
	 * occurs on the first call.</p>
	 * 
	 * <p>Now into HTTP Service calls</p>
	 * 
	 * @example Setting up an HTTP Service and make a basic call:
	 * <listing>	
	 * import net.guttershark.managers.ServiceManager;
	 * import net.guttershark.support.serviceamanager.shared.CallResult;
	 * import net.guttershark.support.serviceamanager.shared.CallFault;
	 * 
	 * var sm:ServiceManager = ServiceManager.gi();
	 * 
	 * sm.createHTTPService("codeigniter","http://localhost/codeigniter/index.php/",3,3000,false,"variables");
	 * 
	 * sm.codeigniter({routes:["user","name"],onResult:onr,onFault:onf}); // -> http://localhost/codeigniter/index.php/user/name
	 * </listing>
	 * 
	 * <p>The above example is a basic HTTP Service call. The "routes" parameter is optional,
	 * but in this case, because code igniter is being used on the server, which is route based,
	 * we can supply these routes. But this is optional, see below for all available parameters</p>
	 * 
	 * <p>Supported properties on the callProps object for a <strong>http service call</strong>:</p>
	 * <ul>
	 * <li>data (Object) - Data to submit to the service (post or get).</li>
	 * <li>routes (Array) - An array of "route" paths that get concatenated together.</li>
	 * <li>method (String) - post or get</li>
	 * <li>responseFormat (String) - The response format to expect, see net.guttershark.support.servicemanager.http.ResponseFormat.</li>
	 * <li>onCreate (Function) - A function to call, as soon as a http call instance was created (the request hasn't gone out yet though.).</li>
	 * <li>onResult (Function) - A function to call, and pass a CallResult object to.</li>
	 * <li>onFault (Function) - A function to call, and pass a CallFault object to.</li>
	 * <li>onRetry (Function) - A function to call for every retry of a service.</li>
	 * <li>onTimeout (Function) - A function to call after every retry has been attempted, and no result was returned.</li>
	 * <li>attempts (int) - The number of retry attempts allowed.</li>
	 * <li>timeout (int - milliseconds) - The amount of time allowed for each call before another attempt is made.</li>
	 * </ul>
	 * 
	 * @example Another example that submits data as a POST request to a service:
	 * <listing>	
	 * import net.guttershark.managers.ServiceManager;
	 * import net.guttershark.support.serviceamanager.shared.CallResult;
	 * import net.guttershark.support.serviceamanager.shared.CallFault;
	 * 
	 * var sm:ServiceManager = ServiceManager.gi();
	 * 
	 * sm.createHTTPService("sendEmail","http://localhost/sendEmail.php",3,5000,false);
	 * 
	 * sm.sendEmail({responseFormat:"variables",data:{toEmail:"test&#64;example.com",subject:"Example",message:"Hello World"},onResult:onr,onFault:onf});
	 * function onr(cr:CallResult):void{}
	 * function onf(cf:CallFault):void{}
	 * </listing>
	 * 
	 * <p>When you are creating a service (createHTTPService / createRemotingService) the parameters
	 * you give to the service are the "defaults", but you can override the attempts,timeout,limiter
	 * parameter by supplying it in the callProps object.</p>
	 * 
	 * <p>HTTP Service's must supply a reponse format for each call, whether it be the default
	 * that was defined when calling createHTTPService, or by overriding it in a callProp.
	 * Each call response that is received is parsed differently depending on the response format,
	 * and the result property on the CallResult object is also different.</p>
	 * 
	 * <p>HTTP Service calls support a couple extra features, if you follow the rules with the
	 * responses from the server.</p>
	 * 
	 * <p><strong>for "xml" responses</strong></p>
	 * <p>A successful xml response can be any well formed xml</p>
	 * <p>To indicate a fault, send an XML structure like this as the response:</p> 
	 * <listing>	
	 * &lt;root&gt;
	 *     &lt;fault&gt;my message&lt;/fault&gt;
	 * &lt;/root&gt;
	 * </listing>
	 * 
	 * <p><strong>for "variable" responses</strong></p>
	 * <p>The response should be a url encoded string like so: (name=asdfasd&email=asdfasd&test=sdfsdf)</p>
	 * <p>To indicate a fault through variables define it like so: (fault=my%20fault%20message).</p>
	 */
	public dynamic class ServiceManager extends Proxy
	{
		
		private static var inst:ServiceManager;
		private var services:Dictionary;
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
			if(inst == null) inst = Singleton.gi(ServiceManager);
			return inst;
		}
		
		/**
		 * Creates a new remoting service internally, that you can access as a property on the service manager instance.
		 * 
		 * @param	id	The id for the service - you can access the service dyanmically as well, like serviceManager.{id}.
		 * @param	gateway	The gateway url for the remoting server.
		 * @param	endpoint	The service endpoint, IE: com.test.Users.
		 * @param	objectEncoding	The object encoding, 0 or 3.
		 * @param	attempts	The number of attempts that will be allowed for each service call - this sets the default, but can be overwritten by a callProps object.
		 * @param	timeout	The time allowed for each call, before making another attempt.
		 * @param	limiter	Use a call limiter.
		 */
		public function createRemotingService(id:String,gateway:String,endpoint:String,objectEncoding:int,attempts:int=1,timeout:int=10000,limiter:Boolean=false,overwriteIfExists:Boolean=true):void
		{
			if(services[id] && !overwriteIfExists) return;
			var rc:RemotingConnection;
			if(rcp[gateway] && overwriteIfExists) rcp[gateway].dispose();
			if(!rcp[gateway] || overwriteIfExists) rc = rcp[gateway] = new RemotingConnection(gateway,objectEncoding); 
			else rc = rcp[gateway];
			if(services[id] && !overwriteIfExists) return;
			services[id] = new RemotingService(rc,endpoint,attempts,timeout,limiter);
		}
		
		/**
		 * Creates a new http service internally, that you can access as a property on the service manager instance.
		 * 
		 * @param	id	The id for the service - you can access the service dyanmically as well, like serviceManager.{id}.
		 * @param	url	The http url for the service.
		 * @param	attempts	The number of attempts that will be allowed for each service call - this sets the default, but can be overwritten by a callProps object.
		 * @param	timeout	The time allowed for each call, before making another attempt.
		 * @param	limiter	Use a call limiter. (currently not available for HTTP, but plans to add in, in the future.)
		 * @param	defaultResponseFormat	The default response format ("variables","xml","text","binary"), see net.guttershark.support.servicemanager.http.ResponseFormat.
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
		 * 
		 * //only intended for use when a variable decides the service it will use.
		 * var a:String = "amfphp";
		 * trace(sm.getService(a)); //return amfphp service.
		 * 
		 * //the default, recommended way
		 * trace(sm.amfphp); //returns amfphp service.
		 * </listing>
		 */
		public function getService(id:String):*
		{
			if(!services[id]) throw new Error("Service {"+id+"} does not exist.");
			return services[id];
		}
		
		/**
		 * Check whether or not a service has been created.
		 * 
		 * @param	id	The service id to check for.
		 */
		public function serviceExist(id:String):Boolean
		{
			return !(services[id]==null);
		}
		
		/**
		 * Dispose of a service.
		 *
		 * @param	id	The service id.
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