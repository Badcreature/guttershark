package net.guttershark.util.events.manager
{
	import fl.controls.LabelButton;
	import fl.events.ComponentEvent;
	
	/**
	 * The LabelButtonEventListenerDelegate is a composite object used
	 * when a Component inherits events from the LabelButton class. An example
	 * of it's use is in ButtonEventListenerDelegate.
	 */
	public class LabelButtonEventListenerDelegate extends EventListenerDelegate 
	{

		/**
		 * Add listeners to the passed obj. Make sure to only add listeners
		 * to the obj if the (obj is MyClass).
		 */
		override public function addListeners(obj:*):void
		{
			super.addListeners(obj);
			if(obj is LabelButton)
			{
				obj.addEventListener(ComponentEvent.LABEL_CHANGE, onLabelChange);
			}
		}
		
		/**
		 * Dispose of this LabelButtonEventListenerDelegate;
		 */
		override public function dispose():void
		{
			super.dispose();
		}
		
		/**
		 * Remove event listeners from the object.
		 */
		override protected function removeEventListeners():void
		{
			obj.removeEventListener(ComponentEvent.LABEL_CHANGE,onLabelChange);
		}

		private function onLabelChange(ce:ComponentEvent):void
		{
			handleEvent(ce,"LabelChange",true);
		}	}}