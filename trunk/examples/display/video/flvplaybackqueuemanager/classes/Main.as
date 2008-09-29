package
{
	import flash.utils.setTimeout;
	
	import fl.video.FLVPlayback;
	import fl.video.VideoAlign;
	import fl.video.VideoScaleMode;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.display.video.FLVPlaybackQueueManager;
	import net.guttershark.util.akamai.AkamaiNCManager;	

	public class Main extends DocumentController
	{

		public var queueplayer:FLVPlayback;
		private var queuePlayback:FLVPlaybackQueueManager;
		
		public function Main()
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {akamaiHost:"http://cp44952.edgefcs.net/"};
		}
		
		override protected function setupComplete():void
		{
			queueplayer.align = VideoAlign.BOTTOM_LEFT;
			queueplayer.scaleMode = VideoScaleMode.NO_SCALE;
			queueplayer.playheadUpdateInterval = 1300;
			queueplayer.ncMgr.timeout = 100000;
			queueplayer.bufferTime = 1;
		}
		
		override protected function akamaiIdentComplete(ip:String):void
		{
			//trace("AKAMAI IDENT SNIFF COMPLETE");
			//trace(AkamaiNCManager.FMS_IP);
			AkamaiNCManager.FMS_IP = ip;
			queuePlayback = new FLVPlaybackQueueManager();
			queuePlayback.player = queueplayer;
			var queue:Array = [
				"assets/flv/6000_EGG.flv",
				"assets/flv/6001_EGG.flv",
				"assets/flv/6002_EGG.flv",
				"rtmp://cp44952.edgefcs.net/ondemand/streamingVideos/high/2035_RES.flv"
				];
			queuePlayback.queue = queue;
			queuePlayback.streamAttemptTimeBeforeFail = 20;
			queuePlayback.start();
			setTimeout(playNow, 3000);
		}
		
		private function playNow():void
		{
			//queuePlayback.playNow("assets/flv/6004_EGG.flv");
			queuePlayback.playNow("rtmp://cp44952.edgefcs.net/ondemand/streamingVideos/high/2035_RES.flv");
		}
	}