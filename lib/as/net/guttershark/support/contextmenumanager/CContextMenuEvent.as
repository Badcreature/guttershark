package net.guttershark.support.contextmenumanager 
{
	import flash.events.ContextMenuEvent;	
	
	/**
	 * The CContextMenuEvent class is dispatched from
	 * an CContextMenu instance, specifically to wrap
	 * up the id and label property.
	 */
	final public class CContextMenuEvent extends ContextMenuEvent 
	{
		
		/**
		 * Context menu item click.
		 */
		public static const ITEM_CLICK:String="menuItemClick";
		
		/**
		 * The id of the item clicked.
		 */
		public var id:String;
		
		/**
		 * The label of the item clicked.
		 */
		public var label:String;
		
		/**
		 * Constructor for CCOntextMenuEvent instances.
		 * 
		 * @param type The event type.
		 * @param id The clicked items' id.
		 * @param label The cliekd items' label.
		 */
		public function CContextMenuEvent(type:String,id:String,label:String)
		{
			super(type,false,false);
			this.id=id;
			this.label=label;
		}	}}