package 
{
	import flash.display.MovieClip;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.events.EventManager;
	import net.guttershark.events.delegates.PreloadControllerEventListenerDelegate;
	import net.guttershark.model.Model;
	import net.guttershark.preloading.Asset;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.preloading.events.PreloadProgressEvent;
	import net.guttershark.sound.SoundManager;
	import net.guttershark.util.DisplayListUtils;
	
	import scenes.bunker.Bunker;
	import scenes.hallway.Hallway;	

	public class ShellController extends DocumentController
	{
		
		private static var inst:ShellController;
		private var al:AssetLibrary;
		private var em:EventManager;
		private var sm:SoundManager;
		private var md:Model;
		private var pc:PreloadController;
		private var gotoBunker:Boolean;
		private var bunkerAsset:Asset;
		private var hallwayAsset:Asset;
		
		public var movementClip:MovieClip;
		public var movementMouse0Point:MovieClip;
		
		public var hallway:Hallway;
		public var bunker:Bunker;
		public var preloader:MovieClip;
		
		public function ShellController()
		{
			super();
			if(ShellController.inst) throw new Error("ShellController is a singleton and cannot be instantiated more than once.");
			ShellController.inst = this;
		}
		
		public static function gi():ShellController
		{
			return inst;
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {model:"site.xml"};
		}

		override protected function setupComplete():void
		{
			super.setupComplete();
			PasswordedClipManager.gi().password = "1493";
			em = EventManager.gi();
			sm = SoundManager.gi();
			md = Model.gi();
			al = AssetLibrary.gi();
			em.addEventListenerDelegate(PreloadController,PreloadControllerEventListenerDelegate);
			hallwayAsset = md.getAssetByLibraryName("hallway");
			bunkerAsset = md.getAssetByLibraryName("bunker");
			pc = new PreloadController(1195);
			pc.addItems([hallwayAsset]);
			em.handleEvents(pc,this,"onHallwayPreloader");
			preloader.label.text = md.getAttribute("bunkerPreloadText");
			pc.start();
			movementClip = new MovieClip();
			movementMouse0Point = new MovieClip();
			addChild(movementMouse0Point);
			movementMouse0Point.x = 0;
			movementMouse0Point.y = 0;
			addChild(movementClip);
			movementClip.x = 600;
		}
				
		public function onHallwayPreloaderPreloadProgress(pe:PreloadProgressEvent):void
		{
			preloader.bar.width = pe.pixels;
		}

		public function onHallwayPreloaderComplete():void
		{
			em.disposeEventsForObject(pc);
			hallway = al.getMovieClipFromSWFLibrary("hallway", "HallwayMain") as Hallway;
			addChild(hallway);
		}
		
		public function prepareBunker():void
		{
			pc.addItems([bunkerAsset]);
			em.handleEvents(pc, this, "onBunkerPreloader");
			pc.start();
		}
		
		public function onBunkerPreloaderPreloadProgress(pe:PreloadProgressEvent):void
		{
			preloader.bar.width = pe.pixels;
		}

		public function onBunkerPreloaderComplete():void
		{
			em.disposeEventsForObject(pc);
			bunker = al.getMovieClipFromSWFLibrary("bunker", "BunkerMain") as Bunker;
			hallway.prepareEnterCodeView();
			bunker.preloadSections();
			bunker.movementReferencePoint = movementClip;
			bunker.movementMouse0Point = movementMouse0Point;
			addChild(bunker);
			DisplayListUtils.BringToFront(this,hallway);
			DisplayListUtils.BringToFront(this,preloader);
			if(gotoBunker) showBunker(true);
			initSoundsAfterBunkerLoaded();
		}
		
		private function initSoundsAfterBunkerLoaded():void
		{
			sm.addSound("ZoomIn",al.getSoundFromSWFLibrary("bunker","ZoomIn"));
			sm.addSound("ZoomOut",al.getSoundFromSWFLibrary("bunker","ZoomOut"));
			sm.addSound("BunkerLoop", al.getSoundFromSWFLibrary("bunker", "BunkerLoop"));
			sm.addSound("Close",al.getSoundFromSWFLibrary("bunker", "Close"));
			sm.addSound("CodeBtnRollover",al.getSoundFromSWFLibrary("bunker", "CodeBtnRollover"));
			sm.addSound("CodeBtnRelease",al.getSoundFromSWFLibrary("bunker", "CodeBtnRelease"));
			sm.addSound("PasswordCorrect",al.getSoundFromSWFLibrary("bunker", "PasswordCorrect"));
			sm.addSound("PasswordIncorrect",al.getSoundFromSWFLibrary("bunker", "PasswordIncorrect"));
			sm.addSound("toasty",al.getSoundFromSWFLibrary("bunker", "Toasty"));
			sm.addSound("OpenLocker",al.getSoundFromSWFLibrary("bunker", "OpenLocker"));
		}

		public function initSoundsAfterSectionsLoaded():void
		{
			sm.addSound("UpcomingIntro",al.getSoundFromSWFLibrary("upcoming", "UpcomingIntro"));
			sm.addSound("CastLoop",al.getSoundFromSWFLibrary("castSignup", "CastLoop"));
			sm.addSound("CrewLoop",al.getSoundFromSWFLibrary("crewSignup", "CrewLoop"));
			sm.addSound("PhotosIntro",al.getSoundFromSWFLibrary("photos", "PhotosIntro"));
			sm.addSound("BoxClose",al.getSoundFromSWFLibrary("investors", "BoxClose"));
			sm.addSound("BoxOpen",al.getSoundFromSWFLibrary("investors", "BoxOpen"));
			sm.addSound("LinksIntro",al.getSoundFromSWFLibrary("links", "LinksIntro"));
			sm.addSound("LinksLoading",al.getSoundFromSWFLibrary("links", "LinksLoading"));
			sm.addSound("ReelIntro",al.getSoundFromSWFLibrary("projector", "ReelIntro"));
			sm.addSound("ReelOutro",al.getSoundFromSWFLibrary("projector", "ReelOutro"));
			sm.addSound("LightFlickr3",al.getSoundFromSWFLibrary("projector", "LightFlickr3"));
			sm.addSound("LightFlickr2",al.getSoundFromSWFLibrary("projector", "LightFlickr2"));
			sm.addSound("ReelBigButton",al.getSoundFromSWFLibrary("projector", "ReelBigButton"));
			sm.addSound("ReelSmallButton",al.getSoundFromSWFLibrary("projector", "ReelSmallButton"));
			sm.addSound("NextClips",al.getSoundFromSWFLibrary("projector", "NextClips"));
		}
		
		public function set gotoBunkerIfNotLoaded(val:Boolean):void
		{
			gotoBunker = val;
		}
		
		public function showBunker(disposeOfHallway:Boolean = false):void
		{
			addChild(bunker);
			SoundManager.gi().playSound("BunkerLoop",0,1000);
			bunker.showBunker();
			DisplayListUtils.BringToFront(this,hallway);
			if(disposeOfHallway)
			{
				removeChild(hallway);
				hallway.dispose();
				hallway = null;
				bunker.addFrameForMovement();
			}
		}	}}