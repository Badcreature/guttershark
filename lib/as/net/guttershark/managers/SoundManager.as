package net.guttershark.managers
{
	import gs.TweenMax;
	
	import net.guttershark.util.Assertions;
	import net.guttershark.util.Singleton;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;	

	/**
	 * Dispatched when the volume changes.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event("change", type="flash.events.Event")]

	/**
	 * The SoundManager class manages sounds globaly, and manages
	 * sound control for sprites with soundTransform objects.
	 * 
	 * <p>The SoundManager class allows you to play a sound as an
	 * effect, an environment sound, or normal sound.</p>
	 * 
	 * <p>An effect sound plays once, allowing multiple of the same
	 * sound to overlap.</p>
	 * 
	 * <p>An environment sound loops the amount of times specified
	 * by the <em><strong>environmentSoundLoopCount</strong></em>
	 * variable.</p>
	 * 
	 * <p>A normal sound doesn't do anything special, other than what
	 * you pass as parameters to the <em><strong>playSound</strong></em>
	 * function.
	 * 
	 * <p>Playing sounds as environment or effect sounds is beneficial
	 * - there are methods to play and stop sounds of
	 * specific type. The sound manager manages it all for you
	 * so you don't get caught writing weird logic to play or stop
	 * sounds at certain times depending on some state the site
	 * is in.</p>
	 */
	final public class SoundManager extends EventDispatcher
	{
		
		/**
		 * The loop count for all environment sounds.
		 */
		public var environmentSoundLoopCount:int=10000;
		
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
		private var sounds:Dictionary;
		
		/**
		 * Internal volume indicator. Used for volume toggling.
		 */
		private var vol:Number;
		
		/**
		 * Single transform used internally when playing any sound
		 * This is passed to the sound object to set it's volume.
		 */
		private var transform:SoundTransform;
		
		/**
		 * A dictionary of all registered sprites the manager is controlling.
		 */
		private var sprites:Dictionary;
		
		/**
		 * all playing ids by channel object.
		 */
		private var playingIdsByChannel:Dictionary;
		
		/**
		 * All playing sounds.
		 */
		private var allPlayingSounds:Dictionary;
		
		/**
		 * normal playing sounds.
		 */
		private var playingSounds:Dictionary;
		
		/**
		 * playing environment sounds.
		 */
		private var playingEnvSounds:Dictionary;
		
		/**
		 * playing effect sounds.
		 */
		private var playingEffectSounds:Dictionary;

		/**
		 * @private
		 * 
		 * Singleton SoundManager
		 */
		public function SoundManager()
		{
			Singleton.assertSingle(SoundManager);
			ast=Assertions.gi();
			sounds=new Dictionary();
			sprites=new Dictionary();
			allPlayingSounds=new Dictionary();
			playingEnvSounds=new Dictionary();
			playingEffectSounds=new Dictionary();
			playingSounds=new Dictionary();
			playingIdsByChannel=new Dictionary();
			transform=new SoundTransform(1,0);
			vol=0;
		}

		/**
		 * Singleton access.
		 */
		public static function gi():SoundManager
		{
			if(!inst)inst=Singleton.gi(SoundManager);
			return inst;
		}
		
		/**
		 * Add a sound to the manager.
		 * 
		 * @param id The sounds id.
		 * @param snd The sound object.
		 */
		public function addSound(id:String,snd:Sound):void
		{
			ast.notNil(id,"Parameter {id} cannot be null.");
			ast.notNil(snd,"Parameter {snd} cannot be null.");
			if(sounds[id])trace("WARNING: A sound with the id {"+id+"} was already registered, and will be over-written");
			sounds[id]=snd;
		}
		
		/**
		 * Remove a sound from the manager.
		 * 
		 * @param id The sound id.
		 */
		public function removeSound(id:String):void
		{
			if(!id)return;
			sounds[id]=null;
		}
		
		/**
		 * Add an object who's volume will be controlled by the manager.
		 * 
		 * @param obj The sprite who's volume you want to control.
		 */
		public function addObject(obj:*):void
		{
			if(!("soundTransform" in obj)) throw new Error("The object added must have a soundTransform property.");
			ast.notNil(obj,"Parameter {obj} cannot be null.");
			sprites[obj]=obj;
		}
		
		/**
		 * Remove an object from sound control.
		 * 
		 * @param obj The sprite to remove.
		 */
		public function removeObject(obj:*):void
		{
			if(!obj)return;
			sprites[obj]=null;
			delete sprites[obj];
		}
		
		/**
		 * Check whether or not a sound is playing.
		 * 
		 * @param id The sound id.
		 */
		public function isSoundPlaying(id:String):Boolean
		{
			return !(allPlayingSounds[id]===null||allPlayingSounds[id]===undefined);
		}
		
		/**
		 * Check of any of the give sounds are playing.
		 * 
		 * @param ...soundIds An array of sound ids to check.
		 */
		public function isAnySoundPlaying(...soundIds:Array):Boolean
		{
			var i:int=0;
			var l:int=soundIds.length;
			for(i;i<l;i++) if(playingSounds[soundIds[i]])return true;
			return false;
		}
		
		/**
		 * Play a sound.
		 * 
		 * @param id The sound id.
		 * @param startOffset The start offset for the sound.
		 * @param loopCount The number of times to loop the sound.
		 * @param customVolume A custom volume level.
		 */
		public function playSound(id:String,startOffset:Number=0,loopCount:int=0,customVolume:Number=-1):void
		{
			if(!sounds[id])return;
			var s:Sound=Sound(sounds[id]);
			var t:SoundTransform=transform;
			if(customVolume!=-1)t=new SoundTransform(customVolume,0);
			if(customVolume<0&&customVolume!=-1)t=new SoundTransform(0,0);
			//if(customVolume>1)t=new SoundTransform(1,0);
			var ch:SoundChannel=allPlayingSounds[id]=playingSounds[id]=s.play(startOffset,loopCount,t);
			ch.addEventListener(Event.SOUND_COMPLETE,onSoundComplete);
			playingIdsByChannel[ch]=id;
		}

		/**
		 * Play an environment sound - environment sounds loop the amount
		 * of times specified by <code><em>environmentLoopCount</em></strong>
		 * and only one of the same environment sound can be playing at
		 * once.
		 * 
		 * @param id The sound id.
		 * @param customVolume A custom volume level.
		 */
		public function playEnvSound(id:String,customVolume:Number=-1):void
		{
			trace("play env sound:",id);
			if(!sounds[id])return;
			if(playingEnvSounds[id])return;
			var s:Sound=Sound(sounds[id]);
			var t:SoundTransform=transform;
			if(customVolume!=-1)t=new SoundTransform(customVolume,0);
			if(customVolume<0&&customVolume!=-1)t=new SoundTransform(0,0);
			//if(customVolume>1)t=new SoundTransform(1,0);
			var ch:SoundChannel=allPlayingSounds[id]=playingEnvSounds[id]=s.play(0,environmentSoundLoopCount,t);
			ch.addEventListener(Event.SOUND_COMPLETE,onSoundComplete);
			playingIdsByChannel[ch]=id;
		}
		
		/**
		 * Play an effect sound, an effect sound will not loop.
		 * 
		 * @param id The sound id.
		 */
		public function playEffectSound(id:String,customVolume:Number=-1,forceIfMuted:Boolean=false):void
		{
			trace("play eff sound:",id);
			if(transform.volume==0&&!forceIfMuted)return;
			if(!sounds[id])return;
			var s:Sound=Sound(sounds[id]);
			var t:SoundTransform=transform;
			if(customVolume!=-1)t=new SoundTransform(customVolume,0);
			if(customVolume<0&&customVolume!=-1)t=new SoundTransform(0,0);
			//if(customVolume>1)t=new SoundTransform(1,0);
			var ch:SoundChannel=allPlayingSounds[id]=playingEffectSounds[id]=s.play(0,0,t);
			ch.addEventListener(Event.SOUND_COMPLETE,onSoundComplete);
			playingIdsByChannel[ch]=id;
		}
		
		/**
		 * on sound complete.
		 */
		private function onSoundComplete(e:Event):void
		{
			var ch:SoundChannel=SoundChannel(e.target);
			ch.removeEventListener(Event.SOUND_COMPLETE,onSoundComplete);
			var id:String = playingIdsByChannel[ch];
			if(playingEffectSounds[id])playingEffectSounds[id]=null;
			if(playingEnvSounds[id])playingEnvSounds[id]=null;
			if(playingSounds[id])playingSounds[id]=null;
			if(allPlayingSounds[id])allPlayingSounds[id]=null;
			playingIdsByChannel[ch]=null;
			delete playingIdsByChannel[ch];
		}

		/**
		 * Stop a playing sound - this will stop a normal sound,
		 * environment sound, or effect sound.
		 * 
		 * @param id The sound id.
		 */
		public function stopSound(id:String):void
		{
			if(!allPlayingSounds[id])return;
			stopEffectSound(id);
			stopEnvironmentSound(id);
			if(playingSounds[id])
			{
				var ch:SoundChannel=SoundChannel(playingSounds[id]);
				if(ch)
				{
					ch.removeEventListener(Event.SOUND_COMPLETE,onSoundComplete);
					ch.stop();
				}
				else
				{
					allPlayingSounds[id]=null;
					playingEffectSounds[id]=null;
					playingEffectSounds[id]=null;
					playingSounds[id]=null;
				}
			}
			playingSounds[id]=null;
			allPlayingSounds[id]=null;
		}

		/**
		 * Stops all sounds.
		 */
		public function stopAllSounds():void
		{
			var key:String;
			var ch:SoundChannel;
			for(key in allPlayingSounds)
			{
				ch=allPlayingSounds[key];
				if(ch)
				{
					ch.removeEventListener(Event.SOUND_COMPLETE,onSoundComplete);
					ch.stop();
				}
				if(playingSounds[key])playingSounds[key]=null;
				if(playingEffectSounds[key])playingEffectSounds[key]=null;
				if(playingEnvSounds[key])playingEnvSounds[key]=null;
				allPlayingSounds[key]=null;
			}
		}
		
		/**
		 * Stops all environment sounds.
		 */
		public function stopAllEnvSounds():void
		{
			var key:String;
			var ch:SoundChannel;
			for(key in playingEnvSounds)
			{
				ch=playingEnvSounds[key];
				if(ch)
				{
					ch.removeEventListener(Event.SOUND_COMPLETE,onSoundComplete);
					ch.stop();
				}
				playingEnvSounds[key]=null;
			}
		}
		
		/**
		 * Stops all effect sounds.
		 */
		public function stopAllEffectSounds():void
		{
			var key:String;
			var ch:SoundChannel;
			for(key in playingEffectSounds)
			{
				ch=playingEffectSounds[key];
				if(ch)
				{
					ch.removeEventListener(Event.SOUND_COMPLETE,onSoundComplete);
					ch.stop();
				}
				playingEffectSounds[key]=null;
			}
		}
		
		/**
		 * Tween the volume to a new level.
		 * 
		 * @param level The new volume leve.
		 * @param duration The duration of the tween.
		 */
		public function volumeTo(level:Number,duration:Number=.3):void
		{
			TweenMax.to(this,duration,{volumeTween:level,overwrite:true});
		}

		/**
		 * Tween the volume property with tween max.
		 * 
		 * @example Tweening the volume:
		 * <listing>
		 * snm=SoundManager.gi();
		 * snm.volume=0;
		 * TweenMax.to(snm,.4,{volumeTween:1});
		 * </listing>
		 */
		public function get volumeTween():Number
		{
			return transform.volume;
		}
		
		/**
		 * Tween the volume property with tween max.
		 */
		public function set volumeTween(level:Number):void
		{
			volume=level;
		}

		/**
		 * Set the volume on all registered objects.
		 * 
		 * @param level The volume level.
		 */
		public function set volume(level:Number):void
		{
			transform.volume=level;
			var key:String;
			var ch:SoundChannel;
			for(key in allPlayingSounds)
			{
				ch=allPlayingSounds[key];
				if(ch)ch.soundTransform=new SoundTransform(level,0);
				else
				{
					allPlayingSounds[key]=null;
					playingEffectSounds[key]=null;
					playingEffectSounds[key]=null;
					playingSounds[key]=null;
				}
			}
			var obj:*;
			for each(obj in sprites)
			{
				if(obj)obj.soundTransform=new SoundTransform(level,0);
				else
				{
					sprites[obj]=null;
					delete sprites[obj];
				}
			}
			dispatchEvent(new Event("change"));
		}

		/**
		 * Read the internal volume.
		 */
		public function get volume():Number
		{
			return transform.volume;
		}
		
		/**
		 * Toggle the current volume with 0.
		 */
		public function toggleMute():void
		{
			if(vol!=0&&transform.volume!=0)vol=0;
			vol^=transform.volume;
			transform.volume^=vol;
			vol^=transform.volume;
			volume=transform.volume;
		}
		
		/**
		 * Stops an effect sound.
		 * 
		 * @param id The sound id.
		 */
		private function stopEffectSound(id:String):void
		{
			if(!playingEffectSounds[id])return;
			var ch:SoundChannel=SoundChannel(playingEffectSounds[id]);
			if(ch)ch.stop();
			playingEffectSounds[id]=null;
		}
		
		/**
		 * Stops an environment sound.
		 * 
		 * @param id The sound id.
		 */
		private function stopEnvironmentSound(id:String):void
		{
			if(!playingEnvSounds[id]) return;
			var ch:SoundChannel=SoundChannel(playingEnvSounds[id]);
			if(ch)ch.stop();
			playingEnvSounds[id]=null;
		}
	}
}