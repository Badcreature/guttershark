package net.guttershark.util.events.manager
{
	import fl.controls.DataGrid;
	import fl.controls.SelectableList;
	import fl.core.UIComponent;
	import fl.events.DataGridEvent;
	
	/**
	 * The DataGridEventlistenerDelegate class is an IEventListenerDelegate that
	 * implements event listener logic for DataGrid components. See EventManager
	 * for a list of supported events.
	 */
	public class DataGridEventListenerDelegate extends EventListenerDelegate
	{

		/**
		 * Composite object for UIComponent event delegation.
		 */
		private var uic:UIComponentEventListenerDelegate;
		
		/**
		 * Composite object for SelectableList events.
		 */
		private var sl:SelectableListEventListenerDelegate;

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
			
			if(obj is SelectableList)
			{
				sl = new SelectableListEventListenerDelegate();
				sl.eventHandlerFunction = this.handleEvent;
				sl.addListeners(obj);
			}
			
			if(obj is DataGrid)
			{
				obj.addEventListener(DataGridEvent.COLUMN_STRETCH, onColumnStretch);
				obj.addEventListener(DataGridEvent.HEADER_RELEASE, onHeaderRelease);
				obj.addEventListener(DataGridEvent.ITEM_EDIT_BEGIN, onItemEditBegin);
				obj.addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING, onItemEditBeginning);
				obj.addEventListener(DataGridEvent.ITEM_EDIT_END, onItemEditEnd);
				obj.addEventListener(DataGridEvent.ITEM_FOCUS_IN, onItemFocusIn);
				obj.addEventListener(DataGridEvent.ITEM_FOCUS_OUT, onItemFocusOut);
			}
		}
		
		private function onItemFocusOut(dge:DataGridEvent):void
		{
			handleEvent(dge,"ItemFocusOut");
		}
		
		private function onItemFocusIn(dge:DataGridEvent):void
		{
			handleEvent(dge,"ItemFocusIn");
		}
		
		private function onItemEditEnd(dge:DataGridEvent):void
		{
			handleEvent(dge,"ItemEditEnd");
		}
		
		private function onItemEditBeginning(dge:DataGridEvent):void
		{
			handleEvent(dge,"ItemEditBeginning");
		}
		
		private function onItemEditBegin(dge:DataGridEvent):void
		{
			handleEvent(dge,"ItemEditBegin");
		}
		
		private function onHeaderRelease(dge:DataGridEvent):void
		{
			handleEvent(dge,"HeaderRelease");
		}
		
		private function onColumnStretch(dge:DataGridEvent):void
		{
			handleEvent(dge,"ColumnStretch");
		}

		/**
		 * Dispose of this ColorPickerEventListenerDelegate.
		 */
		override public function dispose():void
		{
			super.dispose();
			if(uic) uic.dispose();
			if(sl) sl.dispose();
			uic = null;
			sl = null;
		}
		
		/**
		 * Removes events that were added to the object.
		 */
		override protected function removeEventListeners():void
		{
			obj.removeEventListener(DataGridEvent.COLUMN_STRETCH, onColumnStretch);
			obj.removeEventListener(DataGridEvent.HEADER_RELEASE, onHeaderRelease);
			obj.removeEventListener(DataGridEvent.ITEM_EDIT_BEGIN, onItemEditBegin);
			obj.removeEventListener(DataGridEvent.ITEM_EDIT_BEGINNING, onItemEditBeginning);
			obj.removeEventListener(DataGridEvent.ITEM_EDIT_END, onItemEditEnd);
			obj.removeEventListener(DataGridEvent.ITEM_FOCUS_IN, onItemFocusIn);
			obj.removeEventListener(DataGridEvent.ITEM_FOCUS_OUT, onItemFocusOut);
		}
	}
}
