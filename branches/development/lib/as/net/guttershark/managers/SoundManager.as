package net.guttershark.managers
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	import net.guttershark.util.Assertions;
	import net.guttershark.util.Singleton;	

	/**
	 * Dispatched when the internal volume has changed.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event("change", type="flash.events.Event")]

	/**
	 * The SoundManager class manages sounds globaly, and manages
	 * sound control for sprites.
	 */
	final public class SoundManager extends EventDispatcher
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:SoundManager;
		
		/**
		 * A Assertions singleton instance.
		 */
		private var ast:Assertions;
		/**
		 * Sounds stored in the manager.
		 */
		private var sounddic:Dictionary;
		
		/**
		 * Internal volume indicator. Used for volume toggling.
		 */
		private var vol:Number;
		
		/**
		 * Sounds objects with transforms store. 
		 */
		private var sndObjectsWithTransforms:Dictionary;
		
		/**
		 * Single transform used internally when playing any sound
		 * This is passed to the sound object to set it's volume.
		 */
		private var mainTransform:SoundTransform;
		
		/**
		 * Array of sounds transforms currently being used by playing sounds.
		 */
		private var soundTransforms:Dictionary;
		
		/**
		 * Any sound currently playing.
		 */
		private var playingSounds:Dictionary;
		
		/**
		 * @private
		 * 
		 * Singleton SoundManager
		 */
		public function SoundManager()
		{
			Singleton.assertSingle(SoundManager);
			sounddic = new Dictionary();
			sndObjectsWithTransforms = new Dictionary();
			playingSounds = new Dictionary();
			soundTransforms = new Dictionary();
			mainTransform = new SoundTransform(1,0);
			vol = 0;
		}
		
		/**
		 * Singleton access.
		 */
		public static function gi():SoundManager
		{
			if(!inst) inst = Singleton.gi(SoundManager);
			return inst;
		}
		
		/**
		 * Add a sound into the sound manager.
		 * 
		 * @param name Any unique identifier to give to the sound.
		 * @param snd The sound to associate with that unique identifier.
		 */
		public function addSound(name:String, snd:Sound):void
		{
			ast.notNil(name,"The {name} parameter cannot be null");
			ast.notNil(snd,"The {snd} parameter cannot be null");
			sounddic[name] = snd;
		}
		
		/**
		 * Add a sprite to control it's sound.
		 * 
		 * @param obj Any sprite who's volume you want to control.
		 */
		public function addSprite(obj:Sprite):void
		{
			ast.notNil(obj,"The {obj} parameter cannot be null.");
			sndObjectsWithTransforms[obj] = obj;
		}
		
		/**
		 * Remove a sprite from sound control
		 * 
		 * @param obj The sprite to remove.
		 */
		public function removeSprite(obj:Sprite):void
		{
			if(!obj) return;
			sndObjectsWithTransforms[obj] = null;
		}

		/**
		 * Remove a sound from the manager.
		 * 
		 * @param name The unique sound identifier used when registering it into the manager.
		 */
		public function removeSound(name:String):void
		{
			if(!name) return;
			sounddic[name] = null;
		}
		
		/**
		 * Play a sound that was previously registered.
		 * 
		 * @param name The unique name used when registering it into the manager.
		 * @param startOffset The start offset for the sound.
		 * @param int The number of times to loop the sound.
		 * @param customVolume A custom volume to play at, other than the current internal volume.
		 */
		public function playSound(name:String,startOffset:Number=0,loopCount:int=0,customVolume:int=-1):void
		{
			ast.notNil(name,"The {name} parameter cannot be null");
			var snd:Sound = Sound(sounddic[name]);
			if(customVolume > -1)
			{
				var st:SoundTransform = new SoundTransform(customVolume,customVolume);
				soundTransforms[name] = st;
				playingSounds[name] = snd.play(startOffset,loopCount,st);
			}
			else playingSounds[name] = snd.play(startOffset,loopCount,mainTransform);
		}
		
		/**
		 * Stop a playing sound.
		 * 
		 * @param name The unique name used when registering it into the manager.
		 */
		public function stopSound(name:String):void
		{
			if(!name) return;
			if(!playingSounds[name]) return;
			var ch:SoundChannel = playingSounds[name] as SoundChannel;
			ch.stop();
			playingSounds[name] = null;
		}
		
		/**
		 * Stop all sounds playing through the SoundManager.
		 */
		public function stopAllSounds():void
		{
			for each(var ch:SoundChannel in playingSounds) ch.stop();
			playingSounds = new Dictionary();
		}
		
		/**
		 * Set the global volume on all objects registered.
		 * 
		 * @param level The volume level.
		 */
		public function set volume(level:int):void
		{
			ast.smaller(level,1,"The {level} parameter must be less than 1.");
			ast.greater(level,-0.9,"The {level} parameter must be 0 or greater.");
			mainTransform.volume = level;
			var obj:*;
			for each(obj in sndObjectsWithTransforms) obj.soundTransform.volume = mainTransform.volume;
			dispatchEvent(new Event(Event.CHANGE));
		}
		/**
		 * Read the internal volume.
		 */
		public function get volume():int
		{
			return vol;
		}

		/**
		 * Toggle the current volume with 0.
		 */
		public function toggleVolume():void
		{			
			var tmp1:Number = vol;
			var tmp2:Number = mainTransform.volume;
			mainTransform.volume = tmp1;
			vol = tmp2;
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}