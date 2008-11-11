package net.guttershark.support.soundmanager 
{
	import gs.TweenMax;		import net.guttershark.managers.SoundManager3;	import net.guttershark.util.MathUtils;		import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.TimerEvent;	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundTransform;	import flash.utils.Timer;	
	/**
	 * Dispatched when the sound starts playing.
	 * 
	 * @eventType net.guttershark.support.soundmanager.AudioEvent
	 */
	[Event("start", type="net.guttershark.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched when the sound stops playing.
	 * 
	 * @eventType net.guttershark.support.soundmanager.AudioEvent
	 */
	[Event("stop", type="net.guttershark.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched for progress of the audio.
	 * 
	 * @eventType net.guttershark.support.soundmanager.AudioEvent
	 */
	[Event("progress", type="net.guttershark.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched when the sound is paused.
	 * 
	 * @eventType net.guttershark.support.soundmanager.AudioEvent
	 */
	[Event("paused", type="net.guttershark.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched when the sound is resumed.
	 * 
	 * @eventType net.guttershark.support.soundmanager.AudioEvent
	 */
	[Event("resumed", type="net.guttershark.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched when the sound has looped.
	 * 
	 * @eventType net.guttershark.support.soundmanager.AudioEvent
	 */
	[Event("looped", type="net.guttershark.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched when the sound is muted.
	 * 
	 * @eventType net.guttershark.support.soundmanager.AudioEvent
	 */
	[Event("mute", type="net.guttershark.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched when the sound is un-muted.
	 * 
	 * @eventType net.guttershark.support.soundmanager.AudioEvent
	 */
	[Event("unmute", type="net.guttershark.support.soundmanager.AudioEvent")]
	
	/**
	 * Dispatched when the sound has completed playing.
	 * 
	 * @eventType net.guttershark.support.soundmanager.AudioEvent
	 */
	[Event("complete", type="net.guttershark.support.soundmanager.AudioEvent")]

	/**
	 * Dispatched when the volume changes
	 * 
	 * @eventType net.guttershark.support.soundmanager.AudioEvent
	 */
	[Event("volumeChange", type="net.guttershark.support.soundmanager.AudioEvent")]

	/**
	 * Dispatched when the panning changes.
	 * 
	 * @eventType net.guttershark.support.soundmanager.AudioEvent
	 */
	[Event("panChange", type="net.guttershark.support.soundmanager.AudioEvent")]

	/** 
	 * The AudibleObject class controls one object that is
	 * "audible." It can control a Sound, or any object with
	 * a <em><strong>soundTransform</strong></em> property.
	 * 
	 * <p>onMaximumChannelsReached (Function) - When 32 channels are playing, throughout the entire movie.</p>
	 */
	public class AudibleObject extends EventDispatcher
	{

		/**
		 * The id of this audible object.
		 */
		public var id:String;
		
		/**
		 * The type of this audible object.
		 */
		private var type:String;
		
		/**
		 * Math utils.
		 */
		private var mu:MathUtils;

		/**
		 * The play options.
		 */
		private var ops:Object;
		
		/**
		 * @private
		 * The object being controled.
		 */
		public var obj:*;
		
		/**
		 * The sound channel if this is controlling a Sound.
		 */
		private var channel:SoundChannel;
		
		/**
		 * A transform used to keep reference to the volume.
		 */
		private var transform:SoundTransform;
		
		/**
		 * A volume var holder for mute/unmute.
		 */
		private var vol:Number;
		
		/**
		 * Whether or not this audible object is muted.
		 */
		private var muted:Boolean;
		
		/**
		 * A sound loop watching timer.
		 */
		private var loopWatcher:Timer;
		
		/**
		 * How many loops have occured.
		 */
		private var loops:Number;
		
		/**
		 * @private
		 * The group this audible object belongs to.
		 */
		public var audibleGroup:AudibleGroup;

		/**
		 * Whether or not this audible object is playing.
		 */
		private var isPlaying:Boolean;
		
		/**
		 * Whether ot not the object is paused.
		 */
		private var isPaused:Boolean;
		
		/**
		 * A holder var for the pause position, which
		 * is used to resume to.
		 */
		private var pausePosition:Number;
		
		/**
		 * The pixels to fill for this audible object.
		 */
		private var _pixelsToFill:int;
		
		/**
		 * The timer used for progress events.
		 */
		private var progressTimer:Timer;

		/**
		 * Constructor for AudibleObject instances.
		 * 
		 * @param audibleId The id for this audible object.
		 * @param obj The object to control.
		 * @param group Optionally provide an AudibleGroup this belongs to, for automatic cleanup in the group.
		 */
		public function AudibleObject(audibleId:String,obj:*,group:AudibleGroup=null):void
		{
			mu=MathUtils.gi();
			id=audibleId;
			this.obj=obj;
			if(group)audibleGroup=group;
			if(obj is Sound)type="s";
			else if("soundTransform" in obj)type="o";
			else throw new Error("The volume for the object added cannot be controled, it must be a Sound or contain a {soundTransform} property.");
			progressTimer=new Timer(300);
			transform=new SoundTransform();
			pausePosition=0;
			muted=false;
			ops={};
		}
		
		/**
		 * Play this audible object.
		 * 
		 * <p>Available options:</p>
		 * <ul>
		 * <li>volume (Number) - The volume to play the audio at.</li>
		 * <li>startTime (Number) - A start offset in milliseconds to start playing the audio from.</li>
		 * <li>loops (Number) - The number of times to loop the sound.</li>
		 * <li>panning (Number) - A panning value for the audio.</li>
		 * <li>restartIfPlaying (Boolean) - If this audible object is playing, and you call play again, it will (by defualt) not do anything,
		 * unless this option is true, which will restart the playing sound.</li>
		 * </ul>
		 * 
		 * @param ops Play options.
		 */
		public function play(ops:Object=null):void
		{
			if(type=="o")
			{
				trace("WARNING: An audible object cannot 'play' a display object it's managing.");
				return;
			}
			if(!ops&&isPlaying)return;
			if(!ops.restartIfPlaying&&isPlaying)return;
			if(isPlaying)
			{
				SoundManager3.USED_CHANNELS--;
				removeListener();
				channel.stop();
			}
			if(SoundManager3.USED_CHANNELS>=32)
			{
				trace("WARNING: No sound channels are available. Not playing anything for {"+id+"}.");
				if(audibleGroup)
				{
					audibleGroup.cleanupAudibleObject(this);
					dispose();
				}
				return;
			}
			this.ops=ops;
			var startTime:Number=(ops.starTime)?ops.starTime:0;
			var loops:Number=(ops.loops)?ops.loops:0;
			var panning:Number=(ops.panning)?ops.panning:0;
			var volume:Number=(ops.volume)?ops.volume:1;
			if(transform.volume&&!this.ops.volume)volume=transform.volume;
			transform=new SoundTransform(volume,panning);
			if(loops>0)loopWatcher=new Timer(obj.length);
			SoundManager3.USED_CHANNELS++;
			if(SoundManager3.USED_CHANNELS==32&&ops.onMaximumChannelsReached)ops.onMaximumChannelsReached();
			channel=obj.play(startTime,loops,transform);
			dispatchEvent(new AudioEvent(AudioEvent.START));
			isPlaying=true;
			addListener();
			if(loopWatcher)loopWatcher.start();
			if(hasEventListener(AudioEvent.PROGRESS)&&!progressTimer.running)progressTimer.start();
		}
		
		/**
		 * Add listeners for loop and complete.
		 */
		private function addListener():void
		{
			if(loopWatcher)loopWatcher.addEventListener(TimerEvent.TIMER,onLoop,false,0,true);
			channel.addEventListener(Event.SOUND_COMPLETE,onComplete,false,0,true);
		}
		
		/**
		 * Remove listeners for loop and complete.
		 */
		private function removeListener():void
		{
			if(loopWatcher)loopWatcher.removeEventListener(TimerEvent.TIMER,onLoop);
			channel.removeEventListener(Event.SOUND_COMPLETE,onComplete);
		}
		
		/**
		 * When a loop occurs.
		 */
		private function onLoop(e:TimerEvent):void
		{
			loops++;
			dispatchEvent(new AudioEvent(AudioEvent.LOOPED));
		}
		
		/**
		 * On complete.
		 */
		private function onComplete(e:Event):void
		{
			if(loopWatcher)loopWatcher.stop();
			isPlaying=false;
			SoundManager3.USED_CHANNELS--;
			dispatchEvent(new AudioEvent(AudioEvent.COMPLETE));
			if(audibleGroup)
			{
				audibleGroup.cleanupAudibleObject(this);
				dispose();
			}
			progressTimer.stop();
		}

		/**
		 * Stop ths audible object.
		 */
		public function stop():void
		{
			if(type=="o")return;
			if(loopWatcher)loopWatcher.stop();
			channel.stop();
			if(isPlaying)SoundManager3.USED_CHANNELS--;
			isPlaying=false;
			dispatchEvent(new AudioEvent(AudioEvent.STOP));
			if(audibleGroup)
			{
				audibleGroup.cleanupAudibleObject(this);
				dispose();
			}
			progressTimer.stop();
		}
		
		/**
		 * Pause this audible object.
		 */
		public function pause():void
		{
			if(type=="o")return;
			if(isPaused)return;
			if(isPlaying)SoundManager3.USED_CHANNELS--;
			isPlaying=false;
			if(loopWatcher)loopWatcher.stop();
			dispatchEvent(new AudioEvent(AudioEvent.PAUSED));
			if(audibleGroup)audibleGroup.cleanupAudibleObject(this);
			pausePosition=channel.position;
			channel.stop();
			progressTimer.stop();
			isPaused=true;
		}
		
		/**
		 * Resume this audible object.
		 */
		public function resume():void
		{
			if(type=="o")return;
			if(isPlaying)return;
			if(!isPaused)return;
			if(!isPlaying)SoundManager3.USED_CHANNELS++;
			isPlaying=true;
			isPaused=false;
			removeListener();
			var startTime:Number=pausePosition;
			var loops:Number=(ops.loops)?ops.loops:0;
			channel=obj.play(startTime,loops,transform);
			if(!muted)channel.soundTransform=transform;
			dispatchEvent(new AudioEvent(AudioEvent.RESUMED));
			addListener();
			if(loopWatcher)loopWatcher.start();
			if(!progressTimer.running&&hasEventListener(AudioEvent.PROGRESS))progressTimer.start();
		}
		
		/**
		 * Increase the volume of this audible object.
		 * 
		 * @param step The amount to increase the volume by.
		 */
		public function increaseVolume(step:Number=.1):void
		{
			transform.volume+=step;
			if(type=="s")channel.soundTransform=transform;
			else if(type=="o")obj.soundTransform=transform;
		}
		
		/**
		 * Decrease the volume of this audible object.
		 * 
		 * @param step The amount to decrease the volume by.
		 */
		public function decreaseVolume(step:Number=.1):void
		{
			if(transform.volume==0)return;
			transform.volume-=step;
			if(type=="s")channel.soundTransform=transform;
			else if(type=="o")obj.soundTransform=transform;
		}
		
		/**
		 * Mute this audible object.
		 */
		public function mute():void
		{
			if(muted)return;
			if(transform.volume==0)return;
			muted=true;
			vol=transform.volume;
			transform.volume=0;
			if(type=="s")channel.soundTransform=transform;
			else if(type=="o")obj.soundTransform=transform;
			dispatchEvent(new AudioEvent(AudioEvent.MUTE));
		}
		
		/**
		 * Unmute this audible object.
		 */
		public function unMute():void
		{
			if(!muted)return;
			muted=false;
			transform.volume=vol;
			if(type=="s")channel.soundTransform=transform;
			else if(type=="o")obj.soundTransform=transform;
			dispatchEvent(new AudioEvent(AudioEvent.UNMUTE));
		}
		
		/**
		 * Toggle mute.
		 */
		public function toggleMute():void
		{
			if(muted)unMute();
			else mute();
		}
		
		/**
		 * Tween the panning to a new pan value.
		 * 
		 * @param pan The new pan level.
		 * @param duration The time it takes to tween the panning.
		 */
		public function panTo(pan:Number,duration:Number=.3):void
		{
			TweenMax.to(this,duration,{pn:pan});
		}
		
		/**
		 * Update the panning of this audio object.
		 * 
		 * @param panning The new panning value.
		 * @param persistent Whether or not the new panning will apply when the sound is played more than once.
		 */
		public function set panning(panning:Number):void
		{
			if(transform.pan!=panning)dispatchEvent(new AudioEvent(AudioEvent.PAN_CHANGE));
			if(transform.pan==panning)return;
			transform.pan=panning;
			if(type=="s")channel.soundTransform=transform;
			else obj.soundTransform=transform;
		}
		
		/**
		 * Update the panning of this audio object.
		 * 
		 * @param panning The new panning value.
		 * @param persistent Whether or not the new panning will apply when the sound is played more than once.
		 */
		public function get panning():Number
		{
			return transform.pan;
		}
		
		/**
		 * Set the panning.
		 */
		public function set pn(panning:Number):void
		{
			transform.pan=panning;
			if(type=="s")channel.soundTransform=transform;
			else obj.soundTransform=transform;
		}
		
		/**
		 * A tween property for panning.
		 */
		public function get pn():Number
		{
			return transform.pan;
		}
		
		/**
		 * Set the volume for this audible object.
		 * 
		 * @param level The volume level.
		 */
		public function set volume(level:Number):void
		{
			if(transform.volume!=level)dispatchEvent(new AudioEvent(AudioEvent.VOLUME_CHANGE));
			transform.volume=level;
			if(type=="s")
			{
				if(!channel)return;
				channel.soundTransform=transform;
			}
			else obj.soundTransform=transform;
		}
		
		/**
		 * The volume for this audible object.
		 */
		public function get volume():Number
		{
			return transform.volume;
		}
		
		/**
		 * Tween the volume to a certain level, in the duration specified.
		 * 
		 * @param level The new volume level.
		 * @param duration The time it takes to tween to the new level.
		 */
		public function volumeTo(level:Number,duration:Number=.3):void
		{
			TweenMax.to(this,duration,{vl:level});
		}
		
		/**
		 * A tween property for volume.
		 */
		public function get vl():Number
		{
			return transform.volume;
		}
		
		/**
		 * Tween volume.
		 */
		public function set vl(level:Number):void
		{
			transform.volume=level;
			if(type=="s") channel.soundTransform=transform;
			else obj.soundTransform=transform;
		}
		
		/**
		 * Seek to a position in the sound - this is only
		 * supported if the object being controlled is a Sound
		 * instance.
		 * 
		 * @param position The position of the sound to seek to.
		 */
		public function seek(position:Number):void
		{
			if(type=="o")
			{
				trace("WARNING: Seek is not supported for non Sound instances.");
				return;
			}
			if(!position) return;
			removeListener();
			channel.stop();
			var lps:int=(ops.loops)?ops.loops:0;
			if(lps>0 && loops>1) lps=loops-lps;
			if(lps<0)lps=0;
			channel=Sound(obj).play(position,lps,transform);
		}
		
		/**
		 * Seek to a percent of the sound - this is only
		 * supported if the object being controlled is a Sound
		 * instance.
		 * 
		 * @param percent The percent to seek to.
		 */
		public function seekToPercent(percent:Number):void
		{
			if(type=="o")
			{
				trace("WARNING: Seek to percent is not supported when managing display objects.");
				return;
			}
			seek(Sound(obj).length*percent/100);
		}
		
		/**
		 * Seek to a pixel (you must first set pixels to fill) - this is only
		 * supported if the object being controlled is a Sound
		 * instance.
		 * 
		 * @param pixel The pixel to seek to.
		 */
		public function seekToPixel(pixel:Number):void
		{
			if(type=="o")
			{
				trace("WARNING: Seek to pixels is not supported when managing display objects.");
				return;
			}
			seek(mu.spread(pixel,pixelsToFill,Sound(obj).length));
		}
		
		/**
		 * Get the percentage of the sound that has played, only
		 * supported for Sound instances.
		 */
		public function percentPlayed():Number
		{
			if(type=="o")
			{
				trace("WARNING: A display object does not have a percent played value.");
				return -1;
			}
			if(channel.position==0||!channel||!channel.position)return 0;
			return Sound(obj).length/channel.position;
		}
		
		/**
		 * Get the amount of pixels that have played, only
		 * supported for Sound instances.
		 */
		public function pixelsPlayed():int
		{
			if(type=="o")
			{
				trace("WARNING: A display object does not have a pixels played value.");
				return -1;
			}
			if(!_pixelsToFill)
			{
				trace("WARNING: The pixels to fill is not set. It must be set before using pixelsPlayed()");
				return -1;
			}
			return mu.spread(channel.position,Sound(obj).length,_pixelsToFill);
		}

		/**
		 * The amount of pixels to fill for this audio object - this is only
		 * supported if the object being controlled is a Sound
		 * instance.
		 * 
		 * @param pixels The amount of pixels to fill.
		 */		
		public function set pixelsToFill(pixels:int):void
		{
			_pixelsToFill=pixels;
		}
		
		/**
		 * The amount of pixels to fill for this audio object - this is only
		 * supported if the object being controlled is a Sound
		 * instance.
		 */
		public function get pixelsToFill():int
		{
			return _pixelsToFill;
		}
		
		/**
		 * Dispose of this audible object.
		 */
		public function dispose():void
		{
			removeListener();
			progressTimer.stop();
			progressTimer.removeEventListener(TimerEvent.TIMER,onTick);
			id=null;
			obj=null;
			type=null;
			transform=null;
			vol=NaN;
			isPlaying=false;
			loops=NaN;
			loopWatcher=null;
			ops=null;
			audibleGroup=null;
			channel=null;
			muted=false;
			pausePosition=NaN;
			_pixelsToFill=0;
			mu=null;
		}
		
		/**
		 * Starts the progress logic.
		 */
		private function startProgressEvents():void
		{
			progressTimer.addEventListener(TimerEvent.TIMER,onTick,false,0,true);
			if(!isPlaying)return;
			progressTimer.start();
		}
		
		/**
		 * Stops the progress logic.
		 */
		private function stopProgressEvents():void
		{
			progressTimer.stop();
			progressTimer.removeEventListener(TimerEvent.TIMER,onTick);
		}
		
		/**
		 * On tick for progres timer.
		 */
		private function onTick(ev:TimerEvent):void
		{
			if(!isPlaying)return;
			var e:AudioEvent=new AudioEvent(AudioEvent.PROGRESS,false,true);
			e.pixelsPlayed=pixelsPlayed();
			e.percentPlayed=percentPlayed();
			dispatchEvent(e);
		}
		
		/**
		 * @private
		 */
		override public function addEventListener(type:String,listener:Function,useCapture:Boolean=false,priority:int=0,useWeakReference:Boolean=false):void
		{
			super.addEventListener(type,listener,useCapture,priority,useWeakReference);
			if(type==AudioEvent.PROGRESS&&!hasEventListener(AudioEvent.PROGRESS))startProgressEvents();
		}
		
		/**
		 * @private
		 */
		override public function removeEventListener(type:String,listener:Function,useCapture:Boolean=false):void
		{
			super.removeEventListener(type,listener,useCapture);
			if(type==AudioEvent.PROGRESS&&!hasEventListener(AudioEvent.PROGRESS))stopProgressEvents();
		}	}}