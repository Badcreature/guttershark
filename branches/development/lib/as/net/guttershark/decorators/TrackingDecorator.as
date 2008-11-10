package net.guttershark.decorators 
{
	import net.guttershark.util.Tracking;
	
	import flash.display.Sprite;	

	/**
	 * The TrackingDecorator class decorates a movie clip.
	 */
	public class TrackingDecorator
	{
		
		/**
		 * The clip being decorated.
		 */
		private var clip:Sprite;
		
		/**
		 * The tracking id.
		 */
		private var trackId:String;
		
		/**
		 * The event being listened to.
		 */
		private var event:String;
		
		/**
		 * Constructor for TrackingDecorator instances.
		 * 
		 * @param clip A sprite to decorate.
		 * @param trackId The tracking id from a tracking xml file.
		 * @param reactToEvent The event to react to that dispatches from the sprite being decorated.
		 */
		public function TrackingDecorator(clip:Sprite,trackId:String,reactToEvent:String="click")
		{
			this.clip=clip;
			this.trackId=trackId;
			event=reactToEvent;
			clip.addEventListener(reactToEvent,onEvent,false,0,true);
		}
		
		/**
		 * When the trigger event occurs.
		 */
		private function onEvent(e:*):void
		{
			Tracking.track(trackId);
		}	}}