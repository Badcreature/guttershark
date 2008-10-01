package scenes.bunker.views
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	
	import gs.TweenMax;
	
	import net.guttershark.events.EventManager;
	import net.guttershark.model.Model;
	import net.guttershark.preloading.Asset;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.sound.SoundManager;	

	public class LinksView extends ZoomView
	{
		
		public var radar_mc:FLVPlayback;
		public var unlocked_links_mc:MovieClip;
		public var linksholder:MovieClip;
		private var pc:PreloadController;
		private var em:EventManager;
		private var update:Boolean;
		private var linksXML:XML;
		private var linksXMLAsset:Asset;

		public function LinksView()
		{
			super();
		}
		
		public function loadXML():void
		{
			if(AssetLibrary.gi().isAvailable("linksXML")) return;
			unlocked_links_mc.alpha = 0;
			unlocked_links_mc.visible = false;
			pc = new PreloadController();
			em = EventManager.gi();
			em.handleEvents(pc, this,"onPC");
			linksXMLAsset = Model.gi().getAssetByLibraryName("linksXML");
			pc.addItems([linksXMLAsset]);
			pc.start();
			SoundManager.gi().playSound("LinksLoading");
		}

		public function onPCComplete():void
		{
			em.disposeEventsForObject(pc);
			linksXML = AssetLibrary.gi().getXML("linksXML");
			if(update)
			{
				update = false;
				updateView();
			}
		}
		
		public function updateView():void
		{
			//PasswordedClipManager.gi().unlock();
			radar_mc.addEventListener(VideoEvent.COMPLETE, onFLVComplete);
			if(!linksXML) return;
			unlocked_links_mc.visible = false;
			unlocked_links_mc.alpha = 0;
			createLinks();
			if(PasswordedClipManager.gi().unlocked)
			{
				unlocked_links_mc.visible = true;
				unlocked_links_mc.alpha = 1;
			}
		}

		private function createLinks():void
		{
			var prev:MovieClip;
			var c:int = 0;
			var link:XML;
			var li:MovieClip;
			var del:Number = .025;
			for each(link in linksXML.open.link)
			{
				li = AssetLibrary.gi().getMovieClipFromSWFLibrary("links", "LinkItem");
				li.label.text = link.@title;
				li.buttonMode = true;
				li.data = link;
				if(c > 12)
				{
					if(c == 13) prev = null;
					li.x = 350;
					li.y = (prev == null) ? 0 : prev.y + prev.height;
				}
				else
				{
					li.y = (prev == null) ? 0 : prev.y + prev.height;
				}
				em.handleEvents(li, this, "onItem",true);
				li.alpha = 0;
				TweenMax.to(li,.3,{delay:del,alpha:1});
				del += .025;
				prev = li;
				linksholder.addChild(li);
				c++;
			}
			del = .025;
			if(PasswordedClipManager.gi().unlocked)
			{
				c = 0;
				prev = null;
				for each(link in linksXML.unlocked.link)
				{
					li = AssetLibrary.gi().getMovieClipFromSWFLibrary("links", "LinkItem");
					li.label.text = link.@title;
					li.buttonMode = true;
					li.data = link;
					if(c > 3)
					{
						if(c == 4) prev = null;
						li.x = 350;
						li.y = (prev == null) ? 0 : prev.y + prev.height;
					}
					else
					{
						li.y = (prev == null) ? 0 : prev.y + prev.height;
					}
					li.alpha = 0;
					TweenMax.to(li,.3,{delay:del,alpha:1});
					del += .03;
					em.handleEvents(li,this,"onItem",true);
					prev = li;
					unlocked_links_mc.linksholder.addChild(li);
					c++;
				}
			}
		}
		
		public function onItemClick(me:MouseEvent):void
		{
			navigateToURL(new URLRequest(MovieClip(me.currentTarget).data.@href),"_blank");
		}

		public function onFLVComplete(event:*):void
		{
      		event.target.play();
		}	}}