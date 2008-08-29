package net.guttershark.events.delegates.components.composites 
{

	import fl.events.ListEvent;
	import fl.controls.SelectableList;
	import flash.events.Event;
	
	import net.guttershark.events.delegates.EventListenerDelegate;	
	
	/**
	 * The SelectableListEventListenerDelegate class is an IEventListenerDelgate class
	 * that implements event listeners for a SelectableList. This is a composite
	 * class used with other concrete IEventListenerDelegate classes. An example of usage
	 * would be in the DataGridEventListenerDelegate class.
	 */
	public class SelectableListEventListenerDelegate extends EventListenerDelegate 
	{
		
		/**
		 * Add listeners to the obj.
		 */
		override public function addListeners(obj:*):void
		{
			super.addListeners(obj);
			if(obj is SelectableList)
			{
				obj.addEventListener(Event.CHANGE, onChange);
				obj.addEventListener(ListEvent.ITEM_CLICK, onItemClick);
				obj.addEventlistener(ListEvent.ITEM_DOUBLE_CLICK, onItemDoubleClick);
				obj.addEventListener(ListEvent.ITEM_ROLL_OUT, onRollOut);
				obj.addEventlistener(ListEvent.ITEM_ROLL_OVER, onRollOver);
			}
		}
		
		/**
		 * Remove event listeners added to the object.
		 */
		override protected function removeEventListeners():void
		{
			obj.removeEventListener(Event.CHANGE, onChange);
			obj.removeEventListener(ListEvent.ITEM_CLICK, onItemClick);
			obj.removeEventListener(ListEvent.ITEM_DOUBLE_CLICK, onItemDoubleClick);
			obj.removeEventListener(ListEvent.ITEM_ROLL_OUT, onRollOut);
			obj.removeEventListener(ListEvent.ITEM_ROLL_OVER, onRollOver);
		}
		
		private function onChange(e:Event):void
		{
			handleEvent(e,"Change");
		}
		
		private function onItemClick(le:ListEvent):void
		{
			handleEvent(le,"ItemClick");
		}
		
		private function onItemDoubleClick(le:ListEvent):void
		{
			handleEvent(le,"ItemDoubleClick");
		}
		
		private function onRollOut(le:ListEvent):void
		{
			handleEvent(le,"ItemRollOut");
		}
		
		private function onRollOver(le:ListEvent):void
		{
			handleEvent(le,"ItemRollOver");
		}	}}