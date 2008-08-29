package net.guttershark.preloading.workers 
{
	import flash.text.StyleSheet;	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import net.guttershark.preloading.Asset;
	import net.guttershark.preloading.events.AssetCompleteEvent;		

	public class StyleSheetWorker extends Worker
	{
		
		/**
		 * Load an asset of type css.
		 * 
		 * @param	asset	The Asset instance that needs to be loaded.
		 * @see net.guttershark.preloading.PreloadController PreloadController class
		 */
		public override function load(asset:Asset):void
		{
			this.loader = new URLLoader();
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
		
		/**
		 * Event handler for the style sheet loading complete event.
		 * 
		 * @param	e	The event from url loaders complete event
		 */
		override protected function onComplete(e:Event):void
		{
			removeEventListeners();
			var sheet:StyleSheet = new StyleSheet();
			sheet.parseCSS(loader.data);
			asset.data = sheet;
			dispatchEvent(new AssetCompleteEvent(AssetCompleteEvent.COMPLETE, asset));
			asset = null;
			try
			{
				loader.close();
			}catch(error:*){} //this suppresses cases where the loader used doesn't have a close method.
		}	}}