package net.guttershark.managers 
{
	import flash.events.EventDispatcher;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;
	
	import net.guttershark.util.Assertions;
	import net.guttershark.util.Singleton;	

	/**
	 * The ContextManager class simplifies creating and using context
	 * menus. And if you use this class for context menu creation, you
	 * can use the event manager to handle events.
	 */
	final public class ContextMenuManager extends EventDispatcher
	{

		/**
		 * Singleton instance.
		 */
		private static var inst:ContextMenuManager;
		
		/**
		 * A context menu lookup by it's id.
		 */
		private var menusById:Dictionary;
		
		/**
		 * An ids array lookup by the context menu.
		 */
		private var idsByMenu:Dictionary;
		
		/**
		 * A lookup for the itesm in a menu by the context menu and it's id.
		 */
		private var itemsByMenuAndId:Dictionary;
		
		/**
		 * A lookup for ids by an individual context menu item.
		 */
		private var idsByItems:Dictionary;
		
		/**
		 * A lookup for context menus by context menu items.
		 */
		private var menusByItems:Dictionary;
		
		/**
		 * An array of stored context menus.
		 */
		private var menus:Array;
		
		/**
		 * Assertions singleton.
		 */
		private var ast:Assertions;
		
		/**
		 * Singleton access.
		 */
		public static function gi():ContextMenuManager
		{
			if(!inst)inst=Singleton.gi(ContextMenuManager);
			return inst;
		}
		
		/**
		 * @private
		 */
		public function ContextMenuManager()
		{
			Singleton.assertSingle(ContextMenuManager);
			ast = Assertions.gi();
			menus=[];
			menusById=new Dictionary();
			idsByMenu=new Dictionary();
			itemsByMenuAndId = new Dictionary();
			idsByItems=new Dictionary();
			menusByItems=new Dictionary();
		}
		
		/**
		 * Create a new context menu.
		 * 
		 * @param id The id of the menu.
		 * @param items An array of objects used for the context menu
		 * items - {id:"home",label:"home",sep:true|false}.
		 */
		public function createMenu(id:String,items:Array):ContextMenu
		{
			ast.notNil(id,"Parameter {id} cannot be null");
			ast.notNilOrEmpty(items,"Paramaeter {items} cannot be null or empty");
			if(menusById[id])
			{
				trace("WARNING: A context menu already existed with that id, the previous one has been disposed and written over.");
				disposeMenu(id);
			}
			var cm:ContextMenu=new ContextMenu();
			cm.hideBuiltInItems();
			if(!itemsByMenuAndId[cm])itemsByMenuAndId[cm]=new Dictionary();
			if(!idsByMenu[cm])idsByMenu[cm]=[];
			menusById[id]=cm;
			menus.push(cm);
			var mu:Object;
			var cmi:ContextMenuItem;
			var itms:Array=[];
			var i:int=0;
			var l:int=items.length;
			var muid:String;
			var label:String;
			for(i;i<l;i++)
			{
				mu=items[i];
				muid=mu.id;
				if(muid.indexOf(" ")>-1) throw new Error("You cannot have spaces in id's for context menu's.");
				label=mu.label;
				if(muid)idsByMenu[cm].push(muid);
				if(!mu.sep)mu.sep=false;
				cmi=new ContextMenuItem(label,mu.sep);
				itms.push(cmi);
				itemsByMenuAndId[cm][muid]=cmi;
				idsByItems[cmi]=muid;
				menusByItems[cmi]=cm;
			}
			cm.customItems=itms;
			return cm;
		}
		
		/**
		 * Get a context menu that was previously registered.
		 * 
		 * @param id The menu id.
		 * @param itemClickHandler A event handler function for an item click from the menu - this is optional.
		 */
		public function getMenu(id:String):ContextMenu
		{
			ast.notNil(id,"Parameter {id} cannot be null");
			var cm:ContextMenu=menusById[id];
			if(!cm) return null;
			return cm;
		}
		
		/**
		 * @private
		 * for event manager use.
		 */
		public function getIdsForMenu(cm:ContextMenu):Array
		{
			return idsByMenu[cm];
		}
		
		/**
		 * @private
		 * For event manager use.
		 */
		public function getItemFromMenuByMenuAndId(cm:ContextMenu,id:String):ContextMenuItem
		{
			return itemsByMenuAndId[cm][id] as ContextMenuItem;
		}
		
		/**
		 * @private
		 * for event manager use.
		 */
		public function getIdFromMenuItem(cm:ContextMenuItem):String
		{
			return idsByItems[cm];
		}
		
		/**
		 * @private
		 * for event manager use.
		 */
		public function getMenuFromItem(cm:ContextMenuItem):ContextMenu
		{
			return menusByItems[cm];
		}

		/**
		 * @private
		 * Is a menu registered by the id.
		 */
		public function isIdRegistered(id:String):Boolean
		{
			return !(menusById[id]===false);
		}
		
		/**
		 * @private
		 * for event manager use.
		 */
		public function isMenuRegistered(cm:ContextMenu):Boolean
		{
			return !(idsByMenu[cm]===false);
		}

		/**
		 * Dispose of a context menu.
		 * 
		 * @param id The menu id.
		 */
		public function disposeMenu(id:String):void
		{
			// menus.splice(...)
			/*ast.notNil(id,"Parameter {id} cannot be null.");
			if(!menusById[id])return;
			var cm:ContextMenu=menusById[id];
			if(menuCallbacks[id])
			{
				var i:int=0;
				var l:int=menuCallbacks[id].length;
				for(i;i<l;i++)cm.removeEventListener(CContextMenuEvent.ITEM_CLICK,menuCallbacks[i]);
			}*/
		}	}}