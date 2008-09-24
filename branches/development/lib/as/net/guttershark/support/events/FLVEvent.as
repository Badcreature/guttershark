package net.guttershark.support.events
{
	import flash.events.Event;

	/**
	 * MediaEvent provides a base MediaEvent class for FLV and MP3 loading, streaming & playback.
	 * 
	 * @see net.guttershark.display.video.FLV
	 * @see net.guttershark.display.video.FLVPlayer
	 */
	public class FLVEvent extends Event
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
		public static var CUE_POINT:String = "cuePoint";
		public static var CUE_POINT_DISPLAY:String = "cuePointDisplay";
		public static var REBUFFER:String = "rebuffer";
		public static var REBUFFER_COMPLETE:String = "rebufferComplete";
		
		public var cuePoint:Object;
		public var percentLoaded:Number;
		public var percentPlayed:Number;
		public var metadata:Object;
		
		/**
		 * Constructor for MediaEvent instances.
		 */
		public function FLVEvent(type:String,percentLoaded:Number=NaN,percentPlayed:Number=NaN,metaData:Object=null,cuePointData:Object=null,bubbles:Boolean=true,cancelable:Boolean=false) 
		{
			super(type,bubbles,cancelable);
			this.percentLoaded = percentLoaded;
			this.percentPlayed = percentPlayed;
			this.metadata = metaData;
			this.cuePoint = cuePointData;
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Event 
		{
			return new FLVEvent(type,percentLoaded,percentPlayed,metadata,bubbles,cancelable);
		}														
	}
}
