package net.guttershark.events.delegates.components
{
	import net.guttershark.events.delegates.EventListenerDelegate;	

	import fl.video.VideoEvent;	
	import fl.video.FLVPlayback;
	
	/**
	 * The FLVPlaybackEventListenerDelegate Class is an IEventListenerDelegate that implements
	 * adding event listeners to an FLVPlayback component, as well as handling
	 * an event when dispatched, and passing back to your handler delegate.
	 * 
	 * <p>This can be used with the EventManager singleton to delegate event listener
	 * logic over to this class.</p>
	 * 
	 * @example Setting up the FLVPlaybackEventListenersDelegate on EventManager:
	 * <listing>
	 * import net.guttershark.events.listenerdelegates.FLVPlaybackEventListenerDelegate.
	 * EventManager.gi().addDelegate(FLVPlaybackEventListenerDelegate);
	 * </listing>
	 * 
	 * <p>See the EventManager class for a list of supported events.</p>
	 */
	public class FLVPlaybackEventListenerDelegate extends EventListenerDelegate
	{

		/**
		 * Add listeners to the passed obj. Make sure to only add listeners
		 * to the obj if the (obj is MyClass).
		 */
		override public function addListeners(obj:*):void
		{
			super.addListeners(obj);
			if(obj is FLVPlayback)
			{
				obj.addEventListener(VideoEvent.PAUSED_STATE_ENTERED, onFLVPause);
				obj.addEventListener(VideoEvent.PLAYING_STATE_ENTERED, onFLVPlay);
				obj.addEventListener(VideoEvent.STOPPED_STATE_ENTERED, onFLVStopped);
				obj.addEventListener(VideoEvent.PLAYHEAD_UPDATE, onFLVPlayheadUpdate);
				obj.addEventListener(VideoEvent.AUTO_REWOUND, onFLVAutoRewound);
				obj.addEventListener(VideoEvent.BUFFERING_STATE_ENTERED, onFLVBufferState);
				obj.addEventListener(VideoEvent.CLOSE, onFLVClose);
				obj.addEventListener(VideoEvent.COMPLETE, onFLVComplete);
				obj.addEventListener(VideoEvent.FAST_FORWARD, onFLVFastForward);
				obj.addEventListener(VideoEvent.READY, onFLVReady);
				obj.addEventListener(VideoEvent.REWIND, onFLVRewind);
				obj.addEventListener(VideoEvent.SCRUB_FINISH, onFLVScrubFinish);
				obj.addEventListener(VideoEvent.SCRUB_START, onFLVScrubStart);
				obj.addEventListener(VideoEvent.SEEKED, onFLVSeeked);
				obj.addEventListener(VideoEvent.SKIN_LOADED, onFLVSkinLoaded);
				obj.addEventListener(VideoEvent.STATE_CHANGE, onFLVStateChange);
			}
		}
		
		private function onFLVStateChange(ve:VideoEvent):void
		{
			handleEvent(ve,"StateChange");
		}
		
		private function onFLVSkinLoaded(ve:VideoEvent):void
		{
			handleEvent(ve,"SkinLoaded");
		}
		
		private function onFLVSeeked(ve:VideoEvent):void
		{
			handleEvent(ve,"Seeked");
		}
		
		private function onFLVScrubStart(ve:VideoEvent):void
		{
			handleEvent(ve,"ScrubStart");
		}
		
		private function onFLVScrubFinish(ve:VideoEvent):void
		{
			handleEvent(ve,"ScrubFinish");
		}
		
		private function onFLVRewind(ve:VideoEvent):void
		{
			handleEvent(ve,"Rewind");
		}
		
		private function onFLVReady(ve:VideoEvent):void
		{
			handleEvent(ve,"Ready");
		}
		
		private function onFLVFastForward(ve:VideoEvent):void
		{
			handleEvent(ve,"FastForward");
		}
		
		private function onFLVBufferState(ve:VideoEvent):void
		{
			handleEvent(ve,"AutoRewound");
		}

		private function onFLVAutoRewound(ve:VideoEvent):void
		{
			handleEvent(ve,"BufferState");
		}
		
		private function onFLVClose(ve:VideoEvent):void
		{
			handleEvent(ve,"Close");
		}
		
		private function onFLVComplete(ve:VideoEvent):void
		{
			handleEvent(ve,"Complete");
		}
		
		private function onFLVPlayheadUpdate(ve:VideoEvent):void
		{
			handleEvent(ve,"PlayheadUpdate",true);
		}
		
		private function onFLVPlay(ve:VideoEvent):void
		{
			handleEvent(ve,"Play");
		}
		
		private function onFLVPause(ve:VideoEvent):void
		{
			handleEvent(ve,"Pause");
		}
		
		private function onFLVStopped(ve:VideoEvent):void
		{
			handleEvent(ve,"Stopped");
		}	}}