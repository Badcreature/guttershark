package net.guttershark.events.delegates 
{
	import net.guttershark.preloading.events.AssetCompleteEvent;	
	
	import flash.events.Event;
	
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.preloading.events.PreloadProgressEvent;	

	/**
	 * The PreloadControllerEventListenerDelegate class is an IEventListenerDelegate class
	 * that implements event listening on a PreloadController instance.
	 * 
	 * @example Adding support to the EventManager:
	 * <listing>	
	 * var em:EventManager = EventManager.gi();
	 * e.addEventListenerDelegate(PreloadController,PreloadControllerEventListenerDelegate);
	 * em.handleEvents(myPreloadController,this,"onPC");
	 * </listing>
	 */
	public class PreloadControllerEventListenerDelegate extends EventListenerDelegate
	{
		
		/**
		 * @private
		 * Add listeners to the obj.
		 */
		override public function addListeners(obj:*):void
		{
			super.addListeners(obj);
			if(obj is PreloadController)
			{
				if(((callbackPrefix + "Progress") in callbackDelegate)) obj.addEventListener(PreloadProgressEvent.PROGRESS, onProgress, false, 0, true);
				if(((callbackPrefix + "Complete") in callbackDelegate) || cycleAllThroughTracking) obj.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
				if(((callbackPrefix + "AssetComplete") in callbackDelegate) || cycleAllThroughTracking) obj.addEventListener(AssetCompleteEvent.COMPLETE, onAssetComplete, false, 0, true);
			}
		}
		
		/**
		 * @private
		 */
		override public function dispose():void
		{
			super.dispose();
			obj = null;
		}
		
		/**
		 * @private
		 */
		override protected function removeEventListeners():void
		{
			if(((callbackPrefix + "Progress") in callbackDelegate) || cycleAllThroughTracking) obj.removeEventListener(PreloadProgressEvent.PROGRESS, onProgress);
			if(((callbackPrefix + "Complete") in callbackDelegate) || cycleAllThroughTracking) obj.removeEventListener(Event.COMPLETE, onComplete);
			if(((callbackPrefix + "AssetComplete") in callbackDelegate) || cycleAllThroughTracking) obj.removeEventListener(AssetCompleteEvent.COMPLETE, onAssetComplete);
		}
		
		private function onAssetComplete(ace:AssetCompleteEvent):void
		{
			handleEvent(ace,"AssetComplete",true);
		}

		private function onProgress(pe:PreloadProgressEvent):void
		{
			handleEvent(pe,"Progress",true);
		}
		
		private function onComplete(e:*):void
		{
			handleEvent(e,"Complete");
		}
	}}