package net.guttershark.support.eventmanager
{
	import flash.events.Event;
	
	import fl.controls.BaseButton;
	import fl.events.ComponentEvent;

	/**
	 * The BaseButtonEventListenerDelegate class is an IEventListenerDelegate that
	 * implements event listeners for the BaseButton Class. This is a composite
	 * object used in other IEventListenerDelegate classes. See the EventManager
	 * for a list of events supported.
	 */
	public class BaseButtonEventListenerDelegate extends EventListenerDelegate
	{

		/**
		 * @private
		 * Add listeners to the passed obj. Make sure to only add listeners
		 * to the obj if the (obj is MyClass).
		 */
		override public function addListeners(obj:*):void
		{
			super.addListeners(obj);
			if(obj is BaseButton)
			{
				obj.addEventListener(Event.CHANGE, onChange);
				obj.addEventListener(ComponentEvent.BUTTON_DOWN, onButtonDown);
			}
		}
		
		/**
		 * Dispose of this ButtonEventListenerDelegate instance. This is called
		 * from the EventManager.
		 */
		override public function dispose():void
		{
			super.dispose();
		}
		
		/**
		 * Remove event listeners addd to the object.
		 */
		override protected function removeEventListeners():void
		{
			super.removeEventListeners();
			obj.removeEventListener(Event.CHANGE, onChange);
			obj.removeEventListener(ComponentEvent.BUTTON_DOWN, onButtonDown);
		}
		
		private function onChange(e:Event):void
		{
			handleEvent(e,"Change");
		}
		
		private function onButtonDown(ce:ComponentEvent):void
		{
			handleEvent(ce,"ButtonDown");
		}
	}
}
