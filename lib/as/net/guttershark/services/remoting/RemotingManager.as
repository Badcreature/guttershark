package net.guttershark.services.remoting 
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import net.guttershark.services.remoting.events.CallEvent;
	import net.guttershark.services.remoting.events.ConnectionEvent;
	import net.guttershark.services.remoting.events.IRemotingEventsDelegate;
	import net.guttershark.util.Assert;
	import net.guttershark.util.Singleton;
	import net.guttershark.util.cache.Cache;
	import net.guttershark.util.events.EventDispatcherProxy;	

	/**
	 * 
	 * The RemotingManager class simplifies creating and working with RemotingConnection
	 * and RemotingService classes. As well as making remoting calls on services.
	 * 
	 * <p>Consider these classes for all the following examples</p>
	 * <listing>	
	 * package
	 * {
	 *     //the Endpoints class is an enumeration of your gateways.
	 *     
	 *     public class Endpoints
	 *     {
	 *         public static const AMFPHP:String = "http://localhost/amfphp/gateway.php"
	 *     }
	 * }
	 * 
	 * package
	 * {
	 *     //the Services class is an enumeration of your services.
	 *     
	 *     public class Services
	 *     {
	 *         public static const USERS:String = "com.myservice.Users";
	 *         public static const EMPLOYEES:String = "com.myservice.Employees";
	 *     }
	 * }
	 * 
	 * package
	 * {
	 *     //the ServiceIDS class is used for uniqe ids for a service, this is in place
	 *     //because you could have two services, with the same class package or name,
	 *     //which cannot be used as a unique identifier, so this provides those
	 *     //unique identifiers needed.
	 * 
	 *     public class ServiceIDS
	 *     {
	 *         public static const AMFPHP_USERS:String = "amfphp_users";
	 *         public static const AMFPHP_EMPLOYEES:String = "amfphp_employees";
	 *     }
	 * }
	 * 
	 * package
	 * {
	 *     //the UsersMethods class is an enumeration of methods on the USERS service.
	 *     
	 *     public class UsersMethods
	 *     {
	 *         public static const CREATE_USER:String = "createUser";
	 *     }
	 * }
	 * 
	 * package
	 * {
	 *     //the EmployeesMethods are methods defined on the remote EMPLOYEE service.
	 *     
	 *     public class EmployeesMethods
	 *     {
	 *         public static const PARTY:String = "party";
	 *     }
	 * }
	 * </listing>
	 * 
	 * <p>To work with a remoting manager - first create the services, then setup listeners,
	 * then make service calls.</p>
	 * 
	 * @example Creating services:
	 * <listing>	
	 * var myRemotingManager = new RemotingManager();
	 * myRemotingManager.createService(ServiceIDS.AMFPHP_USERS,Endpoints.AMFPHP,Services.USERS);
	 * myRemotingManager.createService(ServiceIDS.AMFPHP_EMPLOYEES,Endpoints.AMFPHP,Services.EMPLOYEES);
	 * </listing>
	 * 
	 * <p>Next you need to work with events in the manager.
	 * There are two ways to work with events from the RemotingManager.</p>
	 * 
	 * <p>1. Blanket Event Delegate Handler. By setting the <code><em>remotingEventsDelegate</em></code>
	 * property, you add a "blanket events handler," meaning that any event from any
	 * RemotingConnection or RemotingService gets called on your delegate. You should subclass
	 * RemotingEventsDelegate and override methods. See net.guttershark.remoting.events.RemotingEventsDelegate.</p>
	 * 
	 * <p>2. Connection and Service specific events. By using the 
	 * <code><em>addConnectionEventListener</em></code> and <code><em>addServiceEventListener</em></code>
	 * you add an event listener to either the remoting connection or remoting
	 * service of a specific gateway and service.</p>
	 * 
	 * <p>Connection and Service event listeners cancel out the blanket event delegate option, on
	 * a per event basis.</p> 
	 * 
	 * @example Creating and Implementing a blanket event delegate handler:
	 * <listing>	
	 * package
	 * {
	 * 
	 *    //extend RemotingEventsDelegate and override methods.
	 *    public class MyRemotingEventsDelegate extends RemotingEventsDelegate
	 *    {
	 *       override public function onConnect(ce:ConnectionEvent)
	 *       {
	 *           //handle remoting connection connected.
	 *       }
	 *       
	 *       override public function onRetry(ce:CallEvent)
	 *       {
	 *           //handle retry.
	 *       }
	 *       
	 *       override public function onTimeout(ce:CallEvent)
	 *       {
	 *          //handle timeout.
	 *       }
	 *    }
	 * }
	 * 
	 * //implement the delegate on a remoting manager.
	 * myRemotingManager.remotingEventsDelegate = new MyRemotingEventsDelegate();
	 * </listing>
	 * 
	 * @example Implementing connection and service specific events through the manager.
	 * <listing>	
	 * 
	 * //implement a disconnect event listener for the AMFPHP gateway.
	 * myRemotingManager.addConnectionEventListener(ConnectionEvent.DISCONNECT, Endpoints.AMFPHP, onDisconnect);
	 * private function onDisconnect(ce:ConnectEvent):void
	 * {
	 *     //implement on disconnect logic.
	 * }
	 * 
	 * //implement a retry event listener for a service. (Any method that is called on users and retries will trigger this event)
	 * myRemotingManager.addServiceEventListener(CallEvent.RETRY, ServiceIDS.AMFPHP_USERS, onRetry);
	 * private function onUserServiceRetry(ce:CallEvent):void
	 * {
	 *     //implement any on retry logic you need.
	 * }
	 * 
	 * //implement a retry event listener for a specific method call on a specific service. (Only the createUsers method will trigger this retry event.)
	 * myRemotingManager.addServiceEventListener(CallEvent.RETRY, ServiceIDS.AMFPHP_USERS, onCreateUserRetry, UsersMethods.CREATE_USER);
	 * private function onCreateUserRetry(ce:CallEvent):void
	 * {
	 *     //implement any retry logic for the create users method on the USERS service.
	 * }
	 * </listing>
	 * 
	 * <p>The DocumentController has a <code><em>remotingManager</em></code> property on it
	 * that is intended for an instance of this class. The SiteXMLParser will create and 
	 * intitialize a RemotingManager for you based off of XML. This is not required, but is
	 * provided for convenience, so you dont have to parse and intialize everything.</p>
	 * 
	 * @see net.guttershark.remoting.events.RemotingEventsDelegate RemotingEventsDelegate class
	 * @see net.guttershark.control.DocumentController#remotingManager remotingManager property on the DocumentController
	 * @see net.guttershark.model.SiteXMLParser SiteXMLParser class
	 */
	public class RemotingManager 
	{

		/**
		 * Singleton instance.
		 */
		private static var inst:RemotingManager;

		/**
		 * Internal event dispatcher.
		 */
		private var edp:EventDispatcherProxy;

		/**
		 * The default object encoding to use when creating RemotingConnections.
		 */
		public static var DefaultObjectEncoding:int = 3;

		/**
		 * Services.
		 */
		private var services:Dictionary;
		
		/**
		 * A remoting events delegate that all events from every RemotingConnection,
		 * and RemotingService get handled in. Consider this a blanket event
		 * handler delegate. This should be used when you need to react to
		 * events in some way, but the specific RemotingConnection or 
		 * RemotingService is neglagable.
		 */
		public var remotingEventsDelegate:IRemotingEventsDelegate;
		
		/**
		 * A dictionary of connections by gateway.
		 */
		private var connections:Dictionary;

		/**
		 * Singleton access.
		 */
		public static function gi():RemotingManager
		{
			if(!inst) inst = Singleton.gi(RemotingManager);
			return inst;
		}

		/**
		 * @private
		 * Constructor for RemotingManager instances.
		 */
		public function RemotingManager():void
		{	
			Singleton.assertSingle(RemotingManager);
			edp = new EventDispatcherProxy();
			services = new Dictionary();
			connections = new Dictionary();
		}
		
		/**
		 * Creates and initializes a remoting service.
		 * 
		 * @param	id	A unique id to register the created service as.
		 * @param	gateway	The gateway URL.
		 * @param	service	The remoting service (com.mypackage.MyService), etc.
		 * @param	callTimeout	The timeout in milliseconds before a remoting call times out, and retries.
		 * @param	maxRetries	The maximum amount of retries per remoting call.
		 * @param	useLimiter	Whether or not to use limiting for each remoting call (see net.guttershark.remoting.limiting.RemotingLimiter)
		 * @param	useCache	Whether or not to use a Cache instance for the new remoting service.
		 * @param	cacheExpireTimeout	The time in milliseconds that a Cache instance will live in memory, before expiring.
		 */
		public function createService(id:String, gateway:String, service:String, callTimeout:int = 5000, maxRetries:int = 3, useLimiter:Boolean = true, useCache:Boolean = false, cacheExpireTimeout:int = -1):void
		{
			Assert.NotNull(id, "Parameter id cannot be null");
			Assert.NotNull(gateway, "Parameter gateway cannot be null");
			Assert.NotNull(service, "Parameter service cannot be null");
			Assert.NotNull(callTimeout, "Parameter calTimeout cannot be null");
			Assert.NotNull(maxRetries, "Parameter maxRetries cannot be null");
			Assert.NotNull(useLimiter, "Parameter useLimiter cannot be null");
			Assert.NotNull(useCache, "Parameter useCache cannot be null");
			Assert.NotNull(cacheExpireTimeout, "Parameter cacheExpireTimeout cannot be null");
			var connection:RemotingConnection;
			if(connections[gateway]) connection = connections[gateway];
			else
			{
				connection = new RemotingConnection(gateway, RemotingManager.DefaultObjectEncoding);
				connection.addEventListener(ConnectionEvent.CONNECTED, onConnected);
				connection.addEventListener(ConnectionEvent.DISCONNECT, onDisconnect);
				connection.addEventListener(ConnectionEvent.FAILED, onFail);
				connection.addEventListener(ConnectionEvent.FORMAT_ERROR, onFormatError);
				connection.addEventListener(ConnectionEvent.SECURITY_ERROR, onSecurityError);
				connections[gateway] = connection;
			}
			var sv:RemotingService = new RemotingService(connection,service,callTimeout,maxRetries,useLimiter);
			sv.addEventListener(CallEvent.LIMITER_STOPPED_CALL, onLimited);
			sv.addEventListener(CallEvent.REQUEST_SENT, onRequestSent);
			sv.addEventListener(CallEvent.RETRY, onRetry);
			sv.addEventListener(CallEvent.SERVICE_HALTED, onServicesHalted);
			sv.addEventListener(CallEvent.TIMEOUT, onTimeout);
			if(useCache) sv.remotingCache = new Cache(cacheExpireTimeout);
			services[id] = sv;
		}
		
		/**
		 * Returns a handle on a RemotingService. Generally you don't need this, but
		 * it's available just in case.
		 * @param	id	The unique id used when creating the service.
		 */
		public function getService(id:String):RemotingService
		{
			Assert.NotNull(id, "Parameter id cannot be null");
			Assert.NotNull(services[id], "Service " + id + "not available");
			return services[id];
		}
		
		/**
		 * Make a remoting call.
		 * @param	id	The unique id used when creating the service.
		 * @param	serviceMethod	The service method to call.
		 * @param	args	The arguments to send to the service.
		 * @param	onResultCallback	The callback to execute on result.
		 * @param	onFaultCallback	The callback to execute on fault.
		 */
		public function call(id:String, serviceMethod:String, args:Array, onResultCallback:Function, onFaultCallback:Function, returnArgs:Boolean = false):void
		{
			var rs:RemotingService = services[id];
			rs.apply(serviceMethod,args,onResultCallback,onFaultCallback,returnArgs);
		}
		
		/**
		 * Dispose of a RemotingService.
		 * @param	id	The service id.
		 */
		public function disposeService(id:String):void
		{
			if(!id) return;
			try
			{
				RemotingService(services[id]).remotingConnection.dispose();
			}catch(e:Error){}
			services[id] = null;
		}
		
		/**
		 * Add an event listener for a specific gateway connection.
		 * @param	type	The ConnectionEvent type.
		 * @param	gateway	The Gateway URL.
		 * @param	handler	The event handler function.
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReferences
		 */
		public function addConnectionEventListener(type:String, gateway:String, handler:Function, useCapture:Boolean = false, priority:int = 0, useWeakReferences:Boolean = false):void
		{
			var t:String = type + gateway;
			edp.addEventListener(t,handler,useCapture,priority,useWeakReferences);
		}
		
		/**
		 * Add an event listener for a specific service.
		 * @param	type	The CallEvent type to listen for.
		 * @param	id	The unique id used when creating the service.
		 * @param	handler	The event handler function.
		 * @param	serviceMethod	The method that dispatched the event.
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReferences
		 */
		public function addServiceEventListener(type:String, id:String, handler:Function, serviceMethod:String = null, useCapture:Boolean = false, priority:int = 0, useWeakReferences:Boolean = false):void
		{
			var rs:RemotingService = RemotingService(services[id]);
			var t:String = type + rs.remotingConnection.gateway + rs.service;
			if(serviceMethod) t += serviceMethod;
			edp.addEventListener(t,handler,useCapture,priority,useWeakReferences);
		}
		
		/**
		 * Remove a connection event listener.
		 * @param	type	The ConnectionEvent type
		 * @param	gateway	The Gateway URL.
		 * @param	handler	The event handler function.
		 */
		public function removeConnectionEventListener(type:String, gateway:String, handler:Function):void
		{
			edp.removeEventListener(type + gateway, handler);
		}
		
		/**
		 * Remove a service event listener.
		 * @param	type	The CallEvent type
		 * @param	id	The unique id used when creating the service.
		 * @param	handler	The event handler function.
		 * @param	serviceMethod	The service method. This parameter turns on service method specific event firing.
		 */
		public function removeServiceEventListener(type:String, id:String, handler:Function, serviceMethod:String = null):void
		{
			var rs:RemotingService = RemotingService(services[id]);
			var t:String = type + rs.remotingConnection.gateway + rs.service;
			if(serviceMethod) t += serviceMethod;
			edp.removeEventListener(t, handler);
		}
		
		/**
		 * Dispose of this remoting manager.
		 */
		public function dispose():void
		{
			services = new Dictionary();
			connections = new Dictionary();
			edp = null;
		}

		/**
		 * Get the extended type of an event from the original event.
		 */
		private function getExtendedTypeFromCallEvent(ce:CallEvent):String
		{
			var rs:RemotingService = ce.service;
			var type:String = ce.type + rs.remotingConnection.gateway + rs.service;
			if(ce.method)
			{
				var typeAndMethod:String = type + ce.method;
				if(edp.hasEventListener(typeAndMethod)) type += ce.method;
			}
			return type;
		}
		
		/**
		 * Create an extended call event.
		 */
		private function createExtendedCallEvent(ce:CallEvent):CallEvent
		{
			var type:String = getExtendedTypeFromCallEvent(ce);
			var cev:CallEvent = new CallEvent(type,false,false);
			cev.args = ce.args;
			cev.connection = ce.connection;
			cev.faultCallback = ce.faultCallback;
			cev.resultCallback = ce.resultCallback;
			cev.method = ce.method;
			cev.rawData = ce.rawData;
			cev.service = ce.service;
			return cev;
		}
		
		/**
		 * Get the extended type from a connection event.
		 */
		private function getExtendedTypeFromConnectionEvent(ce:ConnectionEvent):String
		{
			var rc:RemotingConnection = ce.target as RemotingConnection;
			var type:String = ce.type + rc.gateway;
			return type;
		}
		
		/**
		 * Create an extended connection event.
		 */
		private function createdExtendedConnectionEvent(ce:ConnectionEvent):ConnectionEvent
		{
			var type:String = getExtendedTypeFromConnectionEvent(ce);
			var cev:ConnectionEvent = new ConnectionEvent(type,false,false);
			cev.message = ce.message;
			return cev;
		}
		
		/**
		 * On a RemotingConnection connect event.
		 */
		private function onConnected(ce:ConnectionEvent):void
		{
			var extype:String = getExtendedTypeFromConnectionEvent(ce);
			if(edp.hasEventListener(extype)) edp.dispatchEvent(createdExtendedConnectionEvent(ce));
			else if(remotingEventsDelegate) remotingEventsDelegate.onConnect(ce);
		}
		
		/**
		 * On a RemotingConnection disconnect event.
		 */
		private function onDisconnect(ce:ConnectionEvent):void
		{
			var extype:String = getExtendedTypeFromConnectionEvent(ce);
			if(edp.hasEventListener(extype)) edp.dispatchEvent(createdExtendedConnectionEvent(ce));
			else if(remotingEventsDelegate) remotingEventsDelegate.onConnect(ce);
		}
		
		/**
		 * On a RemotingConnection fail event.
		 */
		private function onFail(ce:ConnectionEvent):void
		{
			var extype:String = getExtendedTypeFromConnectionEvent(ce);
			if(edp.hasEventListener(extype)) edp.dispatchEvent(createdExtendedConnectionEvent(ce));
			else if(remotingEventsDelegate) remotingEventsDelegate.onConnectionFail(ce);
		}
		
		/**
		 * On a RemotingConnection fail event.
		 */
		private function onFormatError(ce:ConnectionEvent):void
		{
			var extype:String = getExtendedTypeFromConnectionEvent(ce);
			if(edp.hasEventListener(extype)) edp.dispatchEvent(createdExtendedConnectionEvent(ce));
			else if(remotingEventsDelegate) remotingEventsDelegate.onConnectionFormatError(ce);
		}
		
		/**
		 * On a RemotingConnection security error.
		 */
		private function onSecurityError(ce:ConnectionEvent):void
		{
			var extype:String = getExtendedTypeFromConnectionEvent(ce);
			if(edp.hasEventListener(extype)) edp.dispatchEvent(createdExtendedConnectionEvent(ce));
			else if(remotingEventsDelegate) remotingEventsDelegate.onConnectionSecurityError(ce);
		}
		
		/**
		 * On a RemotingService limited event.
		 */
		private function onLimited(ce:CallEvent):void
		{
			var extype:String = getExtendedTypeFromCallEvent(ce);
			if(edp.hasEventListener(extype)) edp.dispatchEvent(createExtendedCallEvent(ce));
			else if(remotingEventsDelegate) remotingEventsDelegate.onCallLimited(ce);
		}
		
		/**
		 * On a RemotingService request sent event.
		 */
		private function onRequestSent(ce:CallEvent):void
		{
			var extype:String = getExtendedTypeFromCallEvent(ce);
			if(edp.hasEventListener(extype)) edp.dispatchEvent(createExtendedCallEvent(ce));
			else if(remotingEventsDelegate) remotingEventsDelegate.onRequestSent(ce);
		}
		
		/**
		 * On a RemotingService retry event.
		 */
		private function onRetry(ce:CallEvent):void
		{
			var extype:String = getExtendedTypeFromCallEvent(ce);
			if(edp.hasEventListener(extype)) edp.dispatchEvent(createExtendedCallEvent(ce));
			else if(remotingEventsDelegate) remotingEventsDelegate.onRetry(ce);
		}
		
		/**
		 * On a RemotingService halted event.
		 */
		private function onServicesHalted(ce:CallEvent):void
		{
			var extype:String = getExtendedTypeFromCallEvent(ce);
			if(edp.hasEventListener(extype)) edp.dispatchEvent(createExtendedCallEvent(ce));
			else if(remotingEventsDelegate) remotingEventsDelegate.onServicesHalted();
		}
		
		/**
		 * On a RemotingService timeout event.
		 */
		private function onTimeout(ce:CallEvent):void
		{
			var extype:String = getExtendedTypeFromCallEvent(ce);
			if(edp.hasEventListener(extype)) edp.dispatchEvent(createExtendedCallEvent(ce));
			else if(remotingEventsDelegate) remotingEventsDelegate.onTimeout(ce);
		}
	}}