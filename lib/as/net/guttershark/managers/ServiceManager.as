package net.guttershark.managers 
{
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import net.guttershark.support.servicemanager.http.Service;
	import net.guttershark.util.Singleton;	

	/**
	 * The ServiceManager is an abstract HTTP service manager and
	 * supports dynamic use as to simplify calling target services.
	 * 
	 * <p>The ServiceManager should be initialized from the DocumentController
	 * using flashvars.initHTTP. That is the simplest way of initializing
	 * the http services, but you can also do it manually using <code><em>createService.</em></code><p>
	 * 
	 * @example Setting up the ServiceManager with the DocumentController:
	 * <listing>	
	 * public class Main extends DocumentController
	 * {
	 *     private var sm:ServiceManager;
	 *     override protected function flashvarsForStandalone():Object
	 *     {
	 *         return {model:"model.xml",initHTTP:["user"]};
	 *     }
	 *     
	 *     override protected function setupComplete():void
	 *     {
	 *         sm = ServiceManager.gi();
	 *         trace(sm.user);
	 *     }
	 * }
	 * </listing>
	 * 
	 * <p>The XML that would need to be defined in the model.xml file looks like this:</p>
	 * 
	 * <listing>	
	 * &lt;?xml version="1.0" encoding="utf-8"?&gt;
     * &lt;model&gt;
	 *    &lt;services&gt;
	 *        &lt;http&gt;
	 *            &lt;service id="user" url="http://tagsf/services/codeigniter/index.php" defaultResponseFormat="variables" /&gt;
	 *        &lt;/http&gt;
	 *    &lt;/services&gt;
	 * &lt;/model&gt;
	 * </listing>
	 * 
	 * <p>Any service defined, becomes a dynamic property on the ServiceManager. In the above example,
	 * because the service id is called "user", it becomes ServiceManager.gi().user.</p>
	 * 
	 * <p>The ServiceManager can also be initialize manually, by using <code><em>createService</em></code>.
	 * @example Manually initializing ServiceManager:
	 * <listing>	
	 * public class Main Extends MovieClip
	 * {
	 *     private var sm:ServiceManager;
	 *     public function Main()
	 *     {
	 *         sm = ServiceManager.gi();
	 *         sm.createService("user","http://tagsf/services/codeigniter/user/","variables");
	 *         trace(sm.user);
	 *     }
	 * }
	 * </listing>
	 * 
	 * <p><strong>The ServiceManager expects predefined results for specific formats.</strong> If your service
	 * is returning ServiceResultFormat.VARS. The format should be like this:</p>
	 * 
	 * <listing>	
	 * for successful calls: 
	 * result=my message
	 * for a fault call: 
	 * fault=my message
	 * </listing>
	 * 
	 * <p>For ServiceResultFormat.XML:</p>
	 * 
	 * <listing>	
	 * For fault calls:
	 * &lt;?xml version='1.0' ?&gt;
	 * &lt;root&gt;
	 *     &lt;fault&gt;My Message&lt;/fault&gt;
	 * &lt;/root&gt;
	 * 
	 * Any successful call just needs to be correctly formatted XML.
	 * </listing>
	 * 
	 * <p>For ServiceResultFormat.BIN, no translations happen with the results, it always comes back to your onResult callback,
	 * with the ServiceResult.data property set as a ByteArray.</p>
	 * 
	 * <p><strong>Using the ServiceManager to make HTTP service calls.</strong></p>
	 * 
	 * <p>ServiceManager supports multiple types of service calls.</p>
	 * <ul>
	 * <li>URL Encoded Query String calls. EX: http://tagsf/services/codeigniter/index.php?c=user&m=name - POST or GET</li>
	 * <li>URL Routed calls. EX: http://tagsf/services/codeigniter/index.php/user/name - GET only</li>
	 * </ul>
	 * 
	 * @example Service call examples:
	 * 
	 * <listing>	
	 * //calls: http://tagsf/services/codeigniter/index.php?c=user&m=name
	 * sm.user([],{onResult:res,onFault:fal,resultFormat:"text",data:{c:"user",m:"name"}});
	 * 
	 * //calls: http://tagsf/services/codeigniter/index.php/user/name
	 * sm.user.name([],{onResult:res,onFault:fal,resultFormat:"text",data:{}});
	 * 
	 * //calls: http://tagsf/services/codeigniter/index.php/user/save/test/whatever
	 * sm.user.save(['test','whatever'],{onResult:res,onFault:fal,resultFormat:"text",data:{}});
	 * 
	 * //calls: http://tagsf/services/codeigniter/index.php/user/save/test/whatever?w=something
	 * sm.user.save(['test','whatever'],{onResult:res,onFault:fal,resultFormat:"text",data:{w:"something"}});
	 * </listing>
	 */
	public dynamic class ServiceManager extends Proxy
	{
		
		/**
		 * Singleton var.
		 */
		private static var inst:ServiceManager;
		
		/**
		 * Stores all created services.
		 */
		private var services:Dictionary;
		
		/**
		 * @private
		 */
		public function ServiceManager()
		{
			Singleton.assertSingle(ServiceManager);
			services = new Dictionary();
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
		 * Create a new service.
		 * @param	id	The service id.
		 * @param	defaultResponseFormat	The default response data format for any calls made on the newly created service.
		 * @param	qshref	The endpoint URL to use when a querystring request is made.
		 * @param	routeurl	The endpoint URL to use when a route url request is made.
		 */
		public function createService(id:String,url:String,defaultResponseFormat:String):void
		{
			if(services[id]) return;
			//if(defaultResponseFormat != "text" && defaultResponseFormat != "binary" && defaultResponseFormat != "variables") throw new Error("DefatulDataFormat of type {" + defaultResponseFormat +"} is not supported.");
			services[id] = new Service(id,url,defaultResponseFormat);
		}
		
		/**
		 * @private
		 * 
		 * callProperty - proxy override (__resolve)
		 */
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			var s:Service;
			if(services[methodName]) s = services[methodName] as Service;
			else throw new Error("Service {"+methodName+"} not found.");
			var a:* = args[0];
			var props:* = args[1];
			props.useRoutes = false;
			s.callCustom(methodName,a,props);
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
			if(services[name]) return services[name];
			else throw new Error("Service {"+name+"} not available");
		}
	}}