package net.guttershark.support.eventmanager
{
	import flash.events.Event;
	
	import fl.controls.ColorPicker;
	import fl.core.UIComponent;
	import fl.events.ColorPickerEvent;
	
	/**
	 * The ColorPickerEventListenerDelegate class is an IEventListenerDelegate that
	 * implements event listener logic for ColorPicker components. See EventManager
	 * for a list of supported events.
	 */
	public class ColorPickerEventListenerDelegate extends EventListenerDelegate
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
			
			if(obj is ColorPicker)
			{
				obj.addEventListener(ColorPickerEvent.CHANGE, onChange);
				obj.addEventListener(ColorPickerEvent.ENTER, onEnter);
				obj.addEventListener(ColorPickerEvent.ITEM_ROLL_OUT, onItemRollOut);
				obj.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER, onItemRollOver);
				obj.addEventListener(Event.OPEN, onOpen);
			}
		}
		
		private function onOpen(cp:ColorPickerEvent):void
		{
			handleEvent(cp,"Open");
		}
		
		private function onEnter(cp:ColorPickerEvent):void
		{
			handleEvent(cp,"Enter");
		}
		
		private function onItemRollOut(cp:ColorPickerEvent):void
		{
			handleEvent(cp,"ItemRollOut");
		}
		
		private function onItemRollOver(cp:ColorPickerEvent):void
		{
			handleEvent(cp,"ItemRollOver");
		}
		
		private function onChange(cp:ColorPickerEvent):void
		{
			handleEvent(cp,"Change",true);
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
			obj.removeEventListener(ColorPickerEvent.CHANGE, onChange);
			obj.removeEventListener(ColorPickerEvent.ENTER, onEnter);
			obj.removeEventListener(ColorPickerEvent.ITEM_ROLL_OUT, onItemRollOut);
			obj.removeEventListener(ColorPickerEvent.ITEM_ROLL_OVER, onItemRollOver);
			obj.removeEventListener(Event.OPEN, onOpen);
		}
	}}