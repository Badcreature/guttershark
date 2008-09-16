package scenes.bunker.subviews 
{
	import gs.TweenMax;	
	
	import fl.motion.easing.Quadratic;	
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import net.guttershark.events.EventManager;
	import net.guttershark.preloading.Asset;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.preloading.events.PreloadProgressEvent;
	import net.guttershark.util.DisplayListUtils;		

	public class LargePhotoDisplay extends MovieClip 
	{
		
		public var img:MovieClip;
		private var pc:PreloadController;
		private var _asset:PhotoAsset;
		private var _pl:MovieClip;

		public function LargePhotoDisplay()
		{
			super();
		}
		
		public function set preloader(mc:MovieClip):void
		{
			_pl = mc;
		}
		
		public function loadAsset(asset:PhotoAsset):void
		{
			_asset = asset;
			pc = new PreloadController(415);
			pc.addItems([asset.large]);
			EventManager.gi().handleEvents(pc,this,"onPC",true);
			TweenMax.to(_pl,.3,{autoAlpha:1,ease:Quadratic.easeOut});
			pc.start();
		}
		
		public function onPCComplete(e:Event):void
		{
			DisplayListUtils.RemoveAllChildren(img);
			var b:Bitmap = AssetLibrary.gi().getBitmap(_asset.large.source);
			b.alpha = 0;
			img.addChild(b);
			TweenMax.to(b,.3,{alpha:1,ease:Quadratic.easeOut});
			hidePreloader();
		}
		
		public function onPCPreloadProgress(pe:PreloadProgressEvent):void
		{
			_pl.bar.width = pe.pixels;
		}

		public function set bitmap(bit:Bitmap):void
		{
			DisplayListUtils.RemoveAllChildren(img);
			hidePreloader();
			img.addChild(bit);
		}
		
		private function hidePreloader():void
		{
			if(_pl.alpha > 0) TweenMax.to(_pl,.3,{autoAlpha:0,ease:Quadratic.easeOut});
		}		}}