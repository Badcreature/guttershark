package net.guttershark.preloading.workers
{
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	import net.guttershark.preloading.Asset;
	
	/**
	 *	The BitmapWorker class is the worker that loads all
	 *	assets that are considered bitmap files.
	 *	
	 *	<p>This class is not used directly. It is used internally to an
	 *	Asset instance.</p>
	 *	
	 *	@see net.guttershark.preloading.PreloadController PreloadController class
	 */
	public class BitmapWorker extends Worker
	{	
		
		/**
		 * Load an asset of type bitmap.
		 * 
		 * @param	asset	The Asset instance that needs to be loaded.
		 */
		override public function load(asset:Asset):void
		{
			this.asset = asset;
			request = new URLRequest(asset.source);
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.OPEN, super.onOpen);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, super.onProgress);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHTTPStatus);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, super.onIOLoadError);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, super.onIOLoadError);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, super.onIOLoadError);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, super.onIOLoadError);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityError);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, super.onComplete);
			start();
		}
	}
}