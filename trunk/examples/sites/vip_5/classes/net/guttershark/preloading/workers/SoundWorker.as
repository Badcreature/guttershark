package net.guttershark.preloading.workers
{
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import net.guttershark.preloading.Asset;
		
	/**
	 *	The SoundWorker class is the worker loads all
	 *	sound files.
	 *	
	 *	<p>This class is not used directly. It is used internally to an
	 *	Asset instance.</p>
	 *	
	 *	@see net.guttershark.preloading.PreloadController PreloadController class
	 */
	public class SoundWorker extends Worker
	{
		
		/**
		 * Load an asset of type mp3.
		 * 
		 * @param	asset	The Asset instance that needs to be loaded.
		 * @see net.guttershark.preloading.PreloadController PreloadController class
		 */
		public override function load(asset:Asset):void
		{
			this.loader = new Sound();
			this.asset = asset;
			this.request = new URLRequest(asset.source);
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOLoadError);
			loader.addEventListener(IOErrorEvent.DISK_ERROR, onIOLoadError);
			loader.addEventListener(IOErrorEvent.NETWORK_ERROR, onIOLoadError);
			loader.addEventListener(IOErrorEvent.VERIFY_ERROR, onIOLoadError);
			loader.addEventListener(Event.OPEN, onOpen);
			start();
		}
	}
}