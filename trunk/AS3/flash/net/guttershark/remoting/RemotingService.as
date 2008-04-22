package net.guttershark.remoting
{
	
	import flash.events.*;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy; 
	
	import net.guttershark.remoting.events.*;
	import net.guttershark.remoting.limiting.RemotingCallLimiter;
	import net.guttershark.util.cache.ICacheStore;
	
	/**
	 * Dispatched when a remoting call retries.
	 */
	[Event("retry",type="net.guttershark.remoting.events.CallEvent")]
	
	/**
	 * Dispatched when a remoting call times out.
	 */
	[Event("timeout",type="net.guttershark.remoting.events.CallEvent")]
	
	/**
	 * Dispatched when a remoting request was sent.
	 */
	[Event("requestSent",type="net.guttershark.remoting.events.CallEvent")]
	
	/**
	 * Dispatched when RemotingService is halted, and no requests further will be sent.
	 * Note that this effects all instances of RemotingService, meaning that no calls from
	 * any RemotingService will be made.
	 */
	[Event("serviceHalted",type="net.guttershark.remoting.events.CallEvent")]
	
	/**
	 * The RemotingService class simplifies Flash Remoting by wraping all functionality
	 * needed for Remoting, as well as adding many features that aren't implemented by default
	 * in Flash.
	 * 
	 * <p>The RemotingService class can be used with Flash or Flex.</p>
	 * 
	 * @example Simple setup:
	 * <listing>	
	 * var rc:RemotingConnection = new RemotingConnection("http://localhost/amfphp/gateway.php",3);
	 * rc.addEventListener(ConnectionEvent.CONNECTED, MY_HANDLER);
	 * rc.addEventListener(ConnectionEvent.FAILED, MY_HANDLER);
	 * rc.addEventListener(ConnectionEvent.DISCONNECT, MY_HANDLER);
	 * rc.addEventListener(ConnectionEvent.FORMAT_ERROR, MY_HANDLER);
	 * rc.addEventListener(ConnectionEvent.SECURITY_ERROR, MY_HANDLER);
	 * 
	 * var rs:RemotingService = new RemotingService(rc,"MY_SERVICE",4000,3,true);
	 * rs.remotingCache = new Cache() //optional cache store for requests and responses.
	 * rs.addEventListener(CallEvent.TIMEOUT, MY_HANDLER);
	 * rs.addEventListener(CallEvent.RETRY, MY_HANDLER);
	 * rs.addEventListener(CallEvent.REQUEST_SENT, MY_HANDLER);
	 * rs.addEventListener(CallEvent.SERVICE_HALTED, MY_HANDLER);
	 * 
	 * //these next two calls are the same, except one you can specify a string as the method to call using apply.
	 * //rs.myServiceMethod([],onr,onf,false);
	 * rs.apply("myServiceMethod",[],onr,onf,false);
	 * 
	 * function onr(re:ResultEvent)
	 * {
	 *   var res = re.result;
	 * }
	 * function onf(fe:FaultEvent):void
	 * {
	 *   trace(fe.fault.description);
	 * }
	 * </listing>
	 * 
	 * <p>In the example above, the MY_HANDLER represents an event function
	 * callback.
	 * 
	 * @see net.guttershark.remoting.RemotingConnection
	 */
	public dynamic class RemotingService extends Proxy implements IEventDispatcher
	{	
		
		/**
		 * The maxiumum timeouts that can happen before every service is haulted.
		 */
		public static var MaxTimeoutsBeforeHault:Number = 0;
		
		/**
		 * The number of timeouts that have occured between any remoting service.
		 */
		public static var NumTimeouts:int = -1;
		
		/**
		 * A flag variable to test whether or not all services have been halted.
		 */
		public static var Halted:Boolean = false;
		
		/**
		 * The remoting connection instance.
		 */
		public var remotingConnection:RemotingConnection;
		
		/**
		 * The service to make remote calls on.
		 */
		public var service:String;
		
		/**
		 * An event dispatcher instance used in proxy methods.
		 */
		private var eventDispatcher:EventDispatcher;
		
		/**
		 * A calls limiter so that numerous calls that keep
		 * timing out won't get recalled.
		 */
		private var remotingLimiter:RemotingCallLimiter;
		
		/**
		 * Flag to use the RemotingCallLimiter or not.
		 */
		private var useLimiter:Boolean;
		
		/**
		 * A Cache instance that caches remoting calls and the responses.
		 */
		public var remotingCache:ICacheStore;
		
		/**
		 * Maximum retries per call.
		 */
		private var maxRetriesPerCall:int;
		
		/**
		 * Call timeout
		 */
		private var callTimeout:int;
		
		/**
		 * Constructor for RemotingService instances.
		 * 
		 * @param	remotingConnection	The RemotingConnection calls get made on.
		 * @param 	service	The service to make calls on the connection to.
		 * @param	callTimeout	The time one call waits before timeing it out, and retrying.
		 * @param	maxRetriesPerCall	The number of retries.
		 * @param	useLimiter	Put call limiting in place.
		 * 
		 * @throws	ArgumentError	If the remoting connection was null.
		 * @throws	ArgumentError	If the service path was null.
		 * 
		 * @see	net.guttershark.remoting.RemotingConnection
		 */
		public function RemotingService(remotingConnection:RemotingConnection, service:String, callTimeout:int, maxRetriesPerCall:int, useLimiter:Boolean = true)
		{
			if(!remotingConnection) throw new ArgumentError("No remoting connection was supplied.");
			if(!service || service == '') throw new ArgumentError("Service path cannot be null");
			eventDispatcher = new EventDispatcher();
			this.remotingConnection = remotingConnection;
			this.service = service;
			this.maxRetriesPerCall = maxRetriesPerCall;
			this.callTimeout = callTimeout;
			this.useLimiter = useLimiter;
			if(useLimiter) remotingLimiter = new RemotingCallLimiter();
		}
		
		/**
		 * Call
		 */
		private function call(methodName:String,arguments:Array,onResult:Function,onFault:Function,returnArgs:Boolean):void
		{	
			if(RemotingService.NumTimeouts >= RemotingService.MaxTimeoutsBeforeHault)
			{
				dispatchEvent(new CallEvent(CallEvent.SERVICE_HALTED,false,false));
				RemotingService.Halted = true;
				return;
			}
			
			RemotingService.Halted = false;
			if(useLimiter)
			{
				var unique:String = (remotingConnection.gateway + service + methodName + arguments.toString()) as String;
				if(!remotingLimiter.canExecute(unique)) return;
			}
			var rcall:RemotingCall = new RemotingCall(this,methodName,onResult,onFault,arguments,returnArgs,callTimeout,maxRetriesPerCall);
			
			if(remotingCache && !rcall.remotingCache) rcall.remotingCache = remotingCache;
			if(useLimiter && !rcall.remotingLimiter) rcall.remotingLimiter = remotingLimiter;
			rcall.addEventListener(CallEvent.RETRY, onCallRetry);
			rcall.addEventListener(CallEvent.TIMEOUT, onCallTimedOut);
			rcall.addEventListener(CallEvent.REQUEST_SENT, onCallSent);
			rcall.execute();
		}
		
		/**
		 * When a call has been sent.
		 */
		private function onCallSent(ce:CallEvent):void
		{
			dispatchEvent(new CallEvent(CallEvent.REQUEST_SENT));
		}
			
		/**
		 * Each remoting call's retry event get's received here.
		 */
		private function onCallRetry(ce:CallEvent):void
		{
			var ve1:CallEvent = new CallEvent(CallEvent.RETRY,false,false);
			ve1.method = ce.method;
			ve1.args = ce.args;
			ve1.service = ce.service;
			eventDispatcher.dispatchEvent(ve1);
		}
		
		/**
		 * Each remoting call's time out event get's received here.
		 */
		private function onCallTimedOut(ce:CallEvent):void
		{
			RemotingService.NumTimeouts++;
			var ve2:CallEvent = new CallEvent(CallEvent.TIMEOUT,false,false);
			ve2.method = ce.method;
			ve2.args = ce.args;
			ve2.service = ce.service;
			eventDispatcher.dispatchEvent(ve2);
		}
		
		/**
		 * @private
		 * 
		 * callProperty - proxy override (__resolve)
		 */
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
				
			/**
			  * If the method was 'apply', use other args for call, this is so that you can
			  * make remoting calles with string method names, not having to use eval or
			  * some other hack.
			  *	myService.apply('myMethod',args,result,fault,metaObject);  would be the same as:
			  * myService.myMethod(args,result,fault,metaObject);
			  */
			if(methodName == 'apply')
			{
				if(args[4] !== true) args[4] = false;
				call(args[0], args[1], args[2], args[3], args[4]);
			}
			else
			{
				call(methodName.toString(), args[0], args[1], args[2], args[3]);
			}
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
		}
		
		/**
		 * Registers an event listener object with an EventDispatcher object so that the listener receives notification of an event.
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, weakRef:Boolean = false):void 
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority, weakRef);
		}
		
		/**
		 * Dispatches an event into the event flow.
		 */
		public function dispatchEvent(event:Event):Boolean 
		{
			return eventDispatcher.dispatchEvent(event);
		}
		
		/**
		 * Checks whether the RemotingService object has any listeners registered for a specific type of event.
		 */
		public function hasEventListener(type:String):Boolean 
		{
			return eventDispatcher.hasEventListener(type);
		}
		
		/**
		 * Remove and event listener.
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		/**
		 * Checks whether an event listener is registered with this EventDispatcher object or any of its ancestors for the specified event type.
		 */
		public function willTrigger(type:String):Boolean 
		{
			return eventDispatcher.willTrigger(type);
		}
	}
}