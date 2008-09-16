package scenes.bunker
{
	import flash.events.Event;	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import fl.motion.easing.Quadratic;
	import fl.video.FLVPlayback;
	import fl.video.VideoAlign;
	import fl.video.VideoScaleMode;
	
	import gs.TweenMax;
	
	import net.guttershark.events.EventManager;
	import net.guttershark.events.delegates.components.FLVPlaybackEventListenerDelegate;
	import net.guttershark.model.Model;
	import net.guttershark.preloading.Asset;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.preloading.events.PreloadProgressEvent;
	import net.guttershark.sound.SoundManager;
	import net.guttershark.util.DisplayListUtils;
	import net.guttershark.util.FramePulse;
	import net.guttershark.util.RandomArrayElement;
	
	import scenes.bunker.views.CastSignupView;
	import scenes.bunker.views.CrewSignupView;
	import scenes.bunker.views.EnterCodeView;
	import scenes.bunker.views.InvestorsView;
	import scenes.bunker.views.LinksView;
	import scenes.bunker.views.PhotosView;
	import scenes.bunker.views.ProjectorView;
	import scenes.bunker.views.UpcomingProjects;	

	public class Bunker extends MovieClip
	{
		
		private var sh:ShellController;
		private var md:Model;
		private var em:EventManager;
		private var pc:PreloadController;
		private var pcm:PasswordedClipManager;
		
		//stage clips
		public var photos:MovieClip;
		public var reel:MovieClip;
		public var enterCode:MovieClip;
		public var investors:MovieClip;
		public var light:MovieClip;
		public var spool:MovieClip;
		public var links:MovieClip;
		public var upcomingEvents:MovieClip;
		public var castSignupHit:MovieClip;
		public var crewSignupHit:MovieClip;
		public var cover:MovieClip;
		public var table:MovieClip;
		public var lockers:MovieClip;
		public var dresser:MovieClip;
		
		//views
		public var projectorView:ProjectorView;
		public var upcomingProjectsView:UpcomingProjects;
		public var photosView:PhotosView;
		public var enterCodeView:EnterCodeView;
		public var linksView:LinksView;
		public var investorsView:InvestorsView;
		public var crewSignupView:CrewSignupView;
		public var castSignupView:CastSignupView;
		private var removeTimeout:Number;
		
		//flicker light vars
		private var lightSequence:Array;
		private var flick:Number;
		private var inView:Boolean;
		
		//random clips
		public var rclip:FLVPlayback;
		private var tmr:Timer;
		private var rae:RandomArrayElement;
		public var rand:FLVPlayback;
		
		//movement
		public var movementMouse0Point:MovieClip;
		public var _movementReferencePoint:MovieClip;
		public var localMovementReference:MovieClip;

		//swf assets
		private var crewAsset:Asset;
		private var castAsset:Asset;
		private var investorsAsset:Asset;
		private var linksAsset:Asset;
		private var photosAsset:Asset;
		private var upcomingAsset:Asset;
		private var projectorAsset:Asset;
		
		private var active:Boolean;
		
		public function Bunker()
		{
			sh = ShellController.gi();
			pcm = PasswordedClipManager.gi();
			md = Model.gi();
			em = EventManager.gi();
			em.addEventListenerDelegate(FLVPlayback,FLVPlaybackEventListenerDelegate);
			
			castSignupHit.buttonMode = true;
			crewSignupHit.buttonMode = true;
			photos.buttonMode = true;
			upcomingEvents.hit.buttonMode = true;
			investors.hit.buttonMode = true;
			enterCode.buttonMode = true;
			spool.hit.buttonMode = true;
			links.hit.buttonMode = true;
			
			crewAsset = md.getAssetByLibraryName("crewSignup");
			castAsset = md.getAssetByLibraryName("castSignup");
			investorsAsset = md.getAssetByLibraryName("investors");
			linksAsset = md.getAssetByLibraryName("links");
			photosAsset = md.getAssetByLibraryName("photos");
			upcomingAsset = md.getAssetByLibraryName("upcoming");
			projectorAsset = md.getAssetByLibraryName("projector");
			
			em.handleEvents(this, this, "onStage");
			em.handleEvents(crewSignupHit,this,"onCrewHit");
			em.handleEvents(castSignupHit,this,"onCastHit");
			em.handleEvents(photos.hit,this,"onPhotos");
			em.handleEvents(spool.hit,this,"onSpool");
			em.handleEvents(upcomingEvents.hit,this,"onUpcoming");
			em.handleEvents(enterCode,this,"onEnterCode");
			em.handleEvents(links.hit,this,"onLinks");
			em.handleEvents(investors.hit,this,"onInvestors");
			lightSequence = [];
			
			rand.align = VideoAlign.BOTTOM_LEFT;
			rand.scaleMode = VideoScaleMode.NO_SCALE;
			em.handleEvents(rand, this, "onRand");
			
			inView = true;
			active = true;
			flick = 0;
		}

		public function onStageDeactivate():void
		{
			//trace("deactive");
			active = false;
			removeFrameForMovement();
			this.x = 0;
		}
		
		public function onStageActivate():void
		{
			active = true;
			if(inView || rand.playing) return;
			addFrameForMovement();
		}
		
		public function onRandComplete():void
		{
			//trace("calling from onRandComplete");
			addFrameForMovement();
		}

		public function set movementReferencePoint(clip:MovieClip):void
		{
			_movementReferencePoint = clip;
		}
		
		public function addFrameForMovement():void
		{
			if(!active) return;
			//trace("ADD FRAME FOR MOVEMENT");
			FramePulse.AddEnterFrameListener(onFrame);
		}
		
		private function removeFrameForMovement():void
		{
			//trace("REMOVE FRAME FOR MOVEMENT");
			FramePulse.RemoveEnterFrameListener(onFrame);
		}

		private function onFrame(e:Event):void
		{
			
			if(movementMouse0Point.mouseX == 16777216) return;
			
			if(!active) return;
			//trace("ON FRAME",movementMouse0Point.mouseX);
			
			var t:Number = (((17/ 600) * movementMouse0Point.mouseX) - 17) * -1;
			var dif:Number = Math.ceil(t - x);
			this.x += dif / 12;
			
			var ta:Number = (((3 / 600) * movementMouse0Point.mouseX) - 3) * -1;
			var tdif:Number = Math.ceil(571 + (ta - table.x)); 
			table.x += tdif / 18;
			
			var u:Number = (((3 / 600) * movementMouse0Point.mouseX) - 3) * -1;
			var udif:Number = Math.ceil(768 + (u - upcomingEvents.x));
			upcomingEvents.x += udif / 18;
			
			var s:Number = (((3 / 600) * movementMouse0Point.mouseX) - 3) * -1;
			var sdif:Number = Math.ceil(953 + (s - spool.x));
			spool.x += sdif / 18;
			
			var li:Number = (((3 / 600) * movementMouse0Point.mouseX) - 3) * -1;
			var lidif:Number = Math.ceil(705 + (li - light.x));
			light.x += lidif / 18;
			
			/*var i:Number = (((10 / 600) * movementMouse0Point.mouseX) - 10) * -1;
			var idif:Number = Math.ceil(298 + (i - investors.x));
			investors.x += idif / 30;
			
			var l:Number = (((10 / 600) * movementMouse0Point.mouseX) - 10) * -1;
			var ldif:Number = Math.ceil(204 + (l - links.x));
			links.x += ldif / 30;
			
			var d:Number = (((10 / 600) * movementMouse0Point.mouseX) - 10) * -1;
			var ddif:Number = Math.ceil(669 + (d - dresser.x));
			dresser.x += ddif / 30;
			
			var lo:Number = (((10 / 600) * movementMouse0Point.mouseX) - 10) * -1;
			var lodif:Number = Math.ceil(815 + (lo - lockers.x));
			lockers.x += lodif / 30;
			
			var p:Number = (((10 / 600) * movementMouse0Point.mouseX) - 10) * -1;
			var pdif:Number = Math.ceil(277 + (p - photos.x));
			photos.x += pdif / 20;*/
		}

		public function showBunker():void
		{
			inView = false;
			TweenMax.to(cover,1,{autoAlpha:0,ease:Quadratic.easeOut,onComplete:removeChild,onCompleteParams:[cover]});
			if(!AssetLibrary.gi().isAvailable("photos")) preloadSections();
			flick = setTimeout(flickerLight, 2000);
			rae = new RandomArrayElement(VIPModel.gi().getRandomClips());
			tmr = new Timer(VIPModel.gi().getRandomClipFrequence());
			em.handleEvents(tmr, this, "onTimer");
			tmr.start();
		}
		
		public function preloadSections():void
		{
			pc = new PreloadController(1195);
			pc.addItems([photosAsset,upcomingAsset,projectorAsset,crewAsset,castAsset,investorsAsset,linksAsset]);
			em.handleEvents(pc,this,"onPreloader");
			sh.preloader.label.text = Model.gi().getAttribute("bunkerSectionPreloadText");
			sh.preloader.bar.width = 0;
			DisplayListUtils.BringToFront(sh,sh.preloader);
			pc.start();
		}
		
		public function onTimerTimer():void
		{
			if(inView) return;
			var r:RandomClip = rae.getRandomElement();
			if(r.x) rand.x = r.x;
			if(r.y) rand.y = r.y;
			if(r.w) rand.width = r.w;
			if(r.h) rand.height = r.h;
			TweenMax.to(rand,.3,{autoAlpha:1});
			//rand.seek(0);
			rand.play(r.src);
			removeFrameForMovement();
		}
		
		public function pauseSectionLoading():void
		{
			if(pc.working) pc.stop();
		}
		
		public function startSectionLoading():void
		{
			if(!pc.working) pc.start();
		}
		
		public function onPreloaderPreloadProgress(pe:PreloadProgressEvent):void
		{
			TweenMax.to(sh.preloader.bar,.5,{width:pe.pixels,ease:Quadratic.easeOut});
		}

		public function onPreloaderComplete():void
		{
			TweenMax.to(sh.preloader,.3,{autoAlpha:0,ease:Quadratic.easeOut});
			em.disposeEventsForObject(pc);
			crewSignupView = AssetLibrary.gi().getMovieClipFromSWFLibrary("crewSignup", "CrewSignup") as CrewSignupView;
			castSignupView = AssetLibrary.gi().getMovieClipFromSWFLibrary("castSignup", "CastSignup") as CastSignupView;
			linksView = AssetLibrary.gi().getMovieClipFromSWFLibrary("links", "Links") as LinksView;
			investorsView = AssetLibrary.gi().getMovieClipFromSWFLibrary("investors", "Investors") as InvestorsView;
			photosView = AssetLibrary.gi().getMovieClipFromSWFLibrary("photos", "Photos") as PhotosView;
			upcomingProjectsView = AssetLibrary.gi().getMovieClipFromSWFLibrary("upcoming", "Upcoming") as UpcomingProjects;
			projectorView = AssetLibrary.gi().getMovieClipFromSWFLibrary("projector", "Projector") as ProjectorView;
			castSignupView.loopSound = "CastLoop";
			crewSignupView.loopSound = "CrewLoop";
			upcomingProjectsView.introSound = "UpcomingIntro";
			photosView.introSound = "PhotosIntro";
			linksView.introSound = "LinksIntro";
			projectorView.introSound = "ReelIntro";
			projectorView.outroSound = "ReelOutro";
			projectorView.playInZoom = false;
			projectorView.playOutZoom = false;
			castSignupView.submitURL = md.getAttribute("castSignupSubmit");
			castSignupView.imageUploadSubmit = md.getAttribute("imageUploadSubmit");
			castSignupView.uploadedImageStore = md.getAttribute("imageUploadStore");
			crewSignupView.submitURL = md.getAttribute("crewSignupSubmit");
			crewSignupView.imageUploadSubmit = md.getAttribute("imageUploadSubmit");
			crewSignupView.uploadedImageStore = md.getAttribute("imageUploadStore");
			ShellController.gi().initSoundsAfterSectionsLoaded();
			ShellController.gi().hallway.showSkip();
		}

		private function onFrameForLight(e:*):void
		{
			if(lightSequence.length < 1)
			{
				FramePulse.RemoveEnterFrameListener(onFrameForLight);
				light.highlight.visible = true;
				return;
			}
			light.gotoAndStop(1);
			lightSequence.shift();
			light.highlight.visible = lightSequence[0];
		}

		private function flickerLight():void
		{
			if(inView) return;
			if(Math.random() * 400 < 50) projectorView.playLightFlickr();
			if(lightSequence.length < 1)
			{
				var c:int= Math.floor( Math.random() * 12 - 1);
				for(var i:int = 0; i < c; i++)
				{
					if(Math.random() * 2 < 1) lightSequence.push(true);
					else lightSequence.push(false);
				}
			}
			if(Math.random() * 100 < 100) FramePulse.AddEnterFrameListener(onFrameForLight);
			flick = setTimeout(flickerLight, 2000);
		}
		
		private function showHideView(view:ZoomView):void
		{
			if(view.currentFrame > 1)
			{
				TweenMax.to(this,.2,{x:0});
				view.hide();
				//trace("calling from showHideView");
				addFrameForMovement();
				removeTimeout = setTimeout(remove,2000,view);
			}
			else
			{
				removeFrameForMovement();
				TweenMax.to(this,.2,{x:0});
				clearTimeout(removeTimeout);
				inView = true;
				if(rand.playing)
				{
					rand.stop();
				}
				TweenMax.to(rand,.3,{autoAlpha:0,onComplete:rand.seek,onCompleteParams:[0]});
				if(!contains(view)) addChild(view);
				view.show();
			}
		}

		public function onCrewHitClick():void
		{
			SoundManager.gi().playSound("OpenLocker");
			showHideView(crewSignupView);
		}

		public function onCastHitClick():void
		{
			SoundManager.gi().playSound("OpenLocker");
			showHideView(castSignupView);
		}

		public function remove(view:ZoomView):void
		{
			if(!contains(view)) return;
			removeChild(view);
			inView = false;
			flick = setTimeout(flickerLight, 2000);
		}

		public function onPhotosMouseOver():void
		{
			if(photosView) photosView.prepareXML();
		}
		
		public function onSpoolMouseOver():void
		{
			if(projectorView) projectorView.prepareXML();
		}

		public function onPhotosClick():void
		{
			showHideView(photosView);
		}
		
		public function onSpoolClick():void
		{
			showHideView(projectorView);
		}

		public function onUpcomingClick():void
		{
			showHideView(upcomingProjectsView);
		}

		public function onEnterCodeClick():void
		{
			showHideView(enterCodeView);
		}
		
		public function onLinksClick():void
		{
			showHideView(linksView);
		}

		public function onInvestorsClick():void
		{
			showHideView(investorsView);
		}
	}}