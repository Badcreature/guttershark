package net.guttershark.ui.views
{
	import flash.events.Event;
	
	import net.guttershark.core.CoreClip;
	import net.guttershark.core.IDisposable;
	import net.guttershark.util.DisplayListUtils;		

	/**
	 * The BasicView Class provides hooks into a number of different
	 * events that occur from a DisplayObject. There is a particular
	 * order of events that occur, which allows you to override
	 * certain methods to hook in to specific times.
	 * 
	 * <p>Order of events:</p>
	 * <ul>
	 * <li>1. Adds listeners to addedToStage, removedFromStage, resize, deactive, activate.</li>
	 * <li>2. init() - Called from the constructor. (do not reference the <em><code>stage</code></em> property in this method, you will get exceptions as the display object is not on the stage.)</li>
	 * </ul>
	 * 
	 * <p>Override the provided methods to hook into the events being listened too.</p>
	 */
	public class BasicView extends CoreClip implements IDisposable
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
		 * on add handler.
		 */
		private function onAdd(e:Event):void
		{
			if(stage && !addr)
			{
				stage.addEventListener(Event.RESIZE, onResize);
				addr = true;
			}
			addListeners();
			resized();
			addedToStage();
		}
		
		/**
		 * on removed handler.
		 */
		private function onRemoved(e:Event):void
		{
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
		protected function addedToStage():void{}
		
		/**
		 * Override this method to hook into the removed from stage event.
		 */
		protected function removedFromStage():void
		{
			cleanup();
		}
		
		/**
		 * Initialize the BasicView.
		 */
		protected function init():void{}
		
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
		override public function dispose():void{}
		
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
