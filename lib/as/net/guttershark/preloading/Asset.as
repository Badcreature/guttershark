package net.guttershark.preloading
{

	import flash.events.SecurityErrorEvent;
	
	import net.guttershark.preloading.events.AssetCompleteEvent;
	import net.guttershark.preloading.events.AssetErrorEvent;
	import net.guttershark.preloading.events.AssetOpenEvent;
	import net.guttershark.preloading.events.AssetProgressEvent;
	import net.guttershark.preloading.events.AssetStatusEvent;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.preloading.workers.WorkerInstances;
	import net.guttershark.util.StringUtils;

	/**
	 * The Asset class defines an asset to preload with a PreloadController.
	 * 
	 * @see net.guttershark.preloading.PreloadController PreloadController class
	 * @see net.guttershark.preloading.AssetLibrary AssetLibrary class
	 */
	public class Asset
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
		 * @throws	Error 			If the filetype couldn't be figured out from the source property.
		 */
		public function Asset(source:String, libraryName:String = null, forceAssetType:String = null)
		{
			if(!forceAssetType)
			{
				var fileType:String = StringUtils.FindFileType(source);
				if(!fileType) throw new Error("The filetype could not be found for this item: " + source);
				this.fileType = fileType;
			}
			else this.fileType = forceAssetType;
			this.source = source;
			if(!libraryName) this.libraryName= source;
			else this.libraryName = libraryName;
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
			worker.addEventListener(AssetCompleteEvent.COMPLETE, onComplete);
			worker.addEventListener(AssetProgressEvent.PROGRESS, controller.progress);
			worker.addEventListener(AssetErrorEvent.ERROR, onError);
			worker.addEventListener(AssetOpenEvent.OPEN, controller.open);
			worker.addEventListener(AssetStatusEvent.STATUS, onHTTPStatus);
			worker.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			worker.load(this);
		}
		
		private function onComplete(e:AssetCompleteEvent):void
		{
			controller.complete(e);
			worker.close();
			controller = null;
			worker = null;
		}
		
		private function onError(e:AssetErrorEvent):void
		{
			if(!controller) return;
			controller.error(e);
			controller = null;
			worker = null;
		}
		
		private function onHTTPStatus(h:AssetStatusEvent):void
		{
			if(!controller) return;
			controller.httpStatus(h);
			controller = null;
			worker = null;
		}
		
		/**
		 * Handles security error, the controller doesn't specifically handle it.
		 */
		private function onSecurityError(se:SecurityError):void
		{
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
	}
}