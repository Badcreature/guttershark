package net.guttershark.video
{
	
	import fl.video.FLVPlayback;
	import fl.video.MetadataEvent;
	import fl.video.VideoEvent;
	import fl.video.VideoPlayer;
	
	import flash.display.MovieClip;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import gs.TweenLite;

	/**
	 * Video queue manager that handles playing HTTP and Streaming
	 * content in a queue fashion.
	 */
	public class FLVPlaybackQueueManager extends MovieClip
	{
		
		/**
		 * Identifer for playing this manager in the "right" direction.
		 * In other words - forward.
		 */
		public static const RIGHT:String = "right";
		
		/**
		 * Identifier for playing this manager in the "left" direction.
		 * In other words - backwords.
		 */
		public static const LEFT:String = "left";
		
		/**
		 * HTTP 1 Playback wrapper instance.
		 */
		public var playerWrapper1:FLVPlaybackWrapper;
		
		/**
		 * HTTP 2 Playbacke wrapper instance.
		 */
		public var playerWrapper2:FLVPlaybackWrapper;
		
		/**
		 * RTMP 1 Playback wrapper instance.
		 */
		public var streamReadyWrapper1:FLVPlaybackWrapper;
		
		/**
		 * RTMP 2 Playback wrapper instance.
		 */
		public var streamReadyWrapper2:FLVPlaybackWrapper;
		
		/**
		 * The crossfade duration between two clips.
		 */
		public var crossfadeDuration:Number = 1;
		
		/**
		 * The time (in seconds) remaining on a playing clip
		 * that triggers the next clip to play.
		 */
		public var continueWhenTimeLeft:Number = 3;
		
		/**
		 * The direction to play clips in.
		 */
		public var direction:String = FLVPlaybackQueueManager.RIGHT;
		
		/**
		 * The queue of videos currently playing over.
		 */
		private var _queue:Array;
		
		/**
		 * The queue index.
		 */
		private var queueIndex:int;
		
		/**
		 * One of a couple timing flags.
		 */
		private var playedNext:Boolean = false;
		
		/**
		 * Crossfading flag.
		 */
		private var crossfading:Boolean;
		
		/**
		 * If manager is waiting for a stream to kick in.
		 */
		private var waitingForStream:Boolean = false;
		
		/**
		 * If a stream is 'going out', in other words fading out
		 * into the next clip.
		 */
		private var streamGoingOut:Boolean = false;
		
		/**
		 * The time (in milliseconds) before a stream attempt should
		 * be considered a fail.
		 */
		private var _streamFailTime:Number;
		
		/**
		 * The timeout used to trigger fail.
		 */
		private var streamFailTimeout:Number;
		
		/**
		 * Internal volume set on all players.
		 */
		private var _volume:int;
		
		/**
		 * Nan count is used for counting how many times 
		 * an update event is triggered with the "playheadTime"
		 * property being NaN. If it reaches this NaN count, 
		 * the next video is played.
		 */
		private var nanCount:int;
		
		/**
		 * The currently visible and active player.
		 */
		private var activePlayer:FLVPlaybackWrapper;
		
		/**
		 * The polling interval to keep videos playing in case
		 * of non-wanted stops.
		 */
		private var stoppedPoll:Number;
		
		/**
		 * If startPlaying has been called.
		 */
		private var started:Boolean = false;
		
		/**
		 * Internal buffer time, used to reset buffertimes
		 * on stream players after it's finished or closed.
		 */
		private var _buffTime:Number;
		
		/**
		 * Internal flag for pausing.
		 */
		private var _paused:Boolean;
		
		/**
		 * Internal flag used to count times when a video
		 * is paused.
		 */
		private var failedPlayingCount:int = -1;
		
		/**
		 * New managed video player. A movie clip should
		 * be setup with four FLVPlaybackWrappers in it.
		 */
		public function FLVPlaybackQueueManager()
		{
			var updateTime:Number = 1000;
			playerWrapper1.id = "playerWrapper1";
			playerWrapper1.alpha = 0;
			playerWrapper1.player.volume = 0;
			playerWrapper1.player.playheadUpdateInterval = updateTime;
			
			playerWrapper2.id = "playerWrapper2";
			playerWrapper2.alpha = 0;
			playerWrapper2.player.volume = 0;
			playerWrapper2.player.playheadUpdateInterval = updateTime;
			
			streamReadyWrapper1.id = "streamReadyWrapper1";
			streamReadyWrapper1.alpha = 0;
			streamReadyWrapper1.player.volume = 0;
			streamReadyWrapper1.player.playheadUpdateInterval = updateTime;
			
			streamReadyWrapper2.id = "streamReadyWrapper2";
			streamReadyWrapper2.alpha = 0;
			streamReadyWrapper2.player.volume = 0;
			streamReadyWrapper2.player.playheadUpdateInterval = updateTime;
			
			removeChild(playerWrapper1);
			removeChild(playerWrapper2);
			removeChild(streamReadyWrapper1);
			removeChild(streamReadyWrapper2);
			
			_paused = false;
			_volume = 1;
			nanCount = 0;
		}
		
		/**
		 * Set the queue to loop around, an array of file locations.
		 */
		public function set queue(value:Array):void
		{
			if(!value.length > 0) throw new Error("No queue was given.");
			queueIndex = -1;
			_queue = value;
		}
		
		/**
		 * Restart the loop after the current video is done.
		 */
		public function restartAfterCurrent():void
		{
			queueIndex = -1;
		}
		
		/**
		 * Set the time(in seconds) allowed for a stream attempt, before it is considered
		 * a failed attempt.
		 */
		public function set streamConsideredFailTimeout(seconds:Number):void
		{
			_streamFailTime = seconds;
		}
		
		/**
		 * Set's the scale on all players.
		 */
		public function set scale(value:String):void
		{
			playerWrapper1.player.scaleMode = value;
			playerWrapper2.player.scaleMode = value;
			streamReadyWrapper1.player.scaleMode = value;
			streamReadyWrapper2.player.scaleMode = value;
		}
		
		/**
		 * Set's the global volume.
		 */
		public function set volume(value:int):void
		{
			_volume = value;
			if(activePlayer)
				activePlayer.player.volume = value;
		}
		
		/**
		 * Set's the alignment on all players.
		 */
		public function set align(value:String):void
		{
			playerWrapper1.player.align = value;
			playerWrapper2.player.align = value;
			streamReadyWrapper1.player.align = value;
			streamReadyWrapper2.player.align = value;
		}
		
		/**
		 * Set's auto play on all players.
		 */
		public function set autoPlay(value:Boolean):void
		{
			playerWrapper1.player.autoPlay = value;
			playerWrapper2.player.autoPlay = value;
			streamReadyWrapper1.player.autoPlay = value;
			streamReadyWrapper2.player.autoPlay = value;
		}
		
		/**
		 * Set's bufferTime on all players.
		 */
		public function set bufferTime(time:Number):void
		{
			_buffTime = time;
			playerWrapper1.player.bufferTime = time;
			playerWrapper2.player.bufferTime = time;
			streamReadyWrapper2.player.bufferTime = time;
			streamReadyWrapper1.player.bufferTime = time;
		}
		
		public function pause(val:Boolean):void
		{
			activePlayer.player.pause();
			_paused = val;
		}
		
		/**
		 * The remaining clips in the queue intil a loop occures.
		 */
		public function get remainingClipsUntilLoop():int
		{
			return (_queue.length - queueIndex);
		}
		
		/**
		 * Returns the currently playing source.
		 */
		public function get source():String
		{
			return activePlayer.player.source;
		}
		
		/**
		 * Is the active player RTMP.
		 */
		public function get isRTMP():Boolean
		{
			return activePlayer.player.isRTMP;
		}
		
		/**
		 * Set the ncManager class's timeout on the two stream
		 * ready wrappers.
		 */
		public function set ncManagerTimeout(milliseconds:Number):void
		{
			try
			{
				streamReadyWrapper1.player.ncMgr.timeout = milliseconds;
				streamReadyWrapper2.player.ncMgr.timeout = milliseconds;	
			}
			catch(e:*)
			{
				streamReadyWrapper1.player.ncMgr.timeout = 20000;
				streamReadyWrapper2.player.ncMgr.timeout = 20000;
			}
		}
		
		/**
		 * Start playing
		 */
		public function startPlaying():void
		{
			started = true;
			playNext();
		}
		
		/**
		 * Interupt the queue and play an HTTP file.
		 */
		public function playHTTPNow(source:String):void
		{
			playedNext = true;
			var player:FLVPlaybackWrapper = getPlayer(source);
			addPlayEventListener(player);
			player.player.source = source;
			player.player.seek(0);
			player.player.play();
		}
		
		/**
		 * Uses the stream ready wrapper to load the stream, 
		 * then play it when it's ready.
		 */
		public function playStream(source:String):void
		{
			var player:FLVPlaybackWrapper = getPlayer(source);
			try
			{
				player.player.getVideoPlayer(0).close();
			}catch(e:*){}
			
			if(!_streamFailTime)
				_streamFailTime = 30000;
			
			if(streamFailTimeout)
				flash.utils.clearTimeout(streamFailTimeout);
			
			streamFailTimeout = flash.utils.setTimeout(failStream,_streamFailTime,player);
			
			addPlayEventListener(player);
			player.player.source = source;
			player.player.seek(0);
			waitingForStream = true;
		}
		
		/**
		 * Kicks off an interval that polls the internal state
		 * of the player, and makes sure something is always playing.
		 */
		public function set neverStop(val:Boolean):void
		{
			if(val)
			{
				stoppedPoll = flash.utils.setInterval(checkStopped,5000);
			}
			else
			{
				flash.utils.clearInterval(stoppedPoll);
			}
		}
		
		/**
		 * Method called for neverStop polling.
		 */
		private function checkStopped():void
		{
			try
			{
				/*trace("---");
				trace(playerWrapper1.player.playing)
				trace(playerWrapper1.alpha)
				trace(playerWrapper1.visible)
				trace("---");
				trace(playerWrapper2.player.playing)
				trace(playerWrapper2.alpha)
				trace(playerWrapper2.visible)
				trace("---");
				trace(streamReadyWrapper1.player.playing)
				trace(streamReadyWrapper1.alpha)
				trace(streamReadyWrapper1.visible)
				trace("---");
				trace(streamReadyWrapper2.player.playing)
				trace(streamReadyWrapper2.alpha);
				trace(streamReadyWrapper2.visible);
				trace("---");
				trace("PLAYING?");
				trace(activePlayer.player.playing);
				trace("---");*/
				
				var recoverWithPlayer:FLVPlaybackWrapper = null;
				if((playerWrapper1.player.playing) && (playerWrapper1.alpha == 0) && (playerWrapper1.visible == true))
				{
					//trace("RECOVERING TO PLAYER WRAPPER 1");
					recoverWithPlayer = playerWrapper1;
				}
				else if(playerWrapper2.player.playing && playerWrapper2.alpha == 0 && playerWrapper2.visible == true)
				{
					//trace("RECOVERING TO PLAYER WRAPPER 2");
					recoverWithPlayer = playerWrapper2;
				}
				else if(streamReadyWrapper1.player.playing && streamReadyWrapper1.alpha == 0 && streamReadyWrapper1.visible == true)
				{
					//trace("RECOVERING TO STREAM PLAYER WRAPPER 1");
					recoverWithPlayer = streamReadyWrapper1;
				}
				else if(streamReadyWrapper2.player.playing && streamReadyWrapper2.alpha == 0 && streamReadyWrapper2.visible == true)
				{
					//trace("RECOVERING TO STREAM PLAYER WRAPPER 2");
					recoverWithPlayer = streamReadyWrapper2;
				}
				
				if(activePlayer)
				{
					if((recoverWithPlayer != null) && (recoverWithPlayer != activePlayer))
					{
						var half:Number = crossfadeDuration / 2;
						removeUpdateEventListener(activePlayer);
						removePlayEventListener(activePlayer);
						
						TweenLite.to(recoverWithPlayer,half,{alpha:1});
						TweenLite.to(recoverWithPlayer.player,half,{volume:_volume});
						TweenLite.to(activePlayer,half,{alpha:0,onComplete:visibleOffAndRemove,onCompleteParams:[activePlayer]});
						TweenLite.to(activePlayer.player,half,{volume:0});
						
						crossfading = true;
						flash.utils.setTimeout(clearPlayedNext,5000);
						
						if(activePlayer.id == "streamReadyWrapper1" || activePlayer.id == "streamReadyWrapper2")
						{
							removeCuePointEvent(activePlayer);
							removeNetConnectionEventListeners(activePlayer);
							removeNetStreamEventListeners(activePlayer);
							try
							{
								activePlayer.player.stop();
								activePlayer.player.getVideoPlayer(0).close();
								activePlayer.player.bufferTime = _buffTime;
							}
							catch(error:*){}
						}
						
						activePlayer = recoverWithPlayer;
						addUpdateEventListener(activePlayer);
						if(recoverWithPlayer.id == "streamReadyWrapper1" || recoverWithPlayer.id == "streamReadyWrapper2")
						{
							addNetConnectionEventListeners(activePlayer);
							addNetStreamEventListeners(activePlayer);
							addCuePointEventListener(activePlayer);
						}
						streamGoingOut = false;
					}
					else if((recoverWithPlayer == activePlayer) && (activePlayer.alpha == 0))
					{
						//trace("RECOVERING, RECOVER PLAYER AND ACTIVE WERE SAME, FADING IN ACTIVE PLAYER");
						TweenLite.to(activePlayer,half,{alpha:1});
						TweenLite.to(activePlayer.player,half,{volume:1});
					}
					else if(!activePlayer.player.playing && !_paused)
					{
						failedPlayingCount++;
						if(failedPlayingCount == 3)
						{
							//trace("RECOVERING, SHOULD PLAY NEXT");
							reset();
							playNext();
							failedPlayingCount = -1;	
						}
					}
				}
				else
				{
					//trace("RECOVERING, ACTIVE PLAYER WAS NULL");
					reset();
					playNext();
					failedPlayingCount = -1;
				}
			}
			catch(e:*){}
		}
		
		/**
		 * resets everything.
		 */
		public function reset():void
		{
			_paused = false;
			playedNext = false;
			started = false;
			streamGoingOut = false;
			playerWrapper1.alpha = 0;
			playerWrapper2.alpha = 0;
			streamReadyWrapper1.alpha = 0;
			streamReadyWrapper2.alpha = 0;
			activePlayer = null;
		}
		
		/**
		 * Stop all playing
		 */
		public function stopAll():void
		{
			try
			{
				playerWrapper1.player.stop();
				playerWrapper2.player.stop();
				streamReadyWrapper1.player.stop();
				streamReadyWrapper2.player.stop();
				try
				{
					streamReadyWrapper1.player.getVideoPlayer(0).close();
					streamReadyWrapper2.player.getVideoPlayer(0).close();
				}catch(error:*){}
			}
			catch(e:*){}
		}
		
		/**
		 * Gets an available player.
		 */
		private function getPlayer(source:String):FLVPlaybackWrapper
		{
			var player:FLVPlaybackWrapper;
			var isr:Boolean = false;
						
			if(source.indexOf("rtmp://") > -1)
				isr = true;
			
			if(activePlayer == null)
			{
				if(isr)
				{
					player = streamReadyWrapper1;
				}
				else
				{
					player = playerWrapper1;
				}
			}
			else
			{
				if(isr)
				{
					if(activePlayer.id == "streamReadyWrapper1" && isr)
						player = streamReadyWrapper2;
					else if(activePlayer.id == "streamReadyWrapper2")
						player = streamReadyWrapper1;
					else
						player = streamReadyWrapper1;
				}
				else
				{
					if(activePlayer.id == "playerWrapper1")
						player = playerWrapper2;
					else if(activePlayer.id == "playerWrapper2")
						player = playerWrapper1;
					else
						player = playerWrapper1;
				}
			}
			if(!contains(player))
				addChild(player);
			player.visible = true;
			return player;
		}
		
		
		/**
		 * Gets next clip to play.
		 */
		private function getNextClip():String
		{
			queueIndex++;
			if(queueIndex >= _queue.length)
				queueIndex = 0;
			if(queueIndex == -1)
				queueIndex = 0;
			return _queue[queueIndex];
		}
		
		/**
		 * Get's previous clip.
		 */
		private function getPreviousClip():String
		{
			queueIndex--;
			if(queueIndex <= -1)
				queueIndex = (_queue.length - 1);
			return _queue[queueIndex];
		}
		
		/**
		 * Play next video.
		 */
		public function playNext():void
		{
			if(playedNext)
				return;
			
			if(activePlayer && activePlayer.player.isRTMP && !streamGoingOut)
				return;
			
			playedNext = true;
			var nextClip:String = getNextClip();
			//trace("PLAY NEXT");
			//trace(nextClip);
			var player:FLVPlaybackWrapper = getPlayer(nextClip);
			addPlayEventListener(player);
			player.player.source = nextClip;
			player.player.play();
		}
		
		/**
		 * Play previous video.
		 */
		public function playPrevious():void
		{
			if(playedNext)
				return;
			playedNext = true;
			var prevClip:String = getPreviousClip();
			//trace("PLAY PREVIOUS");
			//trace(prevClip);
			var player:FLVPlaybackWrapper = getPlayer(prevClip);
			addPlayEventListener(player);
			player.player.source = prevClip;
			player.player.seek(0);
			player.player.play();
		}

		/**
		 * Add's play event listeners to a target.
		 */
		private function addPlayEventListener(target:FLVPlaybackWrapper):void
		{
			target.player.addEventListener(VideoEvent.PLAYING_STATE_ENTERED, onPlay);
		}
		
		/**
		 * Removes play event listeners from a target.
		 */
		private function removePlayEventListener(target:FLVPlaybackWrapper):void
		{
			target.player.removeEventListener(VideoEvent.PLAYING_STATE_ENTERED, onPlay);
		}
		
		/**
		 * Adds update event listeners to a target.
		 */
		private function addUpdateEventListener(target:FLVPlaybackWrapper):void
		{
			target.player.addEventListener(VideoEvent.PLAYHEAD_UPDATE, onUpdate);
		}
		
		/**
		 * Removes update event listeners from a target.
		 */
		private function removeUpdateEventListener(target:FLVPlaybackWrapper):void
		{
			if(!target) return;
			if(!target.player) return;
			
			try
			{
				target.player.removeEventListener(VideoEvent.PLAYHEAD_UPDATE, onUpdate);
			}
			catch(e:*){}
		}
		
		/**
		 * Adds cue point event listeners to the target player.
		 */
		private function addCuePointEventListener(target:FLVPlaybackWrapper):void
		{
			if(!target) return;
			if(!target.player) return;
			target.player.addEventListener(MetadataEvent.CUE_POINT, onCuePoint);
		}
		
		/**
		 * Removes cue point event listeners to the target player.
		 */
		private function removeCuePointEvent(target:FLVPlaybackWrapper):void
		{
			if(!target) return;
			if(!target.player) return;
			target.player.removeEventListener(MetadataEvent.CUE_POINT, onCuePoint);
		}
		
		/**
		 * Add's event listeners to a target player's NetConnection.
		 */
		private function addNetConnectionEventListeners(target:FLVPlaybackWrapper):void
		{
			try
			{
				if(target.player.getVideoPlayer(0).netConnection != null)
				{
					var p:VideoPlayer = target.player.getVideoPlayer(0);
					p.netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNCNS);
					p.netConnection.addEventListener(IOErrorEvent.NETWORK_ERROR, onNCIOE);
					p.netConnection.addEventListener(IOErrorEvent.IO_ERROR, onNCIOE);
					p.netConnection.addEventListener(IOErrorEvent.VERIFY_ERROR, onNCIOE);
					p.netConnection.addEventListener(IOErrorEvent.DISK_ERROR, onNCIOE);
					p.netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onNCASE);
				}
			}
			catch(e:*){}
		}
		
		/**
		 * Removes event listeners from a target player's NetConnection.
		 */
		private function removeNetConnectionEventListeners(target:FLVPlaybackWrapper):void
		{
			try
			{
				if(target.player.getVideoPlayer(0).netConnection != null)
				{
					var p:VideoPlayer = target.player.getVideoPlayer(0);
					p.netConnection.removeEventListener(NetStatusEvent.NET_STATUS, onNCNS);
					p.netConnection.removeEventListener(IOErrorEvent.NETWORK_ERROR, onNCIOE);
					p.netConnection.removeEventListener(IOErrorEvent.IO_ERROR, onNCIOE);
					p.netConnection.removeEventListener(IOErrorEvent.VERIFY_ERROR, onNCIOE);
					p.netConnection.removeEventListener(IOErrorEvent.DISK_ERROR, onNCIOE);
					p.netConnection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onNCASE);
				}
			}
			catch(e:*){}
		}
		
		/**
		 * On a cue point from a video
		 */
		private function onCuePoint(me:MetadataEvent):void
		{
			dispatchEvent(me);
		}
		
		/**
		 * Add listeners to the net stream object of the target player.
		 */
		private function addNetStreamEventListeners(target:FLVPlaybackWrapper):void
		{
			try
			{
				if(target.player.getVideoPlayer(0).netStream != null)
				{
					target.player.getVideoPlayer(0).netStream.addEventListener(NetStatusEvent.NET_STATUS, onNSNS);
					target.player.getVideoPlayer(0).netStream.addEventListener(IOErrorEvent.NETWORK_ERROR, onNSIOE);
					target.player.getVideoPlayer(0).netStream.addEventListener(IOErrorEvent.IO_ERROR, onNSIOE);
					target.player.getVideoPlayer(0).netStream.addEventListener(IOErrorEvent.VERIFY_ERROR, onNSIOE);
					target.player.getVideoPlayer(0).netStream.addEventListener(IOErrorEvent.DISK_ERROR, onNSIOE);
					target.player.getVideoPlayer(0).netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onNSASE);
				}
			}
			catch(e:*){}
		}
		
		/**
		 * Add listeners to the net stream object of the target player.
		 */
		private function removeNetStreamEventListeners(target:FLVPlaybackWrapper):void
		{
			try
			{
				if(target.player.getVideoPlayer(0).netStream != null)
				{
					target.player.getVideoPlayer(0).netStream.removeEventListener(NetStatusEvent.NET_STATUS, onNSNS);
					target.player.getVideoPlayer(0).netStream.removeEventListener(IOErrorEvent.NETWORK_ERROR, onNSIOE);
					target.player.getVideoPlayer(0).netStream.removeEventListener(IOErrorEvent.IO_ERROR, onNSIOE);
					target.player.getVideoPlayer(0).netStream.removeEventListener(IOErrorEvent.VERIFY_ERROR, onNSIOE);
					target.player.getVideoPlayer(0).netStream.removeEventListener(IOErrorEvent.DISK_ERROR, onNSIOE);
					target.player.getVideoPlayer(0).netStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onNSASE);
				}
			}
			catch(e:*){}
		}

		/**
		 * On video update.
		 */
		private function onUpdate(ve:VideoEvent):void
		{
			var target:FLVPlayback = FLVPlayback(ve.target);
			var player:FLVPlaybackWrapper = FLVPlaybackWrapper(ve.target.parent);
			
			if(activePlayer == null) return;
			
			if(player.id != activePlayer.id)
			{
				//trace("ERROR, TARGET IS NOT == ACTIVE PLAYER");
				return;
				if(target.isRTMP)
				{
					target.visible = true;
					removeUpdateEventListener(player);
					removePlayEventListener(player);
					player.player.stop();
				}
				else
				{
					player.visible = false;
					removeUpdateEventListener(player);
					removePlayEventListener(player);
					if(!player.player.isRTMP)
						player.player.stop();
				}
				return;
			}
			
			try
			{
				var totalTime:Number = target.totalTime || activePlayer.player.totalTime;
			}
			catch(e:*){return;}
			
			if(!totalTime) return;

			var outTweenTime:Number = Number((totalTime - continueWhenTimeLeft).toFixed(2));
			
			if(isNaN(target.playheadTime)) nanCount++;
			
			if(nanCount == 10)
			{
				nanCount = -1;
				playNext();	
			}
			
			if(target.playheadTime >= (outTweenTime - 2))
			{
				if(target.isRTMP) streamGoingOut = true;
			}
			
			if(target.playheadTime >= outTweenTime)
			{
				if(direction == FLVPlaybackQueueManager.LEFT)
				{
					playPrevious();
				}
				else
				{
					playNext();
				}
			}
		}		
		
		/**
		 * On play of the activePlayer
		 */
		private function onPlay(ve:VideoEvent):void
		{			
			var target:FLVPlaybackWrapper = FLVPlaybackWrapper(ve.target.parent);
			var half:Number = crossfadeDuration / 2;

			if(target.player.isRTMP)
			{
				try
				{
					flash.utils.clearTimeout(streamFailTimeout);
				}
				catch(error:*){}
				waitingForStream = false;
			}

			if(activePlayer != null)
			{				
				if(activePlayer.player.isRTMP && target.player.isRTMP)
				{
					//trace("ACTIVE && TARGET ARE STREAM");
					removeNetConnectionEventListeners(activePlayer);
					removeNetStreamEventListeners(activePlayer);
					removeUpdateEventListener(activePlayer);
					removeCuePointEvent(activePlayer);
					try
					{
						activePlayer.player.stop();
						activePlayer.player.getVideoPlayer(0).close();
						activePlayer.player.bufferTime = _buffTime;
					}
					catch(error1:*){}
					removePlayEventListener(target);
					TweenLite.to(target,half,{alpha:1});
					TweenLite.to(target.player,half,{volume:_volume});
					TweenLite.to(activePlayer,half,{alpha:0,onComplete:visibleOffAndRemove,onCompleteParams:[activePlayer]});
					TweenLite.to(activePlayer.player,half,{volume:0});
					activePlayer = target;
					activePlayer.player.bufferTime = 10;
					addUpdateEventListener(activePlayer);
					addNetConnectionEventListeners(activePlayer);
					addNetStreamEventListeners(activePlayer);
					addCuePointEventListener(activePlayer);
					streamGoingOut = false;
					crossfading = true;
				}
				else if(!activePlayer.player.isRTMP && target.player.isRTMP)
				{
					//trace("TARGET IS STREAM, GIVE IT PRIORITY");
					removeUpdateEventListener(activePlayer);
					removePlayEventListener(target);
					TweenLite.to(target,half,{alpha:1});
					TweenLite.to(target.player,half,{volume:_volume});
					TweenLite.to(activePlayer,half,{alpha:0,onComplete:visibleOffAndRemove,onCompleteParams:[activePlayer]});
					TweenLite.to(activePlayer.player,half,{volume:0});
					activePlayer = target;
					addUpdateEventListener(activePlayer);
					addNetConnectionEventListeners(activePlayer);
					addNetStreamEventListeners(activePlayer);
					addCuePointEventListener(activePlayer);
					streamGoingOut = false;
					crossfading = true;
				}
				else if(activePlayer.player.isRTMP && !target.player.isRTMP)
				{
					if(streamGoingOut) //only fade if stream is going out.
					{
						//trace("ACTIVE IS STREAM AND GOING OUT. SWITCH TO LOOP");
						removeUpdateEventListener(activePlayer);
						removeNetConnectionEventListeners(activePlayer);
						removeNetStreamEventListeners(activePlayer);
						removeCuePointEvent(activePlayer);
						removePlayEventListener(target);
						try
						{
							activePlayer.player.stop();
							activePlayer.player.getVideoPlayer(0).close();
							activePlayer.player.bufferTime = _buffTime;
						}
						catch(error2:*){}
						
						TweenLite.to(target,half,{alpha:1});
						TweenLite.to(target.player,half,{volume:_volume});
						TweenLite.to(activePlayer,half,{alpha:0,onComplete:visibleOffAndRemove,onCompleteParams:[activePlayer]});
						TweenLite.to(activePlayer.player,half,{volume:0});
						activePlayer = target;
						addUpdateEventListener(activePlayer);
						streamGoingOut = false;
						crossfading = true;
					}
					else
					{
						var pht:Number;
						var tt:Number;
						
						try
						{
							pht = activePlayer.player.playheadTime;
							tt = activePlayer.player.totalTime - 5;
						}
						catch(error3:*)
						{
							//flip flags to that stream is given priority.
							pht = 1;
							tt = 0;
						}
						
						if(pht < tt)
						{
							//trace("ACTIVE IS STREAM, TARGET IS NOT, !streamGoingOut - RETURN");
							return;
						}
						else
						{
							removeUpdateEventListener(activePlayer);
							removeCuePointEvent(activePlayer);
							removeNetConnectionEventListeners(activePlayer);
							removeNetStreamEventListeners(activePlayer);
							try
							{
								activePlayer.player.stop();
								activePlayer.player.getVideoPlayer(0).close();
								activePlayer.player.bufferTime = _buffTime;
							}
							catch(error4:*){}
							
							removePlayEventListener(target);
							TweenLite.to(target,half,{alpha:1});
							TweenLite.to(target.player,half,{volume:_volume});
							TweenLite.to(activePlayer,half,{alpha:0,onComplete:visibleOffAndRemove,onCompleteParams:[activePlayer]});
							TweenLite.to(activePlayer.player,half,{volume:0});
							activePlayer = target;
							addUpdateEventListener(activePlayer);
							streamGoingOut = false;
							crossfading = true;
						}
					}
				}
				else if(!activePlayer.player.isRTMP && !target.player.isRTMP)
				{
					//trace("ACTIVE IS HTTP AND TARGET IS HTTP");
					removeUpdateEventListener(activePlayer);
					removePlayEventListener(target);
					TweenLite.to(target,half,{alpha:1});
					TweenLite.to(target.player,half,{volume:_volume});
					TweenLite.to(activePlayer,half,{alpha:0,onComplete:visibleOffAndRemove,onCompleteParams:[activePlayer]});
					TweenLite.to(activePlayer.player,half,{volume:0});
					activePlayer = target;
					addUpdateEventListener(activePlayer);
					crossfading = true;
				}
			}
			else
			{
				//trace("ACTIVE IS NULL");
				TweenLite.to(target,half,{alpha:1});
				TweenLite.to(target.player,half,{volume:_volume});
				activePlayer = target;
				addUpdateEventListener(target);
			}
			flash.utils.setTimeout(clearPlayedNext,5000);
			dispatchEvent(new Event("crossfading"));
		}
		
		/**
		 * Clear payedNext flag.
		 */
		private function clearPlayedNext():void
		{
			playedNext = false;
		}
		
		/**
		 * An complete handler from tweens to hide and remove a target
		 * from the display list.
		 */
		private function visibleOffAndRemove(target:FLVPlaybackWrapper):void
		{
			target.visible = false;
			if(contains(target))
				removeChild(target);
		}
		
		/**
		 * On stream fail
		 */
		private function failStream(player:FLVPlaybackWrapper):void
		{
			waitingForStream = false;
			try
			{
				flash.utils.clearTimeout(streamFailTimeout);
				player.player.getVideoPlayer(0).netConnection.close();		
			}
			catch(e:*){}
		}
		
		/**
		 * On NetConnection AsyncError.
		 */
		private function onNCASE(ase:AsyncErrorEvent):void
		{
			//trace("On NetConnection AsyncError");
			//trace("TARGET: " + ase.target.id);
			waitingForStream = false;
			playedNext = false;
			playNext();
		}
		
		/**
		 * On NetConnection IO Error.
		 */
		private function onNCIOE(ioe:IOErrorEvent):void
		{
			//trace("On NetConnection IOError");
			//trace("TARGET: " + ioe.target.id);
			waitingForStream = false;
			playedNext = false;
			playNext();
		}
		
		/**
		 * On NetConnection Net Status
		 */
		private function onNCNS(ns:NetStatusEvent):void
		{
			//trace("On NetConnection Net Status");
			//trace(ns.info.code);
			switch(ns.info.code)
			{
				case "NetConnection.Connect.Closed":
					if((activePlayer.id == "streamReadyWrapper1" || activePlayer.id == "streamReadyWrapper2"))
					{
						removeUpdateEventListener(activePlayer);
						removeNetConnectionEventListeners(activePlayer);
						removeNetStreamEventListeners(activePlayer);
						reset();
						playNext();
					}
					break;
			}
		}
		
		/**
		 * On NetStream Async Error.
		 */
		private function onNSASE(ase:AsyncErrorEvent):void
		{
			//trace("On NetStream AsyncError");
			//trace("TARGET: " + ase.target.id);
			waitingForStream = false;
			playedNext = false;
			playNext();
		}
		
		/**
		 * On NetStream IO Error.
		 */
		private function onNSIOE(ioe:IOErrorEvent):void
		{
			//trace("On NetStream IOError");
			//trace("TARGET: " + ioe.target.id);
			waitingForStream = false;
			playedNext = false;
			playNext();
		}
		
		/**
		 * On NetStream net status.
		 */
		private function onNSNS(ns:NetStatusEvent):void
		{
			//trace("On NetStream NetStatus");
			//trace(ns.info.code);
			switch(ns.info.code)
			{
				case "NetConnection.Connect.Closed":
					if((activePlayer.id == "streamReadyWrapper1" || activePlayer.id == "streamReadyWrapper2"))
					{
						removeUpdateEventListener(activePlayer);
						removeNetConnectionEventListeners(activePlayer);
						removeNetStreamEventListeners(activePlayer);
						reset();
						playNext();
					}
					break;
			}
		}
	}
}