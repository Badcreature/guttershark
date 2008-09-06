package scenes.bunker.subviews 
{
	import flash.display.MovieClip;
	
	import net.guttershark.events.EventManager;
	import net.guttershark.preloading.Asset;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.util.DisplayListUtils;		

	public class Photo extends MovieClip
	{
		
		private var pc:PreloadController;
		private var em:EventManager;
		
		public var display:LargePhotoDisplay;
		public var asset:PhotoAsset;		
		public var holder:MovieClip;
		public var hit:MovieClip;

		public function Photo():void
		{
			em = EventManager.gi();
			em.handleEvents(hit,this,"onHit");
			pc = new PreloadController();
		}
		
		public function displayAsLarge():void
		{
			onHitClick();
		}

		public function onHitClick():void
		{
			if(AssetLibrary.gi().isAvailable(asset.large.source)) display.bitmap = AssetLibrary.gi().getBitmap(asset.large.source);
			else display.loadAsset(asset);
		}
		
		public function loadThumb():void
		{
			if(AssetLibrary.gi().isAvailable(asset.thumb.source))
			{
				DisplayListUtils.RemoveAllChildren(holder.img);
				holder.img.addChild(AssetLibrary.gi().getBitmap(asset.thumb.source));
			}
			else
			{
				pc.addItems([asset.thumb]);
				em.handleEvents(pc, this, "onPC");
				pc.start();
			}
		}

		public function onPCComplete():void
		{
			holder.img.addChild(AssetLibrary.gi().getBitmap(asset.thumb.source));
		}
	}}