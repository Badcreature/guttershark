package net.guttershark.preloading
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import net.guttershark.preloading.Asset;
	import net.guttershark.preloading.events.AssetCompleteEvent;
	import net.guttershark.preloading.events.AssetErrorEvent;
	import net.guttershark.preloading.events.AssetOpenEvent;
	import net.guttershark.preloading.events.AssetProgressEvent;
	import net.guttershark.preloading.events.AssetStatusEvent;
	import net.guttershark.preloading.events.PreloadProgressEvent;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.workers.WorkerInstances;
	
	/**
	 * Dispatched for each item that has completed downloading.
	 * 
	 * @eventType net.guttershark.preloading.events.AssetCompleteEvent
	 */
	[Event("assetComplete", type="net.guttershark.preloading.events.AssetCompleteEvent")]
	
	/**
	 * Dispatched for each item that has started downloading.
	 * 
	 * @eventType net.guttershark.preloading.events.AssetOpenEvent
	 */
	[Event("assetOpen", type="net.guttershark.preloading.events.AssetOpenEvent")]
	
	/**
	 * Dispatched for each item that has has stopped downloading because of an error.
	 * 
	 * @eventType net.guttershark.preloading.events.AssetErrorEvent
	 */
	[Event("assetError", type="net.guttershark.preloading.events.AssetErrorEvent")]
	
	/**
	 * Dispatched for each item that is downloading.
	 * 
	 * @eventType net.guttershark.preloading.events.AssetProgressEvent
	 */
	[Event("assetProgress", type="net.guttershark.preloading.events.AssetProgressEvent")]
	
	/**
	 * Dispatched for each item that generated an http status code other than 0 or 200.
	 * 
	 * @eventType net.guttershark.preloading.events.AssetStatusEvent
	 */
	[Event("assetStatus", type="net.guttershark.preloading.events.AssetStatusEvent")]
	
	/**
	 * Dispatched on progress of the entire PreloadController progress.
	 * 
	 * @eventType net.guttershark.preloading.events.PreloadProgressEvent
	 */
	[Event("preloadProgress", type="net.guttershark.preloading.events.PreloadProgressEvent")]
	
	/**
	 * The PreloadController is a controller you use for loading multiple assets. It provides you
	 * with methods for starting, stopping, pausing, resuming and prioritizing of assets.
	 * 
	 * <p>The PreloadController utilizes an internal asset library to store all loaded assets.
	 * You can access the library to get assets out after the preload is complete.</p>
	 * 
	 * <p>Events are dispatched for each item being loaded as well, so you do have hooks into
	 * the asset as soon as they are loaded. See the events section listed here for more events.</p>
	 * 
	 * <p>Files are preloaded one at a time, in sequence. This is so that multiple loading files
	 * don't slow everything else down more. The more files loading at once the slower it actually
	 * turns out to load all of them - that is why this is in sequence.</p>
	 * 
	 * @see #library library property
	 * @see #start() start method
	 * 
	 * @example Heres an example of using the preload controller:
	 * <listing version="3.0">
	 * 
	 public class PreloaderTest extends MovieClip 
	 {
		
		private var preloadController:PreloadController;
		public var preloader:MovieClip;
		
		public function PreloaderTest()
		{
			super();
			this.loaderInfo.addEventListener(Event.COMPLETE, onSWFComplete);
		}
		
		private function onSWFComplete(e:Event):void
		{
			//you should have an assets folder local to the swf with these assets in it.
			var assets:Array = [
				new Asset("assets/jpg1.jpg","jpg1"),
				new Asset("assets/jpg2.jpg","jpg2"),	
				new Asset("assets/png1.png","png1"),
				new Asset("assets/png2.png","png2"),
				new Asset("swfload_test.swf","swf1"),
				new Asset("assets/sound1.mp3","snd1"),
				new Asset("assets/Pizza_Song.flv","pizza"),
				new Asset("assets/zip1.zip","zip1")
			];
			preloadController = new PreloadController(assets,400);
			preloadController.addEventListener(PreloadProgressEvent.PROGRESS, onProgress);
			preloadController.addEventListener(Event.COMPLETE,onPreloaderComplete);
			preloadController.addEventListener(AssetCompleteEvent.COMPLETE, onItemComplete);
			preloadController.prioritize(assets[4]); //prioritize the swf.
			preloadController.start(); //start it;
			preloadController.stop(); //pause it
			setTimeout(preloadController.start,4000); //resume it
		}
			
		private function onProgress(pe:PreloadProgressEvent):void
		{
			trace("progress: pixels: " + pe.pixels + " percent: " + pe.percent);
			preloader.width = pe.pixels
		}
		
		private function onItemComplete(e:AssetCompleteEvent):void
		{
			trace(e.asset.libraryName + " " + e.asset.source);
		}
		
		private function onPreloaderComplete(e:*):void
		{
			trace("PRELOAER COMPLETE");
			addChild(preloadController.library.getAssetFromSWFLibraryAsMovieClip("swf1", "Test"));
			addChild(preloadController.library.getBitmap("jpg1"));
		}
	 }
	 * </listing>
	 */
	public class PreloadController extends EventDispatcher
	{
		
		/**
		 * The number of loaded items in this instance of the PreloadController.
		 */
		private var loaded:int;
		
		/**
		 * Number of errors in this instance.
		 */
		private var loadErrors:int;
		
		/**
		 * An asset library instance that all loaded items
		 * go to in this preloader.
		 */
		private var _library:AssetLibrary;

		/**
		 * An array of items to be loaded.
		 */
		private var loadItems:Array;
		
		/**
		 * A duplicate of the original load items. Used internally.
		 */
		private var loadItemsDuplicate:Array;
		
		/**
		 * The currently loading item.
		 */
		private var currentItem:Asset;
		
		/**
		 * A pool of total bytes from each item that is loading
		 * in this instance.
		 */
		private var bytesTotalPool:Array;
		
		/**
		 * A loading pool, each item that is loading has an 
		 * entry in this pool, the entry is it's bytesLoaded.
		 */
		private var bytesLoadedPool:Array;
		
		/**
		 * Stores loading item info (bl / bt)
		 */
		private var loadingItemsPool:Array;
		
		/**
		 * The total pixels to fill for this preloader.
		 */
		private var totalPixelsToFill:int;
		
		/**
		 * Flag used for pausing and resuming
		 */
		private var _working:Boolean;
		
		/**
		 * Constructor for PreloadController instances.
		 * 
		 * @param	items	An array of Asset instances.
		 * @param 	pixelsToFill	The total number of pixels this preloader needs to fill. This is used in calculating both pixels and percent. if you aren't interested in pixels, don't pass this parameter. 
		 * @throws	ArgumentError	If no items are in the array.
		 * @throws	ArgumentError	If pixelsToFill is 0.
		 * 
		 * @see net.guttershark.preloading.events.PreloadProgressEvent PreloadProgressEvent event
		 */
		public function PreloadController(pixelsToFill:int = 100)
		{
			if(pixelsToFill == 0) throw new ArgumentError("Pixels to fill must be greater than zero.");
			WorkerInstances.RegisterDefaultWorkers();
			totalPixelsToFill = pixelsToFill;
			bytesTotalPool = [];
			bytesLoadedPool = [];
			loadingItemsPool = [];
			loadItems = [];
			loaded = 0;
			loadErrors = 0;
			_working = false;
			_library = new AssetLibrary();
			//addItems(items);
		}
		
		/**
		 * Add items to the controller to load. If the preloader is currently working,
		 * these items will be appended to the items to load.
		 * 
		 * @param	items	An array of Asset instances.
		 * 
		 * @see net.guttershark.preloading.Asset Asset class
		 */
		public function addItems(items:Array):void
		{ 
			if(!this.loadItems[0]) this.loadItems = items;
			else this.loadItems.concat(items);
			loadItemsDuplicate = this.loadItems.concat();
		}

		/**
		 * Starts loading the items in this preload controller. This is also used to resume
		 * a preload controller that had previously been stopped.
		 * 
		 * @see #stop() stop method
		 */
		public function start():void
		{
			if(!loadItems[0]) throw new Error("No items to load");
			_working = true;
			load();
		}
		
		/**
		 * Stops this preload controller from loading assets. 
		 * 
		 * <p>If there is a currently loading asset, it will finish first.</p>
		 * 
		 * <p>This does not completely destroy the controller, you can call
		 * start() and it will resume loading whatever assets were in the controller.</p>
		 * 
		 * <p>This does not purge the internal asset library.</p>
		 * 
		 * <p>The only way to destroy and reset a controller is by calling reset.</p>
		 * 
		 * @see #start() start method
		 * @see #reset() reset method
		 */
		public function stop():void
		{
			_working = false;
		}
		
		/**
		 * Returns a reference to the internal AssetLibrary used to save all loaded assets.
		 * 
		 * @see net.guttershark.preloading.AssetLibrary AssetLibrary class
		 * @return 	AssetLibrary 
		 */
		public function get library():AssetLibrary
		{
			return _library;
		}
		
		/**
		 * A boolean indicating whether or not this controller is doing any preloading.
		 */
		public function get working():Boolean
		{
			return _working;
		}
		
		/**
		 * Prioritize an asset.
		 * 
		 * @param	asset	An asset instance that is in the queue to be loaded.
		 */
		public function prioritize(asset:Asset):void
		{
			if(!asset) return;
			if(!asset.source || !asset.libraryName) throw new Error("Both a source and an id must be provided on the Asset to prioritize.");
			var l:int = loadItems.length;
			for(var i:int = 0; i < l; i++)
			{
				var item:Asset = Asset(loadItems[i]);
				if(item.source == asset.source)
				{
					var litem:Asset = loadItems.splice(i,1)[0] as Asset;
					loadItems.unshift(litem);
					return;
				}
			}
		}
		
		/**
		 * This method is recursively called to load each item in the queue.
		 */
		private function load():void
		{
			if(!_working) return;
			var item:Asset = Asset(this.loadItems.shift());
			currentItem = item;
			loadingItemsPool[item.source] = item;
			item.load(this);
		}
		
		/**
		 * @private
		 * 
		 * Every LoadItem in the queue calls this method on it's progress event.
		 * 
		 * @param	pe		AssetProgressEvent
		 */
		public function progress(pe:AssetProgressEvent):void
		{
			var item:Asset = Asset(pe.asset);
			var source:String = pe.asset.source;
			
			if(item.bytesTotal < 0 || isNaN(item.bytesTotal))
			{
				return;
			}
			else if(item.bytesLoaded < 0 || isNaN(item.bytesLoaded))
			{
				return;
			}
			
			if(!bytesTotalPool[source]) bytesTotalPool[source] = item.bytesTotal;
			bytesLoadedPool[source] = item.bytesLoaded;
			updateStatus();
		}
		
		/**
		 * Internal method used to send out updates.
		 */
		private function updateStatus():void
		{			
			var pixelPool:Number = 0;
			var pixelContributionPerItem:Number = totalPixelsToFill / (loadItemsDuplicate.length - loadErrors);
			var pixelUpdate:Number;
			var percentUpdate:Number;
			
			for(var key:String in loadingItemsPool)
			{
				var bl:* = bytesLoadedPool[key];
				var bt:* = bytesTotalPool[key];
				
				if(bl == undefined || bt == undefined)
				{
					continue;
				}
				var pixelsForItem:Number = Math.floor((bl / bt) * pixelContributionPerItem);
				//trace("update: key: " + key + " bl: " + bl.toString() + " bt: " + bt.toString() + " pixelsForItem: " + pixelsForItem);
				pixelPool += pixelsForItem;
			}
			
			pixelUpdate = pixelPool;
			percentUpdate = Math.floor((pixelPool / totalPixelsToFill) * 100);
			dispatchEvent(new PreloadProgressEvent(PreloadProgressEvent.PROGRESS, pixelUpdate, percentUpdate));
		}
		
		/**
		 * @private
		 * 
		 * Each item calls this method on it's complete.
		 * 
		 * @param	e	AssetCompleteEvent
		 */
		public function complete(e:AssetCompleteEvent):void
		{
			loaded++;
			_library.addAsset(e.asset.libraryName,e.asset.data);
			dispatchEvent(new AssetCompleteEvent(AssetCompleteEvent.COMPLETE,e.asset));
			updateStatus();
			updateLoading();
		}
		
		/**
		 * @private
		 * 
		 * Each item calls this method on any load errors.
		 * 
		 * @param	e	AssetErrorEvent
		 */
		public function error(e:AssetErrorEvent):void
		{
			loadErrors++;
			updateStatus();
			updateLoading();
			dispatchEvent(new AssetErrorEvent(AssetErrorEvent.ERROR,e.asset));
		}

		/**
		 * @private
		 * 
		 * Each item calls this method on an http status that is
		 * not 0 or 200.
		 * 
		 * @param	e	AssetStatusEvent
		 */
		public function httpStatus(e:AssetStatusEvent):void
		{			
			loadErrors++;
			updateStatus();
			updateLoading();
			dispatchEvent(new AssetStatusEvent(AssetStatusEvent.STATUS,e.asset,e.status));
		}

		/**
		 * @private
		 * 
		 * Each item calls this method when it starts downloading.
		 * 
		 * @param	e	AssetOpenEvent
		 */
		public function open(e:AssetOpenEvent):void
		{	
			dispatchEvent(new AssetOpenEvent(AssetOpenEvent.OPEN,e.asset));
		}

		/**
		 * This is used to check the status of this preloader.
		 */
		private function updateLoading():void
		{
			if(loadItems.length > 0)
			{
				load();
			}
			else if((loaded + loadErrors) >= (loadItems.length))
			{
				dispatchEvent(new PreloadProgressEvent(PreloadProgressEvent.PROGRESS,totalPixelsToFill,100));
				dispatchEvent(new Event(Event.COMPLETE));
				reset();
			}
		}
		
		/**
		 * Resets everything in this controller. Note that this will not purge the library. 
		 * 
		 * @see net.guttershark.preloading.AssetLibrary#purge() AssetLibrary purge function
		 */
		public function reset():void
		{
			loadErrors = 0;
			loaded = 0;
			loadItems = [];
			loadItemsDuplicate = [];
			currentItem = null;
		}
	}
}