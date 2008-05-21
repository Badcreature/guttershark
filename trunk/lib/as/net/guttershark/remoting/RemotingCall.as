package net.guttershark.remoting
{
	
	import flash.events.EventDispatcher;
	import flash.net.Responder;
	import flash.utils.*;
	
	import net.guttershark.remoting.events.*;
	import net.guttershark.remoting.limiting.RemotingCallLimiter;
	import net.guttershark.util.cache.ICacheStore;
	
	/**
	 * Dispatched when any one of the remoting call requests retries.
	 * 
	 * @eventType net.guttershark.remoting.events.CallEvent
	 */
	[Event("retry",type="net.guttershark.remoting.events.CallEvent")];
	
	/**
	 * Dispatched when a remoting call completely times out.
	 * 
	 * @eventType net.guttershark.remoting.events.CallEvent
	 */
	[Event("timeout",type="net.guttershark.remoting.events.CallEvent")];
	
	/**
	 * Dispatched when a remoting call request is sent.
	 * 
	 * @eventType net.guttershark.remoting.events.CallEvent
	 */
	[Event("requestSent",type="net.guttershark.remoting.events.CallEvent")];
	
	/**
	 * The RemotingCall class encapsulates a remoting request, and manages timing tasks with the call and should not be used directly.
	 * 
	 * <p>The RemotingCall class is used internally to a RemotingService and should not be used directly.</p>
	 * 
	 * @see net.guttershark.remoting.RemotingManager
	 */
	public class RemotingCall extends EventDispatcher
	{
		
		/**
		 * The service this call came through.
		 */
		private var remotingService:RemotingService;
		
		/**
		 * The operation to call.
		 */
		private var operation:String;
		
		/**
		 * The result function callback.
		 */
		private var result:Function;
		
		/**
		 * The fault function callback.
		 */
		private var fault:Function;
		
		/**
		 * The arguments to send in the remote call.
		 */
		private var args:Array;
		
		/**
		 * How many attempts have been made.
		 */
		private var attempt:uint = 0;
		
		/**
		 * The var used for the timeout interval.
		 */
		private var timeoutInt:Number;
		
		/**
		 * Whether or not this call is complete yet.
		 */
		private var completed:Boolean = false;
		
		/**
		 * The amount of time before a call
		 * is considered timedout. This is the 
		 * timeout that used for a retry.
		 */
		private var callTimeout:int;
		
		/**
		 * Currently being called method.
		 */
		private var method:String;
		
		/**
		 * A cache object if cache is being used.
		 */
		public var remotingCache:ICacheStore;
		
		/**
		 * A limiter if being used.
		 */
		public var remotingLimiter:RemotingCallLimiter;
		
		/**
		 * How many attempts to make on the
		 * remote call.
		 */
		private var maxRetries:int;
		
		/**
		 * Whether or not to return the original
		 * arguments to the callback functions.
		 */
		private var returnArgs:Boolean;
		
		/**
		 * New remoting call. This is not meant to be used outside of a RemotingService.
		 * 
		 * @param	remotingService	The RemotingService used for this call.
		 * @param	method	The operation to call on the connection.
		 * @param	onResult	The result function to call.
		 * @param	onFault	The fault function to call.
		 * @param	args	The arguments to send to the net connection.
		 * @param	returnArgs	Whether or not to send the original arguments to the result or fault callback.
		 * @param	callTimeout	The time before a retry occurs in milliseconds.
		 * @param	maxRetries	The maximum number of retries.
		 * 
		 * @throws	ArgumentError If the remoting service was null.
		 * @throws	ArgumentError If the method was null.
		 */
		public function RemotingCall(remotingService:RemotingService, method:String, onResult:Function, onFault:Function, args:Array, returnArgs:Boolean, callTimeout:int = 30000, maxRetries:int = 3) 
		{	
			if(!remotingService) throw new ArgumentError("The RemotingService supplied to the remoting call was null.");
			if(!method || method == "") throw new ArgumentError("The method cannot be null or empty");
			this.remotingService = remotingService;
			this.method = method;
			this.args = args;
			this.result = onResult;
			this.returnArgs = returnArgs;
			this.fault = onFault;
			this.maxRetries = maxRetries;
			this.callTimeout = callTimeout;
			this.operation = remotingService.service + "." + method;
		}
		
		/**
		 * When a result has been received from the net connection call.
		 * 
		 * @return	void
		 */
		private function onResult(resObj:Object):void
		{			
			if(!completed)
			{
				completed = true;
				clearIntervals();
				var unique:String = getUniqueIdentifier();
				if(remotingLimiter) remotingLimiter.releaseCall(unique);
				if(remotingCache) remotingCache.cacheObject(unique,resObj);
				var re:ResultEvent = new ResultEvent(resObj, false, true);
				(returnArgs) ? result(re,args) : result(re);
			}
		}
		
		/**
		 * When a fault has been received from the net connection call.
		 * 
		 * @return	void
		 */
		private function onFault(resObj:Object):void
		{
			if(!completed)
			{
				var unique:String = getUniqueIdentifier();
				if(remotingLimiter) remotingLimiter.releaseCall(unique);
				if(remotingCache) remotingCache.purgeItem(unique);
				completed = true;
				clearIntervals();
				var fe:FaultEvent = new FaultEvent(resObj, false, true);
				(returnArgs) ? fault(fe,args) : fault(fe);
			}
		}
		
		/** 
		 * Executes the remoting call and initiates timeout watching if specified.
		 */
		public function execute():void
		{	
			if(!completed)
			{
				var unique:String = getUniqueIdentifier();
				if(remotingCache && remotingCache.isCached(unique))
				{
					if(remotingLimiter) remotingLimiter.releaseCall(unique);
					completed = true;
					clearIntervals();
					var re:ResultEvent = new ResultEvent(remotingCache.getCachedObject(unique), false, true);
					(returnArgs) ? result(re,args) : result(re);
					return;
				}
				var operation:String = remotingService.service + "." + method;
				var responder:Responder = new Responder(onResult, onFault);
				var callArgs:Array = new Array(operation, responder);
				if(attempt == 0)
				{
					if(maxRetries > 0)
					{
						if(callTimeout) timeoutInt = setInterval(handleTimeout,callTimeout);
					}
					else
					{
						maxRetries = 0;
					}
				}
				
				remotingService.remotingConnection.connection.call.apply(null, callArgs.concat(args));
				var rs:CallEvent = new CallEvent(CallEvent.REQUEST_SENT,false,false);
				rs.args = args;
				rs.connection = remotingService.remotingConnection;
				rs.service = remotingService;
				rs.method = method;
				dispatchEvent(new CallEvent(CallEvent.REQUEST_SENT,false,false));
				attempt++;
				if(remotingLimiter) remotingLimiter.lockCall(getUniqueIdentifier());
			}
		}
		
		/**
		 * Handles a timed out call, if the max attempts is reached, a timed out event is dispatched, 
		 * otherwise a rety event is dispatched.
		 * 
		 * @return	void
		 */
		private function handleTimeout():void
		{
			if(!completed)
			{
				var ce:CallEvent;
				if(attempt > maxRetries)
				{
					completed = true;
					clearIntervals();
					if(remotingLimiter) remotingLimiter.releaseCall(getUniqueIdentifier());
					ce = new CallEvent(CallEvent.TIMEOUT,true,false);
					ce.connection = remotingService.remotingConnection;
					ce.service = remotingService;
					ce.method = method;
					ce.args = args;
					ce.rawData = null;
					dispatchEvent(ce);
					execute();
				}
				else
				{
					ce = new CallEvent(CallEvent.RETRY,true,false);
					ce.connection = remotingService.remotingConnection;
					ce.service = remotingService;
					ce.method = method;
					ce.args = args;
					ce.rawData = null;
					dispatchEvent(ce);
					execute();
				}
			}
		}
		
		/**
		 * Get's the unique identifer for this call happening.
		 * 
		 * @return 	String
		 */
		private function getUniqueIdentifier():String
		{
			return (remotingService.remotingConnection.gateway + remotingService.service + method + args.toString()) as String;
		}
		
		/**
		 * Clears intervals running for retries
		 * 
		 * @return	void
		 */
		private function clearIntervals():void
		{
			clearInterval(timeoutInt);
			timeoutInt = 0;
		}
	}
}