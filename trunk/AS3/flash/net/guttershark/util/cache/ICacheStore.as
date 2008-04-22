package net.guttershark.util.cache
{

	/**
	 * The ICacheStore interface is used to force any class that wants
	 * to implement a CacheStore into using the right methods.
	 * 
	 * @see net.guttershark.util.cache.Cache
	 */
	public interface ICacheStore
	{
		function purgeAll():void
		function purgeItem(key:*):void;
		function cacheObject(key:*, item:*, purgeTimeout:int=-1, overwrite:Boolean = false):void;
		function isCached(key:*):Boolean;
		function getCachedObject(key:*):*;
	}
}