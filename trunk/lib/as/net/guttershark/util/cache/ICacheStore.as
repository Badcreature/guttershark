package net.guttershark.util.cache
{

	import net.guttershark.core.IDisposable;	
	
	/**
	 * The ICacheStore interface creates the contract for objects that implement
	 * a CacheStore pattern.
	 * 
	 * @see net.guttershark.util.cache.Cache
	 */
	public interface ICacheStore extends IDisposable
	{

		/**
		 * Purge all items in the cache.
		 */
		function purgeAll():void
		
		/**
		 * Purge an item in the cache.
		 */
		function purgeItem(key:*):void;
		
		/**
		 * Cache an object.
		 * @param	key	The key to store the object as.
		 * @param	purgeTimeout	The time in milliseconds before the item should be cache. Use -1 to never expire.
		 * @param	overwrite	Overwrite the previously cached object by stored.
		 */
		function cacheObject(key:*, item:*, purgeTimeout:int = -1, overwrite:Boolean = false):void;
		
		/**
		 * Denotes whether or not an object is cached.
		 * @param	key	The key used to store the object.
		 */
		function isCached(key:*):Boolean;
		
		/**
		 * Get a cached object by key.
		 * @param	key	The key used to store the object as.
		 */
		function getCachedObject(key:*):*;
	}
}