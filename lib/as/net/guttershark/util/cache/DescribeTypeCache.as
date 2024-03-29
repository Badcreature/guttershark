package net.guttershark.util.cache 
{
	import net.guttershark.util.Singleton;		

	/**
	 * The DescribeType classs wraps the flash.util.describeType
	 * function and caches all object descriptions so that
	 * describeType will only be called once for any object.
	 */
	final public class DescribeTypeCache 
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:DescribeTypeCache;
		
		/**
		 * The type cache.
		 */
		private var dcache:Cache;
		
		/**
		 * Singleton access.
		 */
		public static function gi():DescribeTypeCache
		{
			if(!inst) inst = Singleton.gi(DescribeTypeCache);
			return inst;
		}
		
		/**
		 * @private
		 */
		public function DescrybeTypeCache():void
		{
			Singleton.assertSingle(DescribeTypeCache);
			dcache = new Cache();
		}
		
		/**
		 * Returns the type description for an object.
		 * 
		 * @param obj The object to describe.
		 */
		public function describeType(obj:*):XML
		{
			var x:XML;
			if(dcache.isCached(obj)) x = dcache.getCachedObject(obj);
			else
			{
				x = describeType(obj);
				dcache.cacheObject(obj,x);				
			}
			return x;
		}	}}