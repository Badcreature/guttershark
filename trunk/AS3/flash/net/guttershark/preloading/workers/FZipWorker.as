package net.guttershark.preloading.workers
{
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	import net.guttershark.preloading.events.AssetErrorEvent;
	import net.guttershark.preloading.Asset;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipErrorEvent;
	
	
	/**
	 *	The FZipWorker class is the worker that loads FZip files.
	 *	
	 *	<p>The zip files that can be loded must have been run against
	 *	the fzip-prepare.py script, in order for FZip to correctly read
	 *	the zip</p>
	 *	
	 *	<p>This class should not be used directly, it's used internally
	 *	to an Asset instance.</p>
	 *	
	 *	@see net.guttershark.preloading.PreloadController PreloadController class
	 */
	public class FZipWorker extends Worker
	{
		
		/**
		 * Load an asset of type zip.
		 * 
		 * @param	LoadItem	The load item's source should be a URL to a zip file.
		 */
		public override function load(asset:Asset):void
		{
			this.asset = asset;
			this.request = new URLRequest(asset.source);
			this.loader = new FZip();
			loader.addEventListener(Event.OPEN, super.onOpen);
			loader.addEventListener(ProgressEvent.PROGRESS, super.onProgress);
			loader.addEventListener(FZipErrorEvent.PARSE_ERROR, super.onIOLoadError);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHTTPStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, super.onIOLoadError);
			loader.addEventListener(IOErrorEvent.DISK_ERROR, super.onIOLoadError);
			loader.addEventListener(IOErrorEvent.NETWORK_ERROR, super.onIOLoadError);
			loader.addEventListener(IOErrorEvent.VERIFY_ERROR, super.onIOLoadError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityError);
			loader.addEventListener(Event.COMPLETE, super.onComplete);
			loader.addEventListener(FZipErrorEvent.PARSE_ERROR, onParseError);
			start();
		}
		
		private function onParseError(fz:FZipErrorEvent):void
		{
			dispatchEvent(new AssetErrorEvent(AssetErrorEvent.ERROR,this.asset));
		}
	}
}