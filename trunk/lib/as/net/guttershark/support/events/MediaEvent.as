package net.guttershark.support.events
{
	import flash.events.Event;

	/**
	 * MediaEvent provides a base MediaEvent class for FLV and MP3 loading, streaming & playback.
	 * 
	 * @see net.guttershark.display.video.FLV
	 * @see net.guttershark.display.video.FLVPlayer
	 */
	public class MediaEvent extends Event 
	{
	
		public static const START:String = 'start';
		public static const STOP:String = 'stop';
		public static const PROGRESS:String = 'progress';
		public static const METADATA:String = 'metaData';
		public static const BUFFER_EMPTY:String = 'bufferEmpty';
		public static const BUFFER_FULL:String = 'bufferFull';
		public static const BUFFER_FLUSH:String = 'bufferFlush';
		public static const SEEK_INVALID_TIME:String = 'seekInvalidTime';
		public static const SEEK_NOTIFY:String = 'seekNotify';
		public static const STREAM_NOT_FOUND:String = 'streamNotFound';
		public static const UNRECOGNIZED:String = 'unrecognizedStatus';
		
		/** 
		 * @eventType "cuePoint" fires when a cue point is reached.
		 */
		public static var CUE_POINT:String = "cuePoint";		

		/**
		 * @eventType "cuePointDisplay" fires when cue point info should be displayed.
		 */
		public static var CUE_POINT_DISPLAY:String = "cuePointDisplay";

		/**
		 * @eventType "rebuffer" fires when the custom buffer in FLV is running out of buffer data for current FLV.
		 */
		public static var REBUFFER:String = "rebuffer";

		/**
		 * @eventType "rebufferComplete" Fired when the custom buffer in FLV has adequate buffer data for current FLV.
		 */
		public static var REBUFFER_COMPLETE:String = "rebufferComplete";

		protected var _cuePointData:Object;
		protected var _code:String;
		protected var _loaded:Number;
		protected var _played:Number;
		protected var _metadata:Object;

		/**
		 * Constructor for MediaEvent instances.
		 */
		public function MediaEvent(type:String, statusCode:String = null, percentLoaded:Number = NaN, percentPlayed:Number = NaN, metaData:Object = null, cuePointData:Object = null, bubbles:Boolean = true, cancelable:Boolean = false) 
		{
			super(type,bubbles,cancelable);
			_code = statusCode;
			_loaded = percentLoaded;
			_played = percentPlayed;
			_metadata = metaData;
			_cuePointData = cuePointData;
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Event 
		{
			return new MediaEvent(type,code,loaded,played,metadata,bubbles,cancelable);
		}

		/**
		 * The <code>MediaEvent</code>'s status code string.
		 */
		public function get code():String 
		{
			return _code;
		}

		/**
		 * The <code>MediaEvent</code>'s percent loaded.
		 */
		public function get loaded():Number 
		{
			return _loaded;
		}

		/**
		 * The <code>MediaEvent</code>'s percent played.
		 */
		public function get played():Number 
		{
			return _played;
		}

		/**
		 * The <code>MediaEvent</code>'s metadata object.
		 */
		public function get metadata():Object 
		{
			return _metadata;
		}

		/**
		 * The <code>MediaEvent</code>'s cue point data object from the FLV <code>cuePointData.parameters['parameterName']</code>
		 * Where <code>parameterName</code> is the variable name specified when cue point was created.
		 */
		public function get cuePointData():Object 
		{
			return _cuePointData;
		}														
	}
}