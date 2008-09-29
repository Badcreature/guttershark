package net.guttershark.support.preloading.workers 
{	import flash.events.AsyncErrorEvent;	import flash.events.IOErrorEvent;	import flash.events.NetStatusEvent;	import flash.events.TimerEvent;	import flash.net.NetConnection;	import flash.net.NetStream;	import flash.utils.clearInterval;	import flash.utils.setInterval;		import net.guttershark.managers.AssetManager;	import net.guttershark.support.preloading.Asset;	import net.guttershark.support.preloading.events.AssetCompleteEvent;	import net.guttershark.support.preloading.events.AssetProgressEvent;	
	/**
	 * The FLVWorker class loads progressive flv's with
	 * a net stream object.
	 */
	final public class FLVWorker extends Worker
	{
		
		/**
		 * Net connection.
		 */
		private var nc:NetConnection;
		
		/**
		 * progress / complete interval.
		 */
		private var bt:Number;
		
		/**
		 * The Asset manager.
		 */
		private var am:AssetManager;
		/**
		 * Load an asset of type flv.
		 */
		public override function load(asset:Asset):void
		{
			this.asset = asset;
			am = AssetManager.gi();
			if(am.isAvailable(asset.source))
			{
				loader = am.getNetStream(asset.source);
				loader.client = this;
			}
			else
			{
				nc = new NetConnection();
				nc.connect(null);
				loader = new NetStream(nc);
				loader.client = this;
				loader.bufferTime = 100000;
				loader.soundTransform.volume = 0;
				am.addAsset(asset.source,loader,asset.source);
				am.addAsset(asset.libraryName,loader,asset.source);
				loader.play(asset.source);
				loader.pause();
			}
			bt = setInterval(check,200);
			asset.data = loader;
			loader.addEventListener(NetStatusEvent.NET_STATUS,onns,false,0,true);
			loader.addEventListener(AsyncErrorEvent.ASYNC_ERROR,onasync,false,0,true);
		}
		
		/**
		 * @private
		 */
		public function onMetaData(metadata:Object):void{}
		
		//suppresses async errors
		private function onasync(a:AsyncErrorEvent):void{}
		
		/**
		 * Does progress and complete checks.
		 */
		private function check(te:TimerEvent=null):void
		{
			if(!loader) return;
			bytesLoaded=loader.bytesLoaded;
			bytesTotal=loader.bytesTotal;
			if(loader.bytesLoaded>=loader.bytesTotal)
			{
				clearInterval(bt);
				dispatchEvent(new AssetCompleteEvent(AssetCompleteEvent.COMPLETE,asset));
			}
			else dispatchEvent(new AssetProgressEvent(AssetProgressEvent.PROGRESS,asset));
		}
		
		/**
		 * removes event listeners.
		 */
		override protected function removeEventListeners():void
		{
			loader.removeEventListener(NetStatusEvent.NET_STATUS,onns);
			loader.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,onasync);
		}
		
		/**
		 * On net status events.
		 */
		private function onns(stats:NetStatusEvent):void
		{
			switch(stats.info.code)
			{
				case "NetStream.Play.StreamNotFound":
					onIOLoadError(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					clearInterval(bt);
					break;
			}
		}
		
		/**
		 * Dispose of this flv worker.
		 */
		override public function dispose():void
		{
			removeEventListeners();
			clearInterval(bt);
			bt = NaN;
			bytesLoaded = NaN;
			bytesTotal = NaN;
			asset = null;
			loader = null;
			request = null;
			nc = null;
		}	}}