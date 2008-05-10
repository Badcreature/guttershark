package net.guttershark.util.cache
{

	/**
	 * The ICacheStore interface creates the contract for objects that implement
	 * a CacheStore pattern.
	 * 
	 * @see net.guttershark.util.cache.Cache
	 */
	public interface ICacheStore
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
		function isCached(key:*):Boolean;
		function getCachedObject(key:*):*;
	}
}