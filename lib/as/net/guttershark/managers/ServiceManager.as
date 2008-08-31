package net.guttershark.nsm
{
	import net.guttershark.nsm.http.Service;	
	
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import net.guttershark.nsm.remoting.RemotingService;
	import net.guttershark.nsm.remoting.RemotingConnection;
	import net.guttershark.util.Singleton;		

	public dynamic class ServiceManager extends Proxy
	{
		
		private static var inst:ServiceManager;
		private var services:Dictionary;
		private var rcp:Dictionary;
		
		public function ServiceManager()
		{
			Singleton.assertSingle(ServiceManager);
			services = new Dictionary();
			rcp = new Dictionary();
		}
		
		public static function gi():ServiceManager
		{
			if(inst == null) inst = Singleton.gi(ServiceManager);
			return inst;
		}
		
		public function createRemotingService(id:String,gateway:String,endpoint:String,objectEncoding:int,attempts:int=1,timeout:int=10000,limiter:Boolean=false):void
		{
			if(services[id]) return;
			var rc:RemotingConnection;
			if(!rcp[gateway]) rc = rcp[gateway] = new RemotingConnection(gateway,objectEncoding);
			else rc = rcp[gateway];
			services[id] = new RemotingService(rc,endpoint,attempts,timeout,limiter);
		}
		
		public function createHTTPService(id:String, url:String, attempts:int=1, timeout:int=10000, limiter:Boolean=false, defaultResponseFormat:String="variables"):void
		{
			if(services[id]) return;
			var s:Service = new Service(url,attempts,timeout,limiter,defaultResponseFormat);
			services[id] = s;
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
		
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			if(!services[methodName]) throw new Error("Service {"+methodName+"} not found.");
			if(services[methodName] is RemotingService) throw new Error("RemotingService not supported, only an http Service can be called this way.");
			var callProps:Object = args[0];
			services[methodName].send(callProps);
		}
	}
}