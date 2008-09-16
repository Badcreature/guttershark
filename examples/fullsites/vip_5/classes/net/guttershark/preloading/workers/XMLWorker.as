package net.guttershark.preloading.workers
{
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	import net.guttershark.preloading.Asset;
	import net.guttershark.util.XMLLoader;
	
	/**
	 *	The XMLWorker class is the worker that loads all
	 *	xml files.
	 *	
	 *	<p>This class is not used directly. It is used internally to an
	 *	Asset instance.</p>
	 *	
	 *	@see net.guttershark.preloading.PreloadController PreloadController class
	 */
	public class XMLWorker extends Worker
	{	
		
		/**
		 * Load an asset of type xml.
		 * 
		 * @param	asset	The Asset instance that needs to be loaded.
		 * @see net.guttershark.preloading.PreloadController PreloadController class
		 */
		public override function load(asset:Asset):void
		{
			this.asset = asset;
			this.request = new URLRequest(asset.source);
			this.loader = new XMLLoader();
			loader.contentLoader.addEventListener(Event.OPEN, super.onOpen);
			loader.contentLoader.addEventListener(ProgressEvent.PROGRESS, super.onProgress);
			loader.contentLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHTTPStatus);
			loader.contentLoader.addEventListener(IOErrorEvent.IO_ERROR, super.onIOLoadError);
			loader.contentLoader.addEventListener(IOErrorEvent.DISK_ERROR, super.onIOLoadError);
			loader.contentLoader.addEventListener(IOErrorEvent.NETWORK_ERROR, super.onIOLoadError);
			loader.contentLoader.addEventListener(IOErrorEvent.VERIFY_ERROR, super.onIOLoadError);
			loader.contentLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityError);
			loader.contentLoader.addEventListener(Event.COMPLETE, super.onComplete);
			start();
		}
	}
}