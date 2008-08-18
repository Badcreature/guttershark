package net.guttershark.preloading
{
	import net.guttershark.util.Assert;	
	
	import flash.events.SecurityErrorEvent;
	
	import net.guttershark.core.IDisposable;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.preloading.events.AssetCompleteEvent;
	import net.guttershark.preloading.events.AssetErrorEvent;
	import net.guttershark.preloading.events.AssetOpenEvent;
	import net.guttershark.preloading.events.AssetProgressEvent;
	import net.guttershark.preloading.events.AssetStatusEvent;
	import net.guttershark.preloading.workers.WorkerInstances;
	import net.guttershark.util.StringUtils;	

	/**
	 * The Asset class defines an asset to preload with a PreloadController.
	 * 
	 * @see net.guttershark.preloading.PreloadController PreloadController class
	 * @see net.guttershark.preloading.AssetLibrary AssetLibrary class
	 */
	public class Asset implements IDisposable
	{

		/**
		 * The controller that receives updates from this item.
		 */
		private var controller:PreloadController;

		/**
		 * The worker that is doing the loading work.
		 */
		private var worker:*;
		
		/**
		 * The file type of this asset. This will be a file extension less the period (jpg).
		 */
		public var fileType:String;
		
		/**
		 * An asset type indicator - value is an enumeration
		 * from the AssetTypes class.
		 * 
		 * @see net.guttershark.preloading.AssetTypes AssetTypes Class
		 */
		public var assetType:String;
		
		/**
		 * The URI to the file to load.
		 */
		public var source:String;
		
		/**
		 * The identifier to use in an AssetLibrary.
		 * 
		 * @see net.guttershark.preloading.AssetLibrary
		 */
		public var libraryName:String;
		
		/**
		 * The data for this asset after the asset has been loaded. 
		 * 
		 * <p>This will be a reference to the loader that was used
		 * in loading the data.</p>
		 */
		public var data:*;
		
		/**
		 * Constructor for Asset instances.
		 * 
		 * @param	source 			The source URL to the asset
		 * @param	libraryName 	The name to be used in an AssetLibrary
		 * @param	forceFileType	Force the asset's file type (file extension without the ".", EX: xml);
		 * @param	forceAssetType	Force the asset's type identifier
		 * @throws	Error 			If the filetype couldn't be figured out from the source property.
		 */
		public function Asset(source:String, libraryName:String = null, forceFileType:String = null, forceAssetType:String = null)
		{
			if(forceFileType && !forceAssetType) throw new Error("Both forceFileType && forceAssetType must be set when forcing asset types");
			if(!forceFileType)
			{
				var fileType:String = StringUtils.FindFileType(source);
				if(!fileType) throw new Error("The filetype could not be found for this item: " + source);
				this.fileType = fileType;
			}
			else this.fileType = forceFileType;
			if(!forceAssetType) assetType = Asset.AssetTypeFromSource(source);
			else assetType = forceAssetType;
			this.source = source;
			if(!libraryName)
			{
				trace("WARNING: No library name was supplied for asset with source {"+source+"} using the source as the libraryName");
				this.libraryName = source;
			}
			else this.libraryName = libraryName;
		}
		
		/**
		 * Returns the enumerated value from AssetType found from the filename of the asset. This
		 * is used in a couple places where there is switch to append/prepend
		 * paths based on type before the actual asset is created.
		 */
		public static function AssetTypeFromSource(filename:String):String
		{
			var t:String = StringUtils.FindFileType(filename);
			var at:String;
			switch(t)
			{
				case "jpg":
				case "jpeg":
				case "png":
				case "gif":
				case "bmp":
					at = AssetTypes.BITMAP;
					break;
				case "swf":
					at = AssetTypes.SWF;
					break;
				case "mp3":
				case "wav":
				case "aiff":
					at = AssetTypes.SOUND;
					break;
				case "flv":
					at = AssetTypes.VIDEO;
					break;
			}
			return at;
		}

		/**
		 * @private
		 * 
		 * Starts the load process for this item.
		 * 
		 * @param	A preload controller that is controller this asset.
		 */
		public function load(controller:PreloadController):void
		{
			this.controller = controller;
			worker = WorkerInstances.GetWorkerInstance(fileType);
			addListenersToWorker();
			worker.load(this);
		}
		
		/**
		 * removes listeners
		 */
		private function removeListenersFromWorker():void
		{
			worker.removeEventListener(AssetCompleteEvent.COMPLETE,onComplete);
			worker.removeEventListener(AssetProgressEvent.PROGRESS, controller.progress);
			worker.removeEventListener(AssetErrorEvent.ERROR, onError);
			worker.removeEventListener(AssetOpenEvent.OPEN, controller.open);
			worker.removeEventListener(AssetStatusEvent.STATUS, onHTTPStatus);
			worker.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		/**
		 * adds listeners
		 */
		private function addListenersToWorker():void
		{
			worker.addEventListener(AssetCompleteEvent.COMPLETE,onComplete);
			worker.addEventListener(AssetProgressEvent.PROGRESS, controller.progress);
			worker.addEventListener(AssetErrorEvent.ERROR, onError);
			worker.addEventListener(AssetOpenEvent.OPEN, controller.open);
			worker.addEventListener(AssetStatusEvent.STATUS, onHTTPStatus);
			worker.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		private function onComplete(e:AssetCompleteEvent):void
		{
			controller.complete(e);
			worker.dispose();
			controller = null;
			worker = null;
		}
		
		private function onError(e:AssetErrorEvent):void
		{
			if(!controller) return;
			worker.dispose();
			worker = null;
			controller.error(e);
			controller = null;
		}
		
		private function onHTTPStatus(h:AssetStatusEvent):void
		{
			if(!controller) return;
			worker.dispose();
			worker = null;
			controller.httpStatus(h);
			controller = null;
			worker = null;
		}
		
		/**
		 * Handles security error, the controller doesn't specifically handle it.
		 */
		private function onSecurityError(se:SecurityError):void
		{
			worker.dispose();
			worker = null;
			throw se;
		}
		
		/**
		 * @private
		 * 
		 * Returns the bytes loaded for this item.
		 * 
		 * @return Number
		 */
		public function get bytesLoaded():Number
		{
			return worker.bytesLoaded;
		}
		
		/**
		 * @private
		 * 
		 * Returns the bytes total for this item.
		 * 
		 * @return Number
		 */
		public function get bytesTotal():Number
		{
			return worker.bytesTotal;
		}
		
		/**
		 * The dispose method only disposes of unused properties
		 * after the asset is complete / errored out, to completely
		 * dispose of the Asset, use <em><code>disposeFinal</code></em>
		 */
		public function dispose():void
		{
			removeListenersFromWorker();
			worker.dispose();
			worker = null;
			controller = null;
		}
		
		/**
		 * Disposes of the Asset entirely and disposes it out of
		 * the Asset library as well.
		 */
		public function disposeFinal():void
		{
			AssetLibrary.gi().removeAsset(libraryName);
			removeListenersFromWorker();
			worker.dispose();
			libraryName = null;
			fileType = null;
			controller = null;
			worker = null;
		}
	}
}