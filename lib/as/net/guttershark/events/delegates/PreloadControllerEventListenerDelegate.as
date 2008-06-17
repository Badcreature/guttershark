package net.guttershark.events.delegates 
{
	
	import flash.events.Event;	
	
	import net.guttershark.preloading.events.PreloadProgressEvent;
	import net.guttershark.preloading.PreloadController;
	
	/**
	 * The PreloadControllerEventListenerDelegate class is an IEventListenerDelegate class
	 * that implements event listening on a PreloadController instance.
	 * 
	 * @example Adding support to the EventManager:
	 * <listing>	
	 * var em:EventManager = EventManager.gi();
	 * e.addEventListenerDelegate(PreloadController,PreloadControllerEventListenerDelegate);
	 * em.handleEvents(myPreloadController,this,"onPC",EventTypes.CUSTOM);
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
				obj.addEventListener(PreloadProgressEvent.PROGRESS, onProgress, false, 0, true);
				obj.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
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
			obj.removeEventListener(PreloadProgressEvent.PROGRESS, onProgress);
			obj.removeEventListener(Event.COMPLETE, onComplete);
		}

		private function onProgress(pe:PreloadProgressEvent):void
		{
			handleEvent(pe,"PreloadProgress",true);
		}
		
		private function onComplete(e:*):void
		{
			handleEvent(e,"Complete");
		}
	}}