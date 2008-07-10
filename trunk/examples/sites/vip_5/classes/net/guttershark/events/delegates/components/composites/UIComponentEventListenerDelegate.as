package net.guttershark.events.delegates.components.composites
{

	import fl.events.ComponentEvent;
	import fl.core.UIComponent;
	import flash.events.Event;
	
	import net.guttershark.events.delegates.EventListenerDelegate;
	
	/**
	 * The UIComponentEventListenerDelegate is used for all components
	 * that are UIComponents. This has four events common to every UIComponent.
	 * This is used as a composite object in other IEventListenerDelegate classes. See
	 * the ButtonEventListenerDelegate source for an example of how this is used.
	 */
	public class UIComponentEventListenerDelegate extends EventListenerDelegate
	{

		/**
		 * Add listeners to the passed obj. Make sure to only add listeners
		 * to the obj if the (obj is MyClass).
		 */
		override public function addListeners(obj:*):void
		{
			super.addListeners(obj);
			if(obj is UIComponent)
			{
				obj.addEventListener(ComponentEvent.MOVE, onMove);
				obj.addEventListener(ComponentEvent.RESIZE,onResize);
				obj.addEventListener(ComponentEvent.SHOW,onShow);
				obj.addEventListener(ComponentEvent.HIDE,onHide);
			}
		}
		
		/**
		 * Dispose of this UIComponentEventListenerDelegate instance.
		 */
		override public function dispose():void
		{
			super.dispose();
		}
		
		/**
		 * Remove event listeners from the obj.
		 */
		override protected function removeEventListeners():void
		{
			obj.removeEventListener(ComponentEvent.MOVE, onMove);
			obj.removeEventListener(ComponentEvent.RESIZE,onResize);
			obj.removeEventListener(ComponentEvent.SHOW,onShow);
			obj.removeEventListener(ComponentEvent.HIDE,onHide);
		}
		
		private function onMove(ce:ComponentEvent):void
		{
			handleEvent(ce,"Move");
		}
		
		private function onResize(e:Event):void
		{
			handleEvent(e,"Resize");
		}
		
		private function onHide(ce:ComponentEvent):void
		{
			handleEvent(ce,"Hide");
		}
		
		private function onShow(ce:ComponentEvent):void
		{
			handleEvent(ce,"Show",true);
		}
		
	}}