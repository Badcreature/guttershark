package net.guttershark.support.preloading.workers
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	
	import net.guttershark.support.preloading.Asset;
	import net.guttershark.support.preloading.events.AssetCompleteEvent;
	import net.guttershark.support.preloading.workers.Worker;

	/**
	 * The StyleSheetWorker class is the worker that loads all
	 * css files.
	 */
	final public class StyleSheetWorker extends Worker
	{
		
		/**
		 * Load an asset of type css.
		 * 
		 * @param asset The Asset instance that needs to be loaded.
		 * @see net.guttershark.preloading.PreloadController PreloadController class
		 */
		public override function load(asset:Asset):void
		{
			this.loader = new URLLoader();
			this.asset = asset;
			this.request = new URLRequest(asset.source);
			loader.addEventListener(Event.COMPLETE, onComplete,false,0,true);
			loader.addEventListener(ProgressEvent.PROGRESS, onProgress,false,0,true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOLoadError,false,0,true);
			loader.addEventListener(IOErrorEvent.DISK_ERROR, onIOLoadError,false,0,true);
			loader.addEventListener(IOErrorEvent.NETWORK_ERROR, onIOLoadError,false,0,true);
			loader.addEventListener(IOErrorEvent.VERIFY_ERROR, onIOLoadError,false,0,true);
			loader.addEventListener(Event.OPEN, onOpen,false,0,true);
			start();
		}
		
		/**
		 * Event handler for the style sheet loading complete event.
		 * 
		 * @param e The event from url loaders complete event
		 */
		override protected function onComplete(e:Event):void
		{
			var sheet:StyleSheet = new StyleSheet();
			sheet.parseCSS(loader.data);
			asset.data = sheet;
			dispatchEvent(new AssetCompleteEvent(AssetCompleteEvent.COMPLETE, asset));
			asset = null;
			try{loader.close();}catch(error:*){}
			dispose();
		}	}}