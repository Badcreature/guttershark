package net.guttershark.display.views
{
	import flash.events.Event;
	
	import net.guttershark.display.CoreClip;	

	/**
	 * The BasicView class provides hooks into a number of different
	 * events that occur from a DisplayObject - there is a particular
	 * order of events that occur, which allows you to override
	 * certain methods to hook in to specific times.
	 */
	public class BasicView extends CoreClip
	{

		private var addr:Boolean;

		/**
		 * Constructor for BasicView instances.
		 */
		public function BasicView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			addEventListener(Event.ACTIVATE, onActivated);
			addEventListener(Event.DEACTIVATE, onDeactive);
			init();
		}

		/**
		 * Initialize the BasicView.
		 */
		protected function init():void{}

		/**
		 * on add handler.
		 */
		private function onAdd(e:Event):void
		{
			if(stage && !addr)
			{
				stage.addEventListener(Event.RESIZE, onResize);
				addr = true;
			}
			addedToStage();
		}
		
		/**
		 * on removed handler.
		 */
		private function onRemoved(e:Event):void
		{
			removedFromStage();
		}
		
		/**
		 * When the flash player loses operating system focus.
		 */
		private function onDeactive(e:Event):void
		{
			deactivated();
		}
		
		/**
		 * When the flash player gains operating system focus.
		 */
		private function onActivated(e:Event):void
		{
			activated();
		}
		
		/**
		 * The resize handler.
		 */
		private function onResize(e:Event):void
		{
			resized();
		}
		
		/**
		 * Override this method to hook into resize events from the stage.
		 */
		protected function resized():void{}
		
		/**
		 * Override this method to hook into when the operating system loses focus
		 * on the flash movie.
		 */
		protected function deactivated():void{}
		
		/**
		 * Override this method to hook into when the operating system gains focus
		 * on the flash movie.
		 */
		protected function activated():void{}
		
		/**
		 * Override this method to hook into the added to stage event.
		 */
		protected function addedToStage():void
		{
			addListeners();
			resized();
		}
		
		/**
		 * Override this method to hook into the removed from stage event.
		 */
		protected function removedFromStage():void
		{
			removeListeners();
			cleanup();
		}
		
		/**
		 * The addListeners method is a stub method you should override 
		 * and use for adding event listeners onto children objects. This is
		 * called after the clip has been added to the stage, so the
		 * stage property is always available.
		 */
		protected function addListeners():void{}
		
		/**
		 * The removeListeners method is a stub method you should override 
		 * and use for removing event listeners from children objects. This is
		 * called after the clip has been removed from the stage.
		 */
		protected function removeListeners():void{}
		
		/**
		 * Stub method for showing this view - it sets the visible property to true.
		 */
		public function show():void
		{
			visible = true;
		}
		
		/**
		 * Stub method for hiding this view - it sets the visible property to false.
		 */
		public function hide():void
		{
			visible = false;
		}
		
		/**
		 * The cleanup method is called after the clip has been removed from
		 * the display list. This is intended to do temporary cleanup until the clip
		 * is added back to the display list. Not for final disposing logic - see
		 * the dispose method for final disposal.
		 */
		protected function cleanup():void{}
		
		/**
		 * Override this method and write your own dispose logic.
		 */
		override public function dispose():void{}
	}
}