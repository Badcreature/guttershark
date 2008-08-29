package net.guttershark.events.delegates.components
{
	import net.guttershark.events.delegates.EventListenerDelegate;	
	
	import fl.controls.BaseButton;
	import fl.controls.LabelButton;
	import fl.core.UIComponent;

	import net.guttershark.events.delegates.components.composites.BaseButtonEventListenerDelegate;	
	import net.guttershark.events.delegates.components.composites.LabelButtonEventListenerDelegate;	
	import net.guttershark.events.delegates.components.composites.UIComponentEventListenerDelegate;

	/**
	 * The ButtonEventListenerDelegate class is an IEventListenerDelegate that
	 * implements event listeners for the ButtonComponent. See the EventManager
	 * for a list of supported events.
	 */
	public class CheckboxEventListenerDelegate extends EventListenerDelegate
	{

		/**
		 * A composite object used for UIComponentEventsDelegation logic.
		 */
		private var uic:UIComponentEventListenerDelegate;

		/**
		 * A composite object used for LabelButton events.
		 */
		private var lbc:LabelButtonEventListenerDelegate;

		/**
		 * A composite object used for BaseButton events.
		 */
		private var bb:BaseButtonEventListenerDelegate;

		/**
		 * Add listeners to the passed obj. Make sure to only add listeners
		 * to the obj if the (obj is MyClass).
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
			
			if(obj is BaseButton)
			{
				bb = new BaseButtonEventListenerDelegate();
				bb.eventHandlerFunction = this.handleEvent;
				bb.addListeners(obj);
			}
			
			if(obj is LabelButton)
			{
				lbc = new LabelButtonEventListenerDelegate();
				lbc.eventHandlerFunction = this.handleEvent;
				lbc.addListeners(obj);
			}
			
			//no events defined by Button. They're all from ancestors
		}
		
		/**
		 * Dispose of this ButtonEventListenerDelegate instance. This is called
		 * from the EventManager.
		 */
		override public function dispose():void
		{
			super.dispose();
			if(uic) uic.dispose();
			if(lbc) lbc.dispose();
			if(bb) bb.dispose();
			uic = null;
			lbc = null;
			bb = null;
		}
	}
}
