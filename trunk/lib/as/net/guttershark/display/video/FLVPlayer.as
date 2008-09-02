package net.guttershark.display.video {	import flash.display.MovieClip;	import flash.events.MouseEvent;	import flash.media.Video;		import net.guttershark.display.CoreClip;	import net.guttershark.display.video.FLV;	import net.guttershark.support.events.MediaEvent;	import net.guttershark.util.math.MathBase;		/**	 * FLVPlayer provides playback control interface code to be used with sekati.media.FLV.	 * 	 * <p>Simply create a library asset with the necessary assets, link it to the <code>FLVPlayer</code>	 * class and attach instances as needed.</p>	 * 	 * @see sekati.media.FLV	 * @see sekati.events.MediaEvents	 */	public class FLVPlayer extends CoreClip 	{		/**		 * @private		 */		public var _this:FLVPlayer;		protected var _movie:FLV;		protected var _video:Video;		protected var _isDrag:Boolean;		protected var _isSeeking:Boolean;		protected var _wasPlaying:Boolean;		protected var _keyListener:Object;		protected var _isKeyEnabled:Boolean;		protected var _playBtn:MovieClip;		protected var _progBar:MovieClip;		protected var _buffBar:MovieClip;		protected var _guttBar:MovieClip;		protected var _volBtn:MovieClip;				// added		protected var _currentCuePoint:Object;		/**		 * FLVPlayer Constructor		 */		public function FLVPlayer() 		{			super();			_this = this;			_playBtn = _this['playBtn'];			_progBar = _this['progBar'];			_buffBar = _this['buffBar'];			_guttBar = _this['guttBar'];			_volBtn = _this['volBtn'];			_isDrag = false;			_isSeeking = false;			_wasPlaying = false;			_isKeyEnabled = true;						// setup			_progBar.mouseEnabled = false;			_progBar.scaleX = 0;			_buffBar.scaleX = 0;			_playBtn.buttonMode = true;			_volBtn.buttonMode = true;			_buffBar.buttonMode = true;			// events			_playBtn.addEventListener(MouseEvent.CLICK,playBtn_Press,false,0,true);			_volBtn.addEventListener(MouseEvent.MOUSE_DOWN,volBtn_onPress,false,0,true);			_volBtn.addEventListener(MouseEvent.MOUSE_UP,volBtn_onRelease,false,0,true);			_volBtn.addEventListener(MouseEvent.MOUSE_MOVE,volBtn_onMove,false,0,true);			_buffBar.addEventListener(MouseEvent.MOUSE_DOWN,buffBar_onPress,false,0,true);			_buffBar.addEventListener(MouseEvent.MOUSE_UP,buffBar_onRelease,false,0,true);			_buffBar.addEventListener(MouseEvent.MOUSE_MOVE,buffBar_onMove,false,0,true);				}		// CORE CONTROLS				/**		 * load video and initialize FLVPlayer UI and FLVPlayer Core		 * @param url (String) of flv video.		 * @param width of video.		 * @param height of video.		 * @param smoothing of video.		 * @return void		 */		public function init(url:String, width:uint = 320, height:uint = 240, smoothing:Boolean = true):void 		{			remove();			_movie = new FLV(width,height,smoothing);			_video = _movie.video;			_this.addChild(_video);			_playBtn.gotoAndStop(1);			// media events					_movie.addEventListener(MediaEvent.PROGRESS,movie_onProgress,false,0,true);			_movie.addEventListener(MediaEvent.START,movie_onStatus,false,0,true);			_movie.addEventListener(MediaEvent.STOP,movie_onStatus,false,0,true);			_movie.addEventListener(MediaEvent.STREAM_NOT_FOUND,movie_onStatus,false,0,true);			_movie.addEventListener(MediaEvent.REBUFFER,movie_onStatus,false,0,true);			_movie.addEventListener(MediaEvent.REBUFFER_COMPLETE,movie_onStatus,false,0,true);			_movie.addEventListener(MediaEvent.METADATA,movie_onStatus,false,0,true);			_movie.addEventListener(MediaEvent.CUE_POINT,movie_onStatus,false,0,true);			//						_movie.load(url);			_movie.play();		}		/**		 * Remove the movie from player.		 */		public function remove():void 		{			if (_movie) 			{				_movie.removeEventListener(MediaEvent.PROGRESS,movie_onProgress);				_movie.removeEventListener(MediaEvent.START,movie_onStatus);				_movie.removeEventListener(MediaEvent.STOP,movie_onStatus);				_movie.removeEventListener(MediaEvent.STREAM_NOT_FOUND,movie_onStatus);				_movie.removeEventListener(MediaEvent.REBUFFER,movie_onStatus);				_movie.removeEventListener(MediaEvent.REBUFFER_COMPLETE,movie_onStatus);				_movie.removeEventListener(MediaEvent.METADATA,movie_onStatus);				_movie.removeEventListener(MediaEvent.CUE_POINT,movie_onStatus);								_movie.destroy();				_movie = null;				reset();			}					}		/**		 * Reset the interface.		 */		public function reset():void 		{			_buffBar.scaleX = 0;			_progBar.scaleX = 0;			_playBtn.gotoAndStop(2);		}		/**		 * Pause video playback		 */		public function pause():void 		{			if (_movie) 			{				_isKeyEnabled = false;				_playBtn.gotoAndStop(2);				_movie.pause();			}		}		/**		 * Resume video playback		 */		public function resume():void 		{			if (_movie) 			{				_isKeyEnabled = true;				_playBtn.gotoAndStop(1);				_movie.resume();			}		}		// PLAYER DRIVERS				/**		 * Pause video in memory and track state.		 */		protected function pauseMemory():void 		{			_wasPlaying = _movie.isPaused();			_movie.pause();		}		/**		 * Resume video from member and release state.		 */		protected function resumeMemory():void 		{			if (!_wasPlaying) 			{				_movie.resume();			}			_wasPlaying = false;		}		/**		 * Core video volume driver.		 */		protected function setVolumeControl(p:Number = NaN):void 		{			var ov:Number = (!isNaN(p)) ? p : MathBase.clamp((int(_volBtn.mouseX * 100 / _volBtn.width) / 100),0,1);			var v:Number = MathBase.clamp(ov,0,1);			_volBtn['vbar'].scaleX = v;			_movie.setVolume(v);			trace("Volume: " + v);		}		/**		 * Use guttBar to prevent seek offset inaccuracy while still buffering		 */		protected function seek_ui():void 		{			if (_isSeeking) 			{				var percent:Number = MathBase.clamp((int((_guttBar.mouseX - 2) * 100 / (_guttBar.width - 2)) / 100),.01,.95);				_progBar.scaleX = percent;				trace("@seek_ui: " + percent + "% | bufferPercent: " + _buffBar.scaleX + "% | bufferBar._xmouse=" + _buffBar.mouseX + " | buffBar._width: " + _buffBar.width);			}		}				// MOVIE HANDLERS					/**		 * Handle <code>FLV</code> movie progress events. 		 */		protected function movie_onProgress(e:MediaEvent):void 		{			//trace( "movie_onProgress - loaded:" + e.loaded + " played:" + e.played );			var lp:Number = MathBase.clamp(e.loaded,0,1);			var cp:Number = MathBase.clamp(e.played,0,1);			_buffBar.scaleX = lp;			if (!_isSeeking) 			{				_progBar.scaleX = cp;			} else 			{				_movie.seekToPercent(_progBar.scaleX);			}					}		/**		 * Handle <code>FLV</code> movie status events.		 * 		 * <p>It is best to extend and override this class method to implement your own switch/case code.</p>		 */		protected function movie_onStatus(e:MediaEvent):void 		{			switch (e.code) 			{				case MediaEvent.BUFFER_EMPTY :					trace("FLVPlayer-> movieEvent: bufferEmpty");					break;				case MediaEvent.BUFFER_FULL :					trace("FLVPlayer-> movieEvent: bufferFull");					break;				case MediaEvent.BUFFER_FLUSH :					trace("FLVPlayer-> movieEvent: bufferFlush");					break;				case MediaEvent.START :					trace("FLVPlayer-> movieEvent: start");					break;				case MediaEvent.STOP :					trace("FLVPlayer-> movieEvent: stop");					//removeMovie ();					//App.bc.broadcast( "onVideoComplete" );					break;				case MediaEvent.STREAM_NOT_FOUND :					trace("FLVPlayer-> movieEvent: play_streamNotFound");					//App.bc.broadcast( "onStreamNotFound" );					break;				case MediaEvent.SEEK_INVALID_TIME :					trace("FLVPlayer-> movieEvent: seek_invalidTime");					_movie.rew();					break;				case MediaEvent.SEEK_NOTIFY:					trace("FLVPlayer-> movieEvent: seek_notify");					break;				case MediaEvent.REBUFFER:					trace("FLVPlayer-> movieEvent: rebuffer");					pause();					break;				case MediaEvent.REBUFFER_COMPLETE:					trace("FLVPlayer-> movieEvent: rebufferComplete");					resume();					break;					case MediaEvent.METADATA:					trace("FLVPlayer-> movieEvent: metaData");					break;				case MediaEvent.CUE_POINT:					trace("FLVPlayer-> movieEvent: cuePoint");					if(!_isDrag || !_isSeeking) 					{						dispatchEvent(new MediaEvent(MediaEvent.CUE_POINT_DISPLAY,null,NaN,NaN,null,e.cuePointData));					}					break;														default :					trace("FLVPlayer-> movieEvent: unrecognized onStatus value: " + e.code + " :: " + e.type);			}					}		// EVENT HANDLERS				/**		 * Toggle the framed <code>_playBtn</code> icon and pause/resume playback.		 */		protected function playBtn_Press(e:MouseEvent):void 		{			if (_movie) 			{				if (_playBtn.currentFrame == 1) 				{					_playBtn.gotoAndStop(2);					_movie.pause();				} else 				{					_playBtn.gotoAndStop(1);					_movie.resume();				}			}					}		/**		 * <code>_buffBar</code> pressed: being seeking.		 */		protected function buffBar_onPress(e:MouseEvent):void 		{			_isSeeking = true;			seek_ui();			pauseMemory();			_buffBar.stage.addEventListener(MouseEvent.MOUSE_UP,buffBar_onRelease,false,0,true);			}		/**		 * <code>_buffBar</code> released: stop seeking.		 */		protected function buffBar_onRelease(e:MouseEvent):void 		{			_isSeeking = false;			resumeMemory();			_buffBar.stage.removeEventListener(MouseEvent.MOUSE_UP,buffBar_onRelease);					}		/**		 * <code>_buffBar</code> scrubbing: seek.		 */		protected function buffBar_onMove(e:MouseEvent):void 		{			seek_ui();		}		/**		 * <code>_volBtn</code> pressed: begin volume control.		 */		protected function volBtn_onPress(e:MouseEvent):void 		{			_isDrag = true;			setVolumeControl();			_volBtn.stage.addEventListener(MouseEvent.MOUSE_UP,volBtn_onRelease,false,0,true);					}		/**		 * <code>_volBtn</code> released: end volume control.		 */		protected function volBtn_onRelease(e:MouseEvent):void 		{			_isDrag = false;			_volBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,volBtn_onRelease);				}		/**		 * <code>_volBtn</code> scrubbing: change volume.		 */		protected function volBtn_onMove(e:MouseEvent):void 		{			if (_isDrag) 			{				setVolumeControl();			}					}		/**		 * @inheritDoc		 */		public function destroy():void 		{			_movie.destroy();			_playBtn.removeEventListener(MouseEvent.CLICK,playBtn_Press);			_volBtn.removeEventListener(MouseEvent.MOUSE_DOWN,volBtn_onPress);			_volBtn.removeEventListener(MouseEvent.MOUSE_UP,volBtn_onRelease);			_volBtn.removeEventListener(MouseEvent.MOUSE_MOVE,volBtn_onMove);			_buffBar.removeEventListener(MouseEvent.MOUSE_DOWN,buffBar_onPress);			_buffBar.removeEventListener(MouseEvent.MOUSE_UP,buffBar_onRelease);			_buffBar.removeEventListener(MouseEvent.MOUSE_MOVE,buffBar_onMove);					}	}}