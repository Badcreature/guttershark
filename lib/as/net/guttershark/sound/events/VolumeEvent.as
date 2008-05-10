package net.guttershark.sound.events
{
	
	import flash.events.Event;
	
	/**
	 * The VolumeEvent dispatches when changes to the volume occur in the SoundManager.
	 */
	public class VolumeEvent extends Event
	{
		
		/**
		 * Defines the value of the type property of a VolumeEvent.
		 */
		public static const CHANGE:String = "change";
		
		/**
		 * The new volume.
		 */
		public var volume:int;
		
		/**
		 * Constructor for VolumeEvent instances.
		 * 
		 * @param	volume	The new volume.
		 * @param	Boolean	Whether or not this should bubble.
		 * @param	Boolean	Whether or not this is cancelable.
		 */
		public function VolumeEvent(volume:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(VolumeEvent.CHANGE, bubbles,cancelable);
			this.volume = volume;
		}
	}
}