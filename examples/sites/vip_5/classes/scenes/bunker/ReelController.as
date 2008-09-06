package scenes.bunker 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	import fl.motion.easing.Quadratic;
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	
	import gs.TweenMax;
	
	import net.guttershark.events.EventManager;
	import net.guttershark.preloading.Asset;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.preloading.events.PreloadProgressEvent;
	import net.guttershark.sound.SoundManager;
	import net.guttershark.ui.controls.buttons.MovieClipButton;
	import net.guttershark.util.DisplayListUtils;
	import net.guttershark.util.MovieClipUtils;
	
	import scenes.bunker.views.ProjectorView;		

	public class ReelController extends MovieClip
	{
		
		public var preloader:MovieClip;
		public var timeHandle:MovieClip;
		public var power:MovieClipButton;
		public var volume:MovieClipButton;
		public var pause:MovieClipButton;
		public var clip1:MovieClipButton;
		public var clip2:MovieClipButton;
		public var clip3:MovieClipButton;
		public var trigger:MovieClip;
		public var previewHolder:MovieClip;
		public var clipLabels:MovieClip;
		public var powerLabel:MovieClip;
		public var pauseLabel:MovieClip;
		public var volumeLabel:MovieClip;
		public var _player:FLVPlayback;

		private var pc:PreloadController;
		private var em:EventManager;
		private var sm:SoundManager;
		
		private var pages:int;
		private var page:int;
		private var _dp:XML;
		private var _dpOffset:int;
		private var vidpath:String;
		private var previewpath:String;

		public function ReelController()
		{
			pc = new PreloadController(129);
			em = EventManager.gi();
			sm = SoundManager.gi();
			trigger.gotoAndStop(1);
			_dpOffset = 0;
			page = -1;
		}
		
		public function set dataProvider(val:XML):void
		{
			_dp = val;
			vidpath = _dp.@vidPath;
			previewpath = _dp.@prevPath;
			pages = Math.floor(_dp.video.length() / 3);
		}
		
		public function set player(flvp:FLVPlayback):void
		{
			_player = flvp;
			em.handleEvents(_player, this, "onFLV");
		}

		public function prepare():void
		{
			MovieClipUtils.SetButtonMode(true,power,volume,pause,clip1,clip2,clip3,trigger.hit);
			em.handleEventsForObjects(this,
				[power,volume,pause,clip1,clip2,clip3,trigger.hit],
				["onPower","onVolume","onPause","onClip1","onClip2","onClip3","onTrigger"]
			);
			power.downSound = "ReelBigButton";
			volume.downSound = "ReelBigButton";
			pause.downSound = "ReelBigButton";
			clip1.downSound = "ReelSmallButton";
			clip2.downSound = "ReelSmallButton";
			clip3.downSound = "ReelSmallButton";
		}
		
		public function onFLVPlayheadUpdate(ve:VideoEvent):void
		{
			var stx:Number = -195;
			var mx:Number = 525;
			var f:Number =  (_player.playheadPercentage / 100) * mx;
			timeHandle.x = stx + f;
		}

		public function loadFirstPreview():void
		{
			preloader.width = 0;
			TweenMax.to(preloader,.3,{autoAlpha:1,ease:Quadratic.easeOut});
			var n:XML = _dp.video[0];
			var src:String = n.@preview;
			var path:String = previewpath;
			var uri:String = path + src;
			var a:Asset = new Asset(uri,"previewPic");
			em.disposeEventsForObject(pc);
			em.handleEvents(pc, this, "onPC");
			pc.addItems([a]);
			pc.start();
			updateLabels();
		}
		
		public function loadPreview(a:Asset):void
		{
			DisplayListUtils.RemoveAllChildren(previewHolder);
			preloader.width = 0;
			TweenMax.to(preloader,.3,{autoAlpha:1,ease:Quadratic.easeOut});
			em.disposeEventsForObject(pc);
			em.handleEvents(pc,this,"onPC");
			pc.addItems([a]);
			pc.start();
		}
		
		public function playFirstFLV():void
		{
			var flv:String = _dp.video[0].@flv;
			_player.play(vidpath + flv);
			TweenMax.to(_player,.3,{autoAlpha:1,ease:Quadratic.easeOut});
		}

		public function updateLabels():void
		{
			if(page == pages) page = -1;
			page++;
			_dpOffset = page*3;
			
			//trace("UPDATE LABELS",pages,page,_dpOffset);
			
			if(_dp.video[_dpOffset]) clipLabels.clip1.label.label.text = _dp.video[_dpOffset].@name;
			else clipLabels.clip1.label.label.text = "COMING SOON";
			
			if(_dp.video[_dpOffset+1]) clipLabels.clip2.label.label.text = _dp.video[_dpOffset+1].@name;
			else clipLabels.clip2.label.label.text = "COMING SOON";
			
			if(_dp.video[_dpOffset+2]) clipLabels.clip3.label.label.text = _dp.video[_dpOffset+2].@name;
			else clipLabels.clip3.label.label.text = "COMING SOON";
			
			clipLabels.clip1.play();
			clipLabels.clip2.play();
			clipLabels.clip3.play();
		}

		public function onTriggerClick():void
		{
			trigger.play();
			updateLabels();
			sm.playSound("NextClips");
		}

		public function onPCComplete():void
		{
			var b:Bitmap = AssetLibrary.gi().getBitmap("previewPic");
			//var o:Object = MathUtils.ConstrainedResize(300, 300, b.width, b.height);
			//b.width = o.w;
			//b.height = o.h;
			previewHolder.addChild(b);
			TweenMax.to(preloader,.3,{autoAlpha:0,ease:Quadratic.easeOut});
		}

		public function onPCPreloadProgress(pe:PreloadProgressEvent):void
		{
			preloader.width = pe.pixels;
		}

		public function onPowerClick():void
		{
			ProjectorView(parent).onCloseClick();
		}
		
		public function onPowerMouseOver():void
		{
			powerLabel.play();
		}
		
		public function onVolumeClick():void
		{
			if(_player.volume == 1) _player.volume = 0;
			else _player.volume = 1;
		}

		public function onVolumeMouseOver():void
		{
			volumeLabel.play();
		}
		
		public function onPauseClick():void
		{
			if(!_player.source) return;
			if(_player.playing) _player.pause();
			else _player.play();
		}
		
		public function onPauseMouseOver():void
		{
			pauseLabel.play();
		}
		
		public function onClip1Click():void
		{
			var n:Number = _dpOffset;
			if(!_dp.video[n])
			{
				SoundManager.gi().playSound("PasswordIncorrect");
				return;
			}
			loadnPreview(n);
			var src:String = vidpath + _dp.video[n].@flv;
			_player.play(src);
		}
		
		public function onClip2Click():void
		{
			var n:Number = _dpOffset+1;
			if(!_dp.video[n])
			{
				SoundManager.gi().playSound("PasswordIncorrect");
				return;
			}
			loadnPreview(n);
			var src:String = vidpath + _dp.video[n].@flv;
			_player.play(src);
		}
		
		public function onClip3Click():void
		{
			var n:Number = _dpOffset+2;
			if(!_dp.video[n])
			{
				SoundManager.gi().playSound("PasswordIncorrect");
				return;
			}
			loadnPreview(n);
			var src:String = vidpath + _dp.video[n].@flv;
			//_player.stop();
			_player.play(src);
		}
		
		private function loadnPreview(index:int):void
		{
			var n:XML = _dp.video[index];
			var src:String = n.@preview;
			var path:String = previewpath;
			var uri:String = path + src;
			var a:Asset = new Asset(uri,"previewPic");
			loadPreview(a);
		}
		
		public function dispose():void
		{
			_player.stop();
			em.disposeEventsForObject(_player);
			em.disposeEventsForObjects(power,volume,pause,clip1,clip2,clip3,trigger.hit);
		}
	}}