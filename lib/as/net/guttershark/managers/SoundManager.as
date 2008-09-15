package net.guttershark.managers
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	import net.guttershark.util.Singleton;

	/**
	 * Dispatched when the internal volume has changed.
	 * 
	 * @eventType	flash.events.Event
	 */
	[Event("change", type="flash.events.Event")]

	/**
	 * The SoundManager class is used to control sounds globally.
	 */
	public class SoundManager extends EventDispatcher
	{
		
		/**
		 * Singleton instance.
		 */
		private static var instance:SoundManager;
		
		/**
		 * Sounds stored in the manager.
		 */
		private var _soundDic:Dictionary;
		
		/**
		 * Internal volume indicator. Used for volume toggling.
		 */
		private var _volume:Number;
		
		/**
		 * Sounds objects with transforms store. 
		 */
		private var _sndObjectsWithTransforms:Dictionary;
		
		/**
		 * Single transform used internally when playing any sound
		 * This is passed to the sound object to set it's volume.
		 */
		private var _mainTransform:SoundTransform;
		
		/**
		 * Array of sounds transforms currently being used by playing sounds.
		 */
		private var _soundTransforms:Dictionary;
		
		/**
		 * Any sound currently playing.
		 */
		private var _playingSounds:Dictionary;
		
		/**
		 * @private
		 * 
		 * Singleton SoundManager
		 */
		public function SoundManager()
		{
			Singleton.assertSingle(SoundManager);
			_soundDic = new Dictionary();
			_sndObjectsWithTransforms = new Dictionary();
			_playingSounds = new Dictionary();
			_soundTransforms = new Dictionary();
			_mainTransform = new SoundTransform(1,0);
			_volume = 0;
		}
		
		/**
		 * Singleton access.
		 */
		public static function gi():SoundManager
		{
			if(instance == null) instance = Singleton.gi(SoundManager);
			return instance;
		}
		
		/**
		 * Add a sound into the sound manager.
		 * 
		 * @param	name	Any unique identifier to give to the sound.
		 * @param	snd		The sound to associate with that unique identifier.
		 */
		public function addSound(name:String, snd:Sound):void
		{
			_soundDic[name] = snd;
		}
		
		/**
		 * Add a sprite to control it's sound.
		 * 
		 * @param	obj		Any sprite who's volume you want to control.
		 */
		public function addSprite(obj:Sprite):void
		{
			_sndObjectsWithTransforms[obj] = obj;
		}
		
		/**
		 * Remove a sprite from sound control
		 * 
		 * @param	obj	The sprite to remove.
		 */
		public function removeSprite(obj:Sprite):void
		{
			_sndObjectsWithTransforms[obj] = null;
		}

		/**
		 * Remove a sound from the manager.
		 * 
		 * @param	name	The unique sound identifier used when registering it into the manager.
		 */
		public function removeSound(name:String):void
		{
			_soundDic[name] = null;
		}
		
		/**
		 * Play a sound that was previously registered.
		 * 
		 * @param	name	The unique name used when registering it into the manager.
		 * @param	startOffset	The start offset for the sound.
		 * @param	int	The number of times to loop the sound.
		 * @param	customVolume	A custom volume to play at, other than the current internal volume.
		 */
		public function playSound(name:String, startOffset:Number = 0, loopCount:int = 0, customVolume:Number = -1):void
		{
			var snd:Sound = Sound(_soundDic[name]);
			if(customVolume > -1)
			{
				var st:SoundTransform = new SoundTransform(customVolume,0);
				_soundTransforms[name] = st;
				_playingSounds[name] = snd.play(startOffset, loopCount, st);
			}
			else _playingSounds[name] = snd.play(startOffset, loopCount, _mainTransform);
		}
		
		/**
		 * Stop a playing sound.
		 * 
		 * @param	name	The unique name used when registering it into the manager.
		 */
		public function stopSound(name:String):void
		{
			if(!_playingSounds[name]) return;
			var ch:SoundChannel = _playingSounds[name] as SoundChannel;
			ch.stop();
			_playingSounds[name] = null;
		}
		
		/**
		 * Stop all sounds playing through the SoundManager.
		 */
		public function stopAllSounds():void
		{
			for each(var ch:SoundChannel in _playingSounds) ch.stop();
			_playingSounds = new Dictionary();
		}
		
		/**
		 * Set the global volume on all objects registered.
		 * 
		 * @param	level	The volume level.
		 */
		public function set volume(level:Number):void
		{
			_mainTransform.volume = level;
			var obj:*;
			for each(obj in _sndObjectsWithTransforms) obj.soundTransform.volume = _mainTransform.volume;
			dispatchEvent(new Event(Event.CHANGE));
		}
		/**
		 * Read the internal volume.
		 */
		public function get volume():Number
		{
			return _volume;
		}

		/**
		 * Toggle the current volume with 0.
		 */
		public function toggleVolume():void
		{			
			var tmp1:Number = _volume;
			var tmp2:Number = _mainTransform.volume;
			_mainTransform.volume = tmp1;
			_volume = tmp2;
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}