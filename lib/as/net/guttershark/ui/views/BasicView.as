package net.guttershark.ui.views
{

	import flash.events.Event;	
	import flash.display.MovieClip;
	
	import net.guttershark.core.IDisposable;
	import net.guttershark.util.DisplayListUtils;
	
	/**
	 * The BasicView class provides common case functionality needed
	 * 90% of the time a "view" must be implemented.
	 * 
	 * <p>The common functionality:</p>
	 * <ul>
	 * <li>Wait to initialize the clip until it's added to the stage.</li>
	 * <li>Initiate the clip on add to stage.</li>
	 * <li>Add event listeners on children objects.</li>
	 * <li>Perform cleanup when removed from stage.</li>
	 * </ul>
	 * 
	 * <p>The init method is the last step in the setup chain for a view, 
	 * this should be used to continue initializing a view, like changing
	 * visibility / alpha on children properties, etc.</p>
	 * 
	 * <p>The cleanup method should be overwritten as well. The cleanup method
	 * is called when the clip is removed from the stage. This is not 
	 * supposed to replace <code>dispose()</code>, it's for "off the display list"
	 * cleanup.</p>
	 * 
	 * <p>Override the dispose mothod for complete dispose logic, the cleanup
	 * method should be implemented to have temporary "not in display list"
	 * cleanup code.</p>
	 */
	public class BasicView extends MovieClip implements IDisposable
	{

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
		}

		/**
		 * on add handler.
		 */
		private function onAdd(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			addedToStage();
			addListeners();
		}
		
		/**
		 * on removed handler.
		 */
		private function onRemoved(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			removedFromStage();
			removeListeners();
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
			init();
		}
		
		/**
		 * Override this method to hook into the removed from stage event.
		 */
		protected function removedFromStage():void
		{
			cleanup();
		}
		
		/**
		 * The init method is the final method after initial setup stage listeners
		 * and other logic is complete. Override this and provide you're own
		 * custom children initialization logic.
		 */
		protected function init():void{}
		
		/**
		 * The addListeners method is a stub method you should override 
		 * and use for adding event listeners onto children objects. This is
		 * called after the clip has been added to the stage, so the
		 * stage property is always available.
		 * 
		 * <p>This method also implements logic for the stage resize event
		 * so make sure to call super.addListeners() if you need the resize
		 * events to work correctly.</p>
		 */
		protected function addListeners():void
		{
			if(stage) stage.addEventListener(Event.RESIZE, onResize);
		}
		
		/**
		 * The removeListeners method is a stub method you should override 
		 * and use for removing event listeners from children objects. This is
		 * called after the clip has been removed from the stage.
		 */
		protected function removeListeners():void{}
		
		/**
		 * Override this method to hook into resize events from the stage.
		 */
		protected function resized():void{}
		
		/**
		 * The cleanup method is called after the clip has been removed from
		 * the display list. This is intended to do temporary cleanup until the clip
		 * is added back to the display list. Not for final disposing logic. See
		 * the dispose method for final disposal.
		 */
		protected function cleanup():void{}
		
		/**
		 * Override this method and write your own dispose logic.
		 */
		public function dispose():void{}
		
		/**
		 * Stub method for showing this view. It sets the visible property to true.
		 */
		public function show():void
		{
			visible = true;
		}
		
		/**
		 * Stub method for hiding this view. It sets the visible property to false.
		 */
		public function hide():void
		{
			visible = false;
		}
		
		/**
		 * Stub method you should override to re-arrange children on the display
		 * list. This is in place for naming convention.
		 */
		public function reorderChildren():void{}
		
		/**
		 * Remove all children from this instance.
		 */
		public function removeAllChildren():void
		{
			DisplayListUtils.RemoveAllChildren(this);
		}
	}
}
