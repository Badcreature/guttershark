package net.guttershark.decorators 
{
	import net.guttershark.model.Model;
	
	import flash.display.MovieClip;	

	/**
	 * The LinkButtonDecorator class decorates any movie clip,
	 * with "navigateToLink" functionality tied in with the
	 * Model class. The linkId must be a link node in the model.
	 */
	final public class NavigateToLink
	{
		
		/**
		 * The model.
		 */
		private var ml:Model;
		
		/**
		 * The link id.
		 */
		private var linkId:String;
		
		/**
		 * The clip being decorated.
		 */
		private var clip:MovieClip;
		
		/**
		 * The event used to trigger the nav to link.
		 */
		private var event:String;
		
		/**
		 * Constructor for new NavigateToLink instances.
		 * 
		 * @param clip The movie clip to decorate.
		 * @param linkId The link id from the model to navigate to.
		 */
		public function NavigateToLink(clip:MovieClip,modelLinkId:String,reactToEvent:String="click")
		{
			if(!clip) throw new Error("Clip cannot be null.");
			if(!ml.doesLinkExist(modelLinkId)) throw new Error("The linkId {"+modelLinkId+"} does not exist in the model.");
			clip.addEventListener(reactToEvent,onClipEvent,false,0,true);
			this.clip=clip;
			linkId=modelLinkId;
			event=reactToEvent;
		}
		
		/**
		 * The event 
		 */
		private function onClipEvent(me:*):void
		{
			ml.navigateToLink(linkId);
		}
		
		/**
		 * Dispose of this link button decorator.
		 */
		public function dispose():void
		{
			clip.removeEventListener(event,onClipEvent);
			clip=null;
			ml=null;
			linkId=null;
			event=null;
		}	}}