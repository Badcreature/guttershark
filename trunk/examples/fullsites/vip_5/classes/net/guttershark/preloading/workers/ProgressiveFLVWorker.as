package net.guttershark.preloading.workers
{
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	import net.guttershark.preloading.Asset;
		
	/**
	 *	The ProgressiveFLVWorker class is the worker that loads all
	 *	progressive flv files.
	 *	
	 *	<p>This class is not used directly. It is used internally to an
	 *	Asset instance.</p>
	 *	
	 *	@see net.guttershark.preloading.PreloadController PreloadController class
	 */
	public class ProgressiveFLVWorker extends Worker
	{
		
		/**
		 * Load an asset of type flv.
		 * 
		 * @param	asset	The Asset instance that needs to be loaded.
		 * @see net.guttershark.preloading.PreloadController PreloadController class
		 */
		public override function load(asset:Asset):void
		{
			this.asset = asset;
			this.request = new URLRequest(asset.source);
			var header:URLRequestHeader = new URLRequestHeader("Content-Type", "video/x-flv");
			request.requestHeaders.push(header);
			this.request.contentType = "video/x-flv";
			this.loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.OPEN, onOpen);
			loader.addEventListener(ProgressEvent.PROGRESS, super.onProgress);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHTTPStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, super.onIOLoadError);
			loader.addEventListener(IOErrorEvent.DISK_ERROR, super.onIOLoadError);
			loader.addEventListener(IOErrorEvent.NETWORK_ERROR, super.onIOLoadError);
			loader.addEventListener(IOErrorEvent.VERIFY_ERROR, super.onIOLoadError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityError);
			loader.addEventListener(Event.COMPLETE, super.onComplete);
			start();
		}
	}
}