package net.guttershark.display.views 
{
	import flash.display.MovieClip;	
	
	/**
	 * The CoreFormView class has hooks for common "form" behaviors.
	 * 
	 * <p>The CoreFormView class is also intended to be used
	 * as a composite class, meaning a CoreFormView could have
	 * children views that are also CoreFormView's.</p>
	 */
	public class CoreFormView extends CoreView
	{
		
		/**
		 * A container for error views to show and hide
		 * during validation.
		 */
		public var errorViews:MovieClip;
		
		/**
		 * A function delegate you should use and call
		 * when the user cancels the form operation and
		 * any validation has passed.
		 */
		public var onCancel:Function;
		
		/**
		 * A function delegate you should use and call
		 * when the user confirms the form operation and
		 * any validation has passed.
		 */
		public var onConfirm:Function;
		
		/**
		 * A function delegate you should use and call
		 * when the user agrees to the form operation and
		 * any validation has passed.
		 */
		public var onYes:Function;
		
		/**
		 * A function delegate you should use and call
		 * when the user declines the form operation and
		 * any validation has passed.
		 */
		public var onNo:Function;
		
		/**
		 * A function delegate you should use and call
		 * when the user agrees to delete (something) and
		 * any validation has passed.
		 */
		public var onDelete:Function;

		/**
		 * Constructor for CoreFormView instances.
		 */
		public function CoreFormView()
		{
			super();
		}
		
		/**
		 * Show this form view - this calls <a href='#addKeyMappings()'>addKeyMappings()</a>
		 * and <a href='#selectField()'>selectField()</a>.
		 */
		override public function show():void
		{
			if(visible) return;
			super.show();
			addKeyMappings();
			selectField();
		}
		
		/**
		 * Hide this form view - this calls <a href='#removeKeyMappings()'>removeKeyMappings()</a> 
		 * and <a href='#deselectField()'>deselectField()</a>.
		 */
		override public function hide():void
		{
			if(!visible) return;
			super.hide();
			removeKeyMappings();
			deselectField();
		}
		
		/**
		 * Override this and add key event mappings with the
		 * keyboard event manager.
		 * 
		 * <p>This is called when the view is shown.</p>
		 */
		protected function addKeyMappings():void{}
		
		/**
		 * Override this and remove key event mappings with the
		 * keyboard event manager.
		 * 
		 * <p>This is called when the view is hidden.</p>
		 */
		protected function removeKeyMappings():void{}
		
		/**
		 * Override this and do some select/focus logic for the form field.
		 * 
		 * <p>The is called when the view is shown.</p>
		 */
		protected function selectField():void{}
		
		/**
		 * Override this and do some deselect logic for the form fields.
		 * 
		 * <p>This is called with the view is hidden.</p>
		 */
		protected function deselectField():void{}
		
		/**
		 * Override this and do some form validation.
		 */
		protected function validate():Boolean
		{
			return false;
		}
		
		/**
		 * Override this method, and use as the the click event
		 * handler for a "confirm" button - validate this
		 * form and then call the onConfirm delegate function.
		 */
		protected function onConfirmClick():void{}
		
		/**
		 * Override this method, and use as the the click event
		 * handler for a "yes" button - validate this
		 * form and then call the onYes delegate function.
		 */
		protected function onYesClick():void{}
		
		/**
		 * Override this method, and use as the the click event
		 * handler for a "no" button - validate this
		 * form and then call the onNo delegate function.
		 */
		protected function onNoClick():void{}
		
		/**
		 * Override this method, and use as the the click event
		 * handler for a "delete" button - validate this
		 * form and then call the onDelete delegate function.
		 */
		protected function onDeleteClick():void{}
		
		/**
		 * Override this method and implement a modal blocker,
		 * which can then be called when a sub form view is shown
		 * and this view needs to be blocked from interaction.
		 */
		protected function blockForInput():void{}
		
		/**
		 * Override this method, and disable a modal blocker.
		 */
		protected function unblockFromInput():void{}	}}