package net.guttershark.display.views 
{
	import flash.display.MovieClip;	
	
	/**
	 * The BaseFormView class defines the top most class a form
	 * shoud implement, to follow a good pattern of the most commonly
	 * used form functionality.
	 * 
	 * <p>The BaseFormView class is also intended to be used
	 * as a composite class, meaning a BaseFormView could have
	 * children views that are also BaseFormView's.</p>
	 * 
	 * @see #onConfirmClick() onConfirmClick() for an example of using function delegates
	 * correctly.
	 */
	public class BaseFormView extends BaseView
	{
		
		/**
		 * A container for BaseErrorView's to show and hide
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
		public function BaseFormView()
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
		 * 
		 * @example Correctly using a delegate function:
		 * <listing>	
		 * public class MyFormView extends BaseFormView
		 * {
		 *     
		 *     public var confirm:MovieClip;
		 *     public var email:TextField;
		 *     
		 *     public function MyFormView()
		 *     {
		 *         super();
		 *     }
		 *     
		 *     override protected function addEventHandlers():void
		 *     {
		 *         em.handleEvents(confirm,this,"onConfirm");
		 *     }
		 *     
		 *     override protected function removeEventHandlers():void
		 *     {
		 *         em.disposeEvents(confirm);
		 *     }
		 *     
		 *     override protected function validate():Boolean
		 *     {
		 *         if(!utils.string.isemail(email.text))
		 *         {
		 *             errorViews.badEmail.showAndHide(3000); //see BaseErrorView for showAndHide()
		 *             return false;
		 *         }
		 *         return true;
		 *     }
		 *     
		 *     override public function onConfirmClick():void
		 *     {
		 *         super.onConfirmClick();
		 *         
		 *         //in this case, the delegate function (onConfirm) 
		 *         //would have to accept one parameter - an email.
		 *         //This pattern is taken from apple's cocoa
		 *         //framework. This type of pattern is extremly
		 *         //useful, and leads to less bugs and good design.
		 *         if(validate()) onConfirm(email.text);
		 *     }
		 * }
		 * </listing>
		 */
		public function onConfirmClick():void{}
		
		/**
		 * Override this method, and use as the the click event
		 * handler for a "yes" button - validate this
		 * form and then call the onYes delegate function.
		 * 
		 * @see #onConfirmClick() for a function delegate example.
		 */
		public function onYesClick():void{}
		
		/**
		 * Override this method, and use as the the click event
		 * handler for a "no" button - validate this
		 * form and then call the onNo delegate function.
		 * 
		 * @see #onConfirmClick() for a function delegate example.
		 */
		public function onNoClick():void{}
		
		/**
		 * Override this method, and use as the the click event
		 * handler for a "delete" button - validate this
		 * form and then call the onDelete delegate function.
		 * 
		 * @see #onConfirmClick() for a function delegate example.
		 */
		public function onDeleteClick():void{}
		
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