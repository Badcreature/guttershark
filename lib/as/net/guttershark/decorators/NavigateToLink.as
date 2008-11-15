package net.guttershark.decorators 
{
	import net.guttershark.model.Model;
	
	import flash.display.Sprite;		

	/**
	 * The NavigateToLink class decorates any sprite,
	 * with "navigateToLink" functionality tied in with the
	 * model.
	 * 
	 * @example Decorating a clip to navigate to a link on click:
	 * <listing>	
	 * var myMovieClip:MovieClip;
	 * //the "google" must be a link node in the model.
	 * var ntl:NavigateToLink=new NavigateToLink(myMovieClip,"google",MouseEvent.CLICK);
	 * </listing>
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
		private var clip:Sprite;
		
		/**
		 * The event used to trigger the nav to link.
		 */
		private var event:String;
		
		/**
		 * Constructor for new NavigateToLink instances.
		 * 
		 * @param clip The sprite to decorate.
		 * @param modelLinkId The link id from the model to navigate to.
		 * @param reactToEvent What event to react to.
		 */
		public function NavigateToLink(sp:Sprite,modelLinkId:String,reactToEvent:String="click")
		{
			if(!sp)throw new Error("Parameter {sp} cannot be null.");
			clip=sp;
			ml=Model.gi();
			if(!ml.doesLinkExist(modelLinkId))throw new Error("The modelLinkId {"+modelLinkId+"} does not exist in the model.");
			clip.addEventListener(reactToEvent,onClipEvent);
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
		 * Dispose of this decorator.
		 */
		public function dispose():void
		{
			clip.removeEventListener(event,onClipEvent);
			clip=null;
			ml=null;
			linkId=null;
			event=null;
		}	}}