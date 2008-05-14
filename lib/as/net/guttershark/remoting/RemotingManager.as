package net.guttershark.remoting 
{

	import flash.utils.Dictionary;
	
	import net.guttershark.util.cache.Cache;
	import net.guttershark.util.Assert;
	import net.guttershark.core.IDisposable;
	
	/**
	 * The RemotingManager class simplifies creating remoting connections
	 * and services. This class is also used in the SiteXMLParser to simpify
	 * initializing remoting services from a site XML file.
	 * 
	 * @see net.guttershark.model.SiteXMLParser SiteXMLParser class
	 */
	public class RemotingManager implements IDisposable 
	{

		/**
		 * The default object encoding to use when creating RemotingConnections.
		 */
		public static var DefaultObjectEncoding:int = 3;

		/**
		 * Services.
		 */
		private var services:Dictionary;
		
		/**
		 * Constructor for RemotingManager instances.
		 */
		public function RemotingManager():void
		{	
			services = new Dictionary();
		}
		
		/**
		 * Create a RemotingService.
		 * 
		 * @param	id	The identifier for the newly created service.
		 * @param	gateway	The gateway URL.
		 * @param	service	The remoting service.
		 * @param	callTimeout	The timeout in milliseconds for each remoting call.
		 * @param	maxRetries	The maximum amount of retries per remoting call.
		 * @param	useLimiter	Whether or not to use limiting for each remoting call (see net.guttershark.remoting.limiting.RemotingLimiter)
		 * @param	useCache	Whether or not to use a Cache instance for the new remoting service.
		 * @param	cacheExpireTimeout	The time in milliseconds that a Cache instance will live in memory, before expiring.
		 */
		public function createService(id:String, gateway:String, service:String, callTimeout:int = 5000, maxRetries:int = 3, useLimiter:Boolean = true, useCache:Boolean = false, cacheExpireTimeout:int = -1):void
		{
			var connection:RemotingConnection = new RemotingConnection(gateway, RemotingManager.DefaultObjectEncoding);
			var sv:RemotingService = new RemotingService(connection,service,callTimeout,maxRetries,useLimiter);
			if(useCache) sv.remotingCache = new Cache(cacheExpireTimeout);
			services[id] = sv;
		}

		/**
		 * Returns a handle on a RemotingService.
		 */
		public function getService(id:String):RemotingService
		{
			Assert.NotNull(id, "Parameter id cannot be null");
			Assert.NotNull(services[id], "Service " + id + "not available");
			return services[id];
		}
		
		/**
		 * Destroy a service.
		 */
		public function destroyService(id:String):void
		{
			services[id] = null;
		}
		
		/**
		 * Dispose of internal memory used for this manager.
		 */
		public function dispose():void
		{
			services = new Dictionary();
		}
	}}