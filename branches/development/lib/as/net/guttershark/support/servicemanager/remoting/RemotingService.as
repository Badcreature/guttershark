package net.guttershark.support.servicemanager.remoting
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import net.guttershark.support.servicemanager.remoting.RemotingCall;
	import net.guttershark.support.servicemanager.remoting.RemotingConnection;
	import net.guttershark.support.servicemanager.shared.Limiter;	
	
	/**
	 * The RemotingService class implements a Remoting endpoint
	 * where RemotingCalls get sent to.
	 */
	dynamic public class RemotingService extends Proxy
	{
		
		/**
		 * @private
		 * The RemotingConnection.
		 */
		public var rc:RemotingConnection;
		
		/**
		 * @private
		 * A limiter, which get's passed to call instances.
		 */
		public var limiter:Limiter;
		
		/**
		 * The endpoint.
		 */
		private var endpoint:String;
		
		/**
		 * how many attempts.
		 */
		private var attempts:int;
		
		/**
		 * timeout.
		 */
		private var timeout:int;
		
		/**
		 * Constructor for RemotingService instances.
		 * 
		 * @param rc A RemotingConnection that this service will use.
		 * @param endpoint The service endpoint.
		 * @param attempts How many attempts can be made before a timeout occures.
		 * @param timeout The time to allow each request, before retrying.
		 */
		public function RemotingService(rc:RemotingConnection,endpoint:String,attempts:int,timeout:int,limiter:Boolean)
		{
			this.rc=rc;
			this.endpoint=endpoint;
			this.attempts=attempts;
			this.timeout=timeout;
			if(limiter) this.limiter = new Limiter();
		}
		
		/**
		 * This is not the recommended way of using the remoting service, but is available
		 * so you can call service methods where the methd name comes from a string variable.
		 * 
		 * @example Calling a service with the call method:
		 * <listing>	
		 * var sm:ServiceManager = ServiceManager.gi();
		 * 
		 * var tf:TextField = new TextField();
		 * tf.text = "helloWorld";
		 * 
		 * sm.helloWorldService.call(tf.text,{...});
		 * 
		 * //the normal way:
		 * sm.helloWorldService.helloWorld({...});
		 * </listing>
		 */
		public function call(methodName:String, ...args):*
		{
			var callProps:Object = args[0];
			if(!callProps.timeout) callProps.timeout=timeout;
			if(!callProps.attempts) callProps.attempts=attempts;
			if(!callProps.params) callProps.params=[];
			callProps.endpoint=endpoint;
			callProps.method=methodName;
			var rcall:RemotingCall = new RemotingCall(this,callProps);
			if(callProps.onCreate) callProps.onCreate();
			var unique:String=(rc.gateway+endpoint+methodName+callProps.params.toString());
			rcall.id = unique;
			if(limiter)
			{
				if(!limiter.canExecute(unique))
				{
					if(callProps.onLimited) callProps.onLimited();
					return;
				}
				rcall.limiter = limiter;
			}
			rcall.execute();
			return null;
		}
		
		/**
		 * @private
		 * 
		 * sm.user // returns user RemotingService
		 * //sm.user.deleteUser({})
		 * 
		 * callProperty - proxy override (__resolve)
		 */
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			var callProps:Object = args[0];
			if(!callProps.timeout) callProps.timeout=timeout;
			if(!callProps.attempts) callProps.attempts=attempts;
			if(!callProps.params) callProps.params=[];
			callProps.endpoint=endpoint;
			callProps.method=methodName;
			var rcall:RemotingCall = new RemotingCall(this,callProps);
			if(callProps.onCreate) callProps.onCreate();
			var unique:String=(rc.gateway+endpoint+methodName+callProps.params.toString());
			rcall.id = unique;
			if(limiter)
			{
				if(!limiter.canExecute(unique))
				{
					if(callProps.onLimited) callProps.onLimited();
					return;
				}
				rcall.limiter = limiter;
			}
			rcall.execute();
			return null;
		}
		
		/**
		 * Dispose of this RemotingService.
		 */
		public function dispose():void
		{
			if(limiter) limiter.dispose();
			limiter = null;
			timeout = 0;
			attempts = 0;
			endpoint = null;
		} 
		
		/**
		 * Friendly description.
		 */
		public function toString():String
		{
			return "[RemotingService " + endpoint + "]";
		}
	}
}