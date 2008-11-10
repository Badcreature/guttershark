package net.guttershark.support.soundmanager 
{
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;		

	/**
	 * The AudibleGroup class enables you to control multiple
	 * AudibleObject instances, which allows you to control
	 * volume properties, and volume centric functionality
	 * related to multiple objects.
	 */
	public class AudibleGroup extends EventDispatcher
	{
		
		/**
		 * The group id.
		 */
		public var groupId:String;
		
		/**
		 * Group options.
		 */
		private var options:Object;
		
		/**
		 * All audibles that have been added.
		 */
		private var audibles:Dictionary;
		
		/**
		 * Stored audible options.
		 */
		private var audibleOptions:Dictionary;
		
		/**
		 * All objects that aren't a sound instance.
		 */
		private var objs:Dictionary;
		
		/**
		 * All playing audible objects.
		 */
		private var playingObjs:Array;
		
		/**
		 * A sound transform that keeps track of volume,
		 * which is applied to sounds that are playing- if no
		 * custom volume is specified in it's play options.
		 */
		private var transform:SoundTransform;

		/**
		 * Constructor for AudibleGroup instances.
		 * 
		 * @param groupId The group id.
		 * @param groupOptions Group play options.
		 */
		public function AudibleGroup(groupId:String):void
		{
			this.groupId=groupId;
			objs=new Dictionary();
			audibles=new Dictionary();
			audibleOptions=new Dictionary();
			transform=new SoundTransform();
			playingObjs=[];
		}
		
		/**
		 * Check whether or not an audible is playing.
		 * 
		 * @param audibleId The audible id to check.
		 */
		public function isAudiblePlaying(audibleId:String):Boolean
		{
			if(!hasAudible(audibleId))return false;
			var i:int=0;
			var l:int=playingObjs.length;
			for(i;i<l;i++)if(AudibleObject(playingObjs[i]).id==audibleId)return true;
			return false;
		}
		
		/**
		 * Check if this group contains an audible.
		 * 
		 * @param audibleId The audible id to check.
		 */
		public function hasAudible(audibleId:String):Boolean
		{
			return !(audibles[audibleId]==null||audibles[audibleId]==undefined);
		}
		
		/**
		 * Add an audible to this group.
		 * 
		 * @param audibleId The audible id.
		 * @param obj The object to control.
		 * @param options Perseistent play options for the added audible.
		 */
		public function addAudible(audibleId:String,obj:*,options:Object=null):void
		{
			if(!(obj is Sound)&&!("soundTransform" in obj)) throw new Error("The volume for the object added cannot be controled, it must be a Sound or contain a {soundTransform} property.");
			if(!(obj is Sound))
			{
				var ao:AudibleObject=new AudibleObject(audibleId,obj);
				objs[audibleId]=ao;
			}
			audibles[audibleId]=obj;
			if(options)
			{
				audibleOptions[audibleId]=options;
				if(options.onAudibleAdded)options.onAudibleAdded();
			}
		}
		
		/**
		 * Remove an audible from this group.
		 * 
		 * @param audibleId The audible to remove.
		 */
		public function removeAudible(audibleId:String):void
		{
			if(objs[audibleId])
			{
				objs[audibleId].dispose();
				objs[audibleId]=null;
				delete objs[audibleId];
			}
			if(audibles[audibleId])
			{
				audibles[audibleId]=null;
				delete audibles[audibleId];
			}
			if(audibleOptions[audibleId])
			{
				audibleOptions[audibleId]=null;
				delete audibleOptions[audibleId];
			}
			var i:int=0;
			var l:int=playingObjs.length;
			for(i;i<l;i++)
			{
				if(AudibleObject(playingObjs[i]).id==audibleId)
				{
					AudibleObject(playingObjs[i]).stop();
					playingObjs.splice(i,1);
				}
			}
			if(options.onAudibleRemoved)options.onAudibleRemoved();
		}
		
		/**
		 * @private
		 * for use from the SoundManager.
		 */
		public function getRawAudible(audibleId:String):*
		{
			if(!hasAudible(audibleId))return null;
			return audibles[audibleId];
		}
		
		/**
		 * Play an audible object.
		 * 
		 * @param audibleId The audible to play.
		 * @param options The play options.
		 */
		public function playAudible(audibleId:String,options:Object=null):void
		{
			if(!hasAudible(audibleId))return;
			var ao:AudibleObject=new AudibleObject(audibleId,audibles[audibleId],this);
			playingObjs.push(ao);
			if(options&&!options.volume)options.volume=transform.volume;
			if(options)ao.play(options);
			else if(!options&&audibleOptions[audibleId])ao.play(audibleOptions[audibleId]);
			else ao.play({volume:transform.volume});
		}
		
		/**
		 * Play all audible objects in this group.
		 * 
		 * @param options The group play options.
		 */
		public function playAll(options:Object=null):void
		{
			if(options)this.options=options;
			var key:String;
			var ao:AudibleObject;
			for(key in audibles)
			{
				ao=new AudibleObject(key,audibles[key],this);
				if(audibleOptions[key])ao.play(audibleOptions[key]);
				else ao.play({volume:transform.volume});
				playingObjs.push(ao);
			}
			dispatchEvent(new AudioEvent(AudioEvent.PLAY_ALL));
		}

		/**
		 * Stop a playing audible.
		 * 
		 * @param audibleId The playing audible id.
		 */
		public function stopAudible(audibleId:String):void
		{
			if(!isAudiblePlaying(audibleId))return;
			var i:int=0;
			var l:int=playingObjs.length;
			for(i;i<l;i++)
			{
				var o:AudibleObject=AudibleObject(playingObjs[i]);
				if(o.id==audibleId)
				{
					o.stop();
					playingObjs.splice(i,1);
				}
			}
		}
		
		/**
		 * Stop all playing audibles.
		 */
		public function stopAll():void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			for(i;i<l;i++)AudibleObject(playingObjs[i]).stop();
			dispatchEvent(new AudioEvent(AudioEvent.STOP_ALL));
		}

		/**
		 * Increase volume for the group.
		 * 
		 * @param step The amount to increase the volume by.
		 */
		public function increaseVolume(step:Number=.1):void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudibleObject;
			for(i;i<l;i++)AudibleObject(playingObjs[i]).increaseVolume(step);
			for each(ao in objs)ao.increaseVolume(step);
			dispatchEvent(new AudioEvent(AudioEvent.VOLUME_CHANGE));
		}

		/**
		 * Increase volume for a specific audible. If the
		 * audible is not playing, the volume will not increase
		 * unless you specify <em>true</em> for the <em>persist</em>
		 * parameter, which will cause the volume to increase for
		 * subsequent plays.
		 * 
		 * @param audibleId The audible whos volume will be increased.
		 * @param step The amount to increase the volume by.
		 * @param persist Whether or not the increase is applied to subsequent plays.
		 */
		public function increaseVolumeForAudible(audibleId:String,step:Number=.1,persist:Boolean=false):void
		{
			if(!hasAudible(audibleId))return;
			var ao:AudibleObject;
			var i:int=0;
			var l:int=playingObjs.length;
			for(i;i<l;i++)
			{
				ao=AudibleObject(playingObjs[i]);
				if(ao.id==audibleId)ao.increaseVolume(step);
			}
			if(persist)
			{
				if(audibleOptions[audibleId])audibleOptions[audibleId].volume+=step;
				else
				{
					audibleOptions[audibleId]={};
					audibleOptions[audibleId].volume=transform.volume+step;
				}
			}
		}

		/**
		 * Decrease the group volume.
		 * 
		 * @param step The amount to decrease the volume by.
		 */
		public function decreaseVolume(step:Number=.1):void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudibleObject;
			for(i;i<l;i++)AudibleObject(playingObjs[i]).decreaseVolume(step);
			for each(ao in objs)ao.decreaseVolume(step);
			dispatchEvent(new AudioEvent(AudioEvent.VOLUME_CHANGE));
		}
		
		/**
		 * Decrease a specific audible's volume. If the
		 * audible is not playing, the volume will not decrease
		 * unless you specify <em>true</em> for the <em>persist</em>
		 * parameter, which will cause the volume to decrease for
		 * subsequent plays.
		 * 
		 * @param audibleId The audible whose volume will be decreased.
		 * @param step The amount to decrease the volume by.
		 * @param persist Whether or not the decrease is applied to subsequent plays.
		 */
		public function decreaseVolumeForAudible(audibleId:String,step:Number=.1,persist:Boolean=true):void
		{
			if(!hasAudible(audibleId))return;
			var ao:AudibleObject;
			var i:int=0;
			var l:int=playingObjs.length;
			for(i;i<l;i++)
			{
				ao=AudibleObject(playingObjs[i]);
				if(ao.id==audibleId)ao.decreaseVolume(step);
			}
			if(persist)
			{
				if(audibleOptions[audibleId]&&audibleOptions[audibleId].volume)audibleOptions[audibleId].volume-=step;
				else
				{
					audibleOptions[audibleId]={};
					audibleOptions[audibleId].volume=transform.volume-step;
				}
			}
		}
		
		/**
		 * Set custom levels for any audible objects.
		 * 
		 * @example Setting custom levels:
		 * <listing>	
		 * setLevels(["sparkle","blip"],[.3,.5]);
		 * </listing>
		 * 
		 * @param audibleIds The audible objects whose volume level will be update.
		 * @param levels An array of levels that correlate to the audible objects' volume.
		 * @param persistent Whether or not the level update will persist when a sound is played more than once.
		 */
		public function setLevels(audibleIds:Array,levels:Array,persistent:Boolean=true):void
		{
			if(!audibleIds||!levels)return;
			if(audibleIds.length!=levels.length) throw new Error("There must be equal parts in the two arrays passed, for the audible ids, and the levels");
			var i:int=0;
			var l:int=audibleIds.length;
			for(i;i<l;i++)
			{
				AudibleObject(playingObjs[audibleIds[i]]).volume=levels[i];
				if(!persistent)continue;
				if(audibleOptions[audibleIds[i]])audibleOptions[audibleIds[i]].volume=levels[i];
				else
				{
					audibleOptions[audibleIds[i]]={};
					audibleOptions[audibleIds[i]].volume=levels[i];
				}
			}
		}
		
		/**
		 * Set the volume.
		 */
		public function set volume(level:Number):void
		{
			if(transform.volume!=level&&options.onVolumeChange)dispatchEvent(new AudioEvent(AudioEvent.VOLUME_CHANGE));
			transform.volume=level;
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudibleObject;
			for(i;i<l;i++) AudibleObject(playingObjs[i]).volume=transform.volume;
			for each(ao in objs) ao.volume=transform.volume;
		}
		
		/**
		 * The group volume.
		 */
		public function get volume():Number
		{
			return transform.volume;
		}
		
		/**
		 * Get's an audible object.
		 */
		private function getAudible(audibleId:String):AudibleObject
		{
			if(!isAudiblePlaying(audibleId))return null;
			var i:int=0;
			var l:int=playingObjs.length;
			for(i;i<l;i++)if(AudibleObject(playingObjs[i]).id==audibleId)return AudibleObject(playingObjs[i]);
			return null;
		}

		/**
		 * Get the volume of a specific audible. If the audible
		 * is not playing, and there are no play options associated
		 * with the autible, -1 is returned.
		 * 
		 * @param audibleId The audible id.
		 */
		public function getAudibleVolume(audibleId:String):Number
		{
			if(!hasAudible(audibleId))return -1;
			if(isAudiblePlaying(audibleId)) return AudibleObject(getAudible(audibleId)).volume;
			else if(!audibleOptions[audibleId]&&!isAudiblePlaying(audibleId)) return -1;
			else if(audibleOptions[audibleId]&&audibleOptions[audibleId].volume) return audibleOptions[audibleId].volume;
			return -1;
		}
		
		/**
		 * Set the level for a specific audible.
		 * 
		 * @param audibleId The audible id.
		 * @param level The new volume level.
		 */
		public function setVolumeForAudible(audibleId:String,level:Number,persist:Boolean):void
		{
			if(isAudiblePlaying(audibleId)) AudibleObject(getAudible(audibleId)).volume=level;
			else if(persist)
			{
				if(audibleOptions[audibleId])audibleOptions[audibleId].volume=level;
				else
				{
					audibleOptions[audibleId]={};
					audibleOptions[audibleId].volume=level;
				}
			}
		}
		
		/**
		 * Pause the group.
		 */
		public function pause():void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudibleObject;
			dispatchEvent(new AudioEvent(AudioEvent.PAUSED));
			for(i;i<l;i++) AudibleObject(playingObjs[i]).pause();
			for each(ao in objs) ao.pause();
		}
		
		/**
		 * Pause an audible in this group.
		 * 
		 * @param audibleId The audible to pause.
		 */
		public function pauseAudible(audibleId:String):void
		{
			if(!isAudiblePlaying(audibleId))return;
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudibleObject;
			for(i;i<l;i++)
			{
				ao=AudibleObject(playingObjs[i]);
				if(ao.id==audibleId)ao.pause();
			}
		}

		/**
		 * Resume this group.
		 */
		public function resume():void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudibleObject;
			dispatchEvent(new AudioEvent(AudioEvent.RESUMED));
			for(i;i<l;i++)AudibleObject(playingObjs[i]).resume();
			for each(ao in objs)ao.resume();
		}
		
		/**
		 * Resume an audible in this group.
		 */
		public function resumeAudible(audibleId:String):void
		{
			if(!hasAudible(audibleId))return;
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudibleObject;
			for(i;i<l;i++)
			{
				ao=AudibleObject(playingObjs[i]);
				if(ao.id==audibleId)ao.resume();
			}
		}
		
		/**
		 * Stop this group.
		 */
		public function stop():void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudibleObject;
			dispatchEvent(new AudioEvent(AudioEvent.STOP));
			for(i;i<l;i++)AudibleObject(playingObjs[i]).stop();
			for each(ao in objs)ao.stop();
		}
		
		/**
		 * Mute this group.
		 */
		public function mute():void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudibleObject;
			dispatchEvent(new AudioEvent(AudioEvent.MUTE));
			for(i;i<l;i++)AudibleObject(playingObjs[i]).mute();
			for each(ao in objs)ao.mute();
		}
		
		/**
		 * Mute an audible playing from this group.
		 * 
		 * @param audibleId The audible to mute.
		 */
		public function muteAudible(audibleId:String):void
		{
			if(!isAudiblePlaying(audibleId))return;
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudibleObject;
			for(i;i<l;i++)
			{
				ao=AudibleObject(playingObjs[i]);
				if(ao.id==audibleId)ao.mute();
			}
		}
				/**
		 * Un-mute this group.
		 */
		public function unMute():void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudibleObject;
			dispatchEvent(new AudioEvent(AudioEvent.UNMUTE));
			for(i;i<l;i++)AudibleObject(playingObjs[i]).unMute();
			for each(ao in objs)ao.unMute();
		}
		
		/**
		 * Un-mute an audible playing from this group.
		 * 
		 * @param audibleId The audible to unmute.
		 */
		public function unMuteAudible(audibleId:String):void
		{
			if(!isAudiblePlaying(audibleId))return;
			var i:int=0;
			var l:int=playingObjs.length;
			var ao:AudibleObject;
			for(i;i<l;i++)
			{
				ao=AudibleObject(playingObjs[i]);
				if(ao.id==audibleId)ao.unMute();
			}
		}
		
		/**
		 * @private
		 * Cleans up an audible object after it's not needed. This is
		 * called from a child AudibleObject this group is managing.
		 * 
		 * @param ao The audible object to cleanup.
		 */
		public function cleanupAudibleObject(ao:AudibleObject):void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			for(i;i<l;i++)if(playingObjs[i]===ao)playingObjs.splice(i,1);
		}
		
		/**
		 * Dispose of this group.
		 */
		public function dispose():void
		{
			var i:int=0;
			var l:int=playingObjs.length;
			for(i;i<l;i++) AudibleObject(playingObjs[i]).dispose();
			var ao:AudibleObject;
			for each(ao in objs)ao.dispose();
			groupId=null;
			audibleOptions=null;
			var key:String;
			for(key in audibles)
			{
				audibles[key]=null;
				delete audibles[key];
			}
			for(key in objs)
			{
				objs[key]=null;
				delete objs[key];
			}
			playingObjs=null;
			transform=null;
		}	}}