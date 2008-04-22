package net.guttershark.sound
{
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;

	import net.guttershark.sound.events.VolumeEvent;

	/**
	 * Dispatched when the internal volume has changed.
	 */
	[Event("change", type="net.guttershark.sound.events.VolumeEvent")]

	/**
	 * The SoundManager class is used to control sounds in 
	 * a flash movie through one interface. Actionscript 3 
	 * has a much different sound model from AS 2. This class is 
	 * used to take care of those differences and bundle up a way to 
	 * control sound globally.
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
		private var _soundTransforms:Array;
		
		/**
		 * Any sound currently playing.
		 */
		private var _playingSounds:Array;
		
		/**
		 * @private
		 * 
		 * Singleton SoundManager
		 */
		public function SoundManager()
		{
			if(instance) throw new Error("SoundManager is a singleton, call SoundManager.GetInstance() for the instance.");
			_soundDic = new Dictionary(true);
			_sndObjectsWithTransforms = new Dictionary(true);
			_volume = 0;
			_mainTransform = new SoundTransform(1,0);
			_playingSounds = [];
			_soundTransforms = [];
		}
		
		/**
		 * Singleton access.
		 */
		public static function GetInstance():SoundManager
		{
			if(instance == null) instance = new SoundManager();
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
		 * Remove a sound from the manager.
		 * 
		 * @param	name	The unique sound identifier used when registering it into the manager.
		 */
		public function removeSound(name:String):void
		{
			_soundDic[name] = null;
		}
		
		/**
		 * Play a sound that has been registered previously.
		 * 
		 * @param	name	The unique name used when registering it into the manager.
		 * @param	startOffset	The start offset for the sound.
		 * @param	int	The number of times to loop the sound.
		 */
		public function playSound(name:String, startOffset:Number = 0, loopCount:int = 0):void
		{
			var snd:Sound = Sound(_soundDic[name]);
			_playingSounds[name] = snd.play(startOffset, loopCount, _mainTransform);
		}
		
		/**
		 * Play a sound with a custom volume.
		 * 
		 * @param		String		The unique identier used with addSound
		 * @param		Number		The start offset
		 * @param		int			The number of times to loop the sound.
		 * @param		Number		The custom volume to play the sound at.
		 */
		public function playSoundWithCustomVolume(name:String, startOffset:Number = 0, loopCount:int = 0, volume:Number = 0):void
		{
			var st:SoundTransform = new SoundTransform(volume,0);
			var snd:Sound = Sound(_soundDic[name]);
			_soundTransforms[name] = st;
			st.volume = 0;
			_playingSounds[name] = snd.play(startOffset,loopCount,st);
		}
		
		/**
		 * Stop a playing sound.
		 * 
		 * @param	name	The unique name used when registering it into the manager.
		 */
		public function stopSound(name:String):void
		{
			if(!_playingSounds[name]) return;
			var ch:SoundChannel = SoundChannel(_playingSounds[name]);
			ch.stop();
		}
		
		/**
		 * Stop all sounds playing through the SoundManager.
		 */
		public function stopAllSounds():void
		{
			for each(var ch:SoundChannel in _playingSounds) ch.stop();
		}
		
		/**
		 * Set the global volume on all objects registered.
		 * 
		 * @param	level	The volume level.
		 */
		public function set volume(level:Number):void
		{
			_mainTransform.volume = level;
			for each(var obj:* in _sndObjectsWithTransforms) obj.soundTransform.volume = _mainTransform.volume;
			dispatchEvent(new VolumeEvent(_mainTransform.volume));
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
			dispatchEvent(new VolumeEvent(_mainTransform.volume));
		}
	}
}