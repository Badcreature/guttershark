package scenes.bunker.views
{
	import flash.display.MovieClip;
	
	import gs.TweenMax;
	
	import net.guttershark.events.EventManager;
	import net.guttershark.preloading.Asset;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.PreloadController;
	
	import scenes.bunker.subviews.LargePhotoDisplay;
	import scenes.bunker.subviews.Photo;
	import scenes.bunker.subviews.PhotoAsset;
	import scenes.bunker.subviews.PhotosOnRope;
	import scenes.bunker.subviews.PhotosPageDisplay;	

	public class PhotosView extends ZoomView
	{	
		
		//public var shell:*;
		private var pc:PreloadController;
		private var em:EventManager;
		private var photosXML:XML;
		private var unlockedPhotoAssets:Array;
		private var lockedPhotoAssets:Array;
		private var goingOut:Boolean;
		
		public var photoDisplay:LargePhotoDisplay;
		public var unlockedPhotosOnRope:PhotosOnRope;
		public var lockedPhotosOnRope:PhotosOnRope;
		public var lockedBG:MovieClip;
		public var unlockedBG:MovieClip;
		public var unlockedPages:PhotosPageDisplay;
		public var lockedPages:PhotosPageDisplay;
		public var preloader:MovieClip;
		
		public function PhotosView()
		{
			super();
			unlockedPhotoAssets = [];
			lockedPhotoAssets = [];
			em = EventManager.gi();
		}
		
		public function prepareXML():void
		{
			if(!pc) pc = new PreloadController();
			if(AssetLibrary.gi().isAvailable("photosXML"))
			{
				setupPhotoAssets();
				return;
			}
			pc.addItems([new Asset("assets/photos.xml","photosXML")]);
			em.handleEvents(pc, this, "onPC");
			pc.start();
		}
		
		public function prepareImages():void
		{
			if(goingOut) return;
			 
			unlockedPages.photosOnRope = unlockedPhotosOnRope;
			unlockedPages.dataProvider = unlockedPhotoAssets;
			unlockedPages.showInitial();			
			lockedPages.visible = false;
			lockedPhotosOnRope.visible = false;
			lockedPhotosOnRope.enabled = false;
			
			if(PasswordedClipManager.gi().unlocked)
			{
				lockedBG.visible = false;
				lockedPages.visible = true;
				lockedPhotosOnRope.enabled = true;
				lockedPhotosOnRope.alpha = 0;
				lockedPhotosOnRope.visible = true;
				lockedPages.photosOnRope = lockedPhotosOnRope;
				lockedPages.dataProvider = lockedPhotoAssets;
				lockedPages.showInitial();
				TweenMax.to(lockedPhotosOnRope,.4,{alpha:1});
			}
			
			unlockedPhotosOnRope.ph0.holder.img.rotation = 5;
			unlockedPhotosOnRope.ph1.holder.img.rotation = 5;
			unlockedPhotosOnRope.ph2.holder.img.rotation = 5;
			unlockedPhotosOnRope.ph3.holder.img.rotation = -.2;
			unlockedPhotosOnRope.ph4.holder.img.rotation = -.3;
			unlockedPhotosOnRope.ph0.holder.img.x -= 20;
			unlockedPhotosOnRope.ph0.holder.img.y -= 20;
			unlockedPhotosOnRope.ph1.holder.img.x -=20;
			unlockedPhotosOnRope.ph1.holder.img.y -=20;
			unlockedPhotosOnRope.ph2.holder.img.x -= 20;
			unlockedPhotosOnRope.ph2.holder.img.y -= 20;
			unlockedPhotosOnRope.ph3.holder.img.x -= 20;
			unlockedPhotosOnRope.ph3.holder.img.y -= 20;
			unlockedPhotosOnRope.ph4.holder.img.x -=20;
			unlockedPhotosOnRope.ph4.holder.img.y -=20;
			lockedPhotosOnRope.ph0.holder.img.rotation = 5;
			lockedPhotosOnRope.ph1.holder.img.rotation = 5;
			lockedPhotosOnRope.ph2.holder.img.rotation = 5;
			lockedPhotosOnRope.ph3.holder.img.rotation = -.2;
			lockedPhotosOnRope.ph4.holder.img.rotation = -.3;
			lockedPhotosOnRope.ph0.holder.img.x -= 20;
			lockedPhotosOnRope.ph0.holder.img.y -= 20;
			lockedPhotosOnRope.ph1.holder.img.x -=20;
			lockedPhotosOnRope.ph1.holder.img.y -=20;
			lockedPhotosOnRope.ph2.holder.img.x -= 20;
			lockedPhotosOnRope.ph2.holder.img.y -= 20;
			lockedPhotosOnRope.ph3.holder.img.x -= 20;
			lockedPhotosOnRope.ph3.holder.img.y -= 20;
			lockedPhotosOnRope.ph4.holder.img.x -=20;
			lockedPhotosOnRope.ph4.holder.img.y -=20;
		}
		
		public function onPCComplete():void
		{
			em.disposeEventsForObject(pc);
			photosXML = AssetLibrary.gi().getXML("photosXML");
			setupPhotoAssets();
		}
		
		private function setupPhotoAssets():void
		{
			unlockedPhotoAssets = [];
			lockedPhotoAssets = [];
			var photo:XML;
			var photoAsset:PhotoAsset;
			for each(photo in photosXML.unlocked..photo)
			{
				photoAsset = new PhotoAsset();
				photoAsset.thumb = new Asset("assets/" + photosXML.unlocked.@thumb_path + photo.@thumb_src);
				photoAsset.large = new Asset("assets/" + photosXML.unlocked.@large_path + photo.@large_src);
				unlockedPhotoAssets.push(photoAsset);
			}
			
			if(PasswordedClipManager.gi().unlocked)
			{
				for each(photo in photosXML.locked..photo)
				{
					photoAsset = new PhotoAsset();
					photoAsset.thumb = new Asset("assets/" + photosXML.locked.@thumb_path + photo.@thumb_src);
					photoAsset.large = new Asset("assets/" + photosXML.locked.@large_path + photo.@large_src);
					lockedPhotoAssets.push(photoAsset);
				}
			}
		}
		
		override public function hide():void
		{
			goingOut = true;
			TweenMax.to(lockedPhotosOnRope,.1,{alpha:0});
			super.hide();
		}
		
		override public function show():void
		{
			goingOut = false;
			super.show();
		}

		override protected function animationComplete():void
		{
			super.animationComplete();
			unlockedPhotosOnRope.displayClip = photoDisplay;
			lockedPhotosOnRope.displayClip = photoDisplay;
			photoDisplay.preloader = preloader;
			unlockedPages.displayFirstImage();
		}	}
}