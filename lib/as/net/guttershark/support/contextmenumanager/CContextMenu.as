package net.guttershark.support.contextmenumanager 
{
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;		

	/**
	 * The CContextMenu class is an extension of context menu
	 * that supports the context menu manager, and dispatches
	 * custom events that contain more properties about
	 * the item clicked, and enables the menus to be used
	 * with the event manager.
	 */
	public class CContextMenu extends EventDispatcher
	{

		/**
		 * @private
		 * The ids for all items in the list.
		 */
		public var ids:Array;
		
		/**
		 * @private
		 * The menu items - An array of objects.
		 */
		public var items:Array;
		
		/**
		 * The internal context menu.
		 */
		public var contextMenu:ContextMenu;

		/**
		 * A lookup for label's to ids'
		 */
		private var labelsToIds:Dictionary;

		/**
		 * Constructor for CContextMenu instances.
		 * 
		 * @param menuItems An array of objects to use as items - {id:"home",label:"home",sep:true|false}
		 */
		public function CContextMenu(menuItems:Array)
		{
			super();
			contextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			ids=[];
			items=menuItems;
			labelsToIds=new Dictionary();
			var mu:Object;
			var cmi:ContextMenuItem;
			var itms:Array=[];
			var i:int=0;
			var l:int=menuItems.length;
			for(i;i<l;i++)
			{
				mu=menuItems[i];
				labelsToIds[mu.label]=mu.id;
				if(mu.id)ids.push(mu.id);
				if(!mu.sep)mu.sep=false;
				cmi=new ContextMenuItem(mu.label,mu.sep);
				cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,onMenuItemSelect,false,0,true);
				itms.push(cmi);
			}
			contextMenu.customItems=itms;
		}
		
		/**
		 * On a menu item select.
		 */
		private function onMenuItemSelect(c:ContextMenuEvent):void
		{
			var label:String=c.target.caption;
			var id:String=labelsToIds[label];
			dispatchEvent(new CContextMenuEvent(CContextMenuEvent.ITEM_CLICK,id,label));
			dispatchEvent(new Event(id)); //for event manager.
		}

		/**
		 * @private
		 * For event manager use.
		 */
		public function getIds():Array
		{
			return ids;
		}
		
		/**
		 * Dispose of this CContextMenu.
		 */
		public function dispose():void
		{
			ids=null;
			labelsToIds=null;
			items=null;
			customItems=null;
		}	}}