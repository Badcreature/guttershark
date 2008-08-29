package net.guttershark.util.events.manager
{
	import flash.events.Event;
	
	import fl.controls.ComboBox;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	import fl.events.ListEvent;
	import fl.events.ScrollEvent;
	
	/**
	 * The ComboBoxEventListenerDelegate class is an IEventListenerDelegate that
	 * implements event listener logic for ComboBox components. See EventManager
	 * for a list of supported events.
	 */
	public class ComboBoxEventListenerDelegate extends EventListenerDelegate
	{

		/**
		 * Composite object for UIComponent event delegation.
		 */
		private var uic:UIComponentEventListenerDelegate;
		
		/**
		 * Add listeners to the object.
		 */
		override public function addListeners(obj:*):void
		{
			super.addListeners(obj);
			if(obj is UIComponent)
			{
				uic = new UIComponentEventListenerDelegate();
				uic.eventHandlerFunction = this.handleEvent;
				uic.addListeners(obj);
			}
			
			if(obj is ComboBox)
			{
				obj.addEventListener(Event.CHANGE, onChange);
				obj.addEventListener(Event.CLOSE, onClose);
				obj.addEventListener(Event.OPEN, onOpen);
				obj.addEventListener(ComponentEvent.ENTER, onEnter);
				obj.addEventListener(ListEvent.ITEM_ROLL_OUT, onItemRollOut);
				obj.addEventListener(ListEvent.ITEM_ROLL_OVER, onItemRollOver);
				obj.addEventListener(ScrollEvent.SCROLL, onScroll);
			}
		}
		
		private function onScroll(se:ScrollEvent):void
		{
			handleEvent(se,"Scroll",true);
		}

		private function onClose(e:Event):void
		{
			handleEvent(e,"Close");
		}

		private function onOpen(cp:Event):void
		{
			handleEvent(cp,"Open");
		}
		
		private function onEnter(cp:ComponentEvent):void
		{
			handleEvent(cp,"Enter");
		}
		
		private function onItemRollOut(cp:ListEvent):void
		{
			handleEvent(cp,"ItemRollOut");
		}
		
		private function onItemRollOver(cp:ListEvent):void
		{
			handleEvent(cp,"ItemRollOver");
		}
		
		private function onChange(cp:Event):void
		{
			handleEvent(cp,"Change");
		}

		/**
		 * Dispose of this ColorPickerEventListenerDelegate.
		 */
		override public function dispose():void
		{
			super.dispose();
			if(uic) uic.dispose();
			uic = null;
		}
		
		/**
		 * Removes events that were added to the object.
		 */
		override protected function removeEventListeners():void
		{
			obj.removeEventListener(Event.CHANGE, onChange);
			obj.removeEventListener(Event.CLOSE, onClose);
			obj.removeEventListener(Event.OPEN, onOpen);
			obj.removeEventListener(ComponentEvent.ENTER, onEnter);
			obj.removeEventListener(ListEvent.ITEM_ROLL_OUT, onItemRollOut);
			obj.removeEventListener(ListEvent.ITEM_ROLL_OVER, onItemRollOver);
			obj.removeEventListener(ScrollEvent.SCROLL, onScroll);
		}
	}
}
