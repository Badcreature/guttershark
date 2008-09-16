package scenes.hallway
{
	import flash.display.MovieClip;
	
	import fl.motion.easing.Quadratic;
	import fl.video.FLVPlayback;
	import fl.video.MetadataEvent;
	import fl.video.VideoEvent;
	
	import gs.TweenMax;
	
	import net.guttershark.events.EventManager;
	import net.guttershark.managers.KeyboardEventManager;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.sound.SoundManager;
	import net.guttershark.ui.controls.buttons.MovieClipButton;
	import net.guttershark.util.MovieClipUtils;
	
	import scenes.bunker.views.EnterCodeView;	

	public class Hallway extends MovieClip 
	{
		
		private var sh:ShellController;
		private var em:EventManager;
		private var prepared:Boolean;
		private var enterCodeView:EnterCodeView;
		
		public var continueToBunker:MovieClip;
		public var player:FLVPlayback;
		public var enterCode:MovieClip;
		public var cover:MovieClip;
		public var skip:MovieClipButton;

		public function Hallway():void
		{
			super();
			sh = ShellController.gi();
			MovieClipUtils.SetVisible(false,continueToBunker,skip,enterCode,cover);
			MovieClipUtils.SetButtonMode(true,continueToBunker,enterCode,skip);
			player.bufferTime = 1;
			player.autoPlay = true;
			player.source = "./assets/intro.flv";
			player.addEventListener(VideoEvent.PLAYING_STATE_ENTERED,onplaying,false,0,true);
			player.addEventListener(MetadataEvent.CUE_POINT, onCuepoint,false,0,true);
			player.addEventListener(VideoEvent.COMPLETE, oncomplete,false,0,true);
			SoundManager.gi().addSprite(player);
			em = EventManager.gi();
			em.handleEvents(continueToBunker,this,"onContinue");
			em.handleEvents(enterCode,this,"onEnterCode");
			em.handleEvents(skip,this,"onSkip");
		}
		
		public function onCuepoint(me:MetadataEvent):void
		{
			switch(me.info.name)
			{
				case "explosion":
					showContinueToBunker();
					player.stop();
					break;
				case "enter":
					break;
			}
		}
		
		public function prepareEnterCodeView():void
		{
			enterCodeView = AssetLibrary.gi().getMovieClipFromSWFLibrary("bunker", "EnterCode") as EnterCodeView;
			addChild(enterCodeView);
			enterCode.visible = false;
		}

		public function onSkipClick():void
		{
			hideCover();
			closePlayer();
			sh.showBunker(true);
		}

		public function onEnterCodeClick():void
		{
			continueToBunker.visible = false;
			enterCode.visible = false;
			enterCodeView.addEventListener("hiding",onHidingEnterCode,false,0,true);
			enterCodeView.show();
		}
		
		private function onHidingEnterCode(e:*):void
		{
			if(PasswordedClipManager.gi().unlocked)
			{
				//player.seekToNextNavCuePoint();
				var o:Object = player.findCuePoint("enter");
				player.seek(o.time);
				player.play();
				hideCover();
				hideSkip();
				sh.showBunker();
			}
			else
			{
				enterCode.visible = true;
				continueToBunker.visible = true;
			}
		}

		private function oncomplete(ve:VideoEvent):void
		{
			sh.bunker.addFrameForMovement();
			dispose();
		}

		private function onplaying(e:*):void
		{
			if(!prepared)
			{
				prepared = true;
				sh.prepareBunker();
				//showContinueToBunker();
			}
			else
			{
				sh.bunker.startSectionLoading();
			}
		}
		
		public function onContinueClick():void
		{
			hideCover();
			enterCode.visible = false;
			continueToBunker.visible = false;
			closePlayer();
			hideSkip();
			player.play();
			sh.showBunker();
		}
		
		private function hideCover():void
		{
			TweenMax.to(cover,.3,{autoAlpha:0,ease:Quadratic.easeOut});
		}
				
		private function closePlayer():void
		{
			player.stop();
		}

		public function showSkip():void
		{
			skip.alpha = 0;
			skip.visible = true;
			TweenMax.to(skip,.3,{alpha:1,ease:Quadratic.easeOut,y:"10",delay:.5});
		}
		
		public function hideSkip():void
		{
			TweenMax.to(skip,.3,{autoAlpha:0,ease:Quadratic.easeOut});
		}
		
		public function showContinueToBunker():void
		{
			TweenMax.to(cover,.3,{autoAlpha:.75,ease:Quadratic.easeOut});
			continueToBunker.visible = true;
			enterCode.visible = true;
		}
		
		private function disposeKeyEvents():void
		{
			KeyboardEventManager.gi().removeMapping(stage,"CONTROL+SHIFT+F");	
		}
		
		public function dispose():void
		{	
			em.disposeEventsForObject(continueToBunker);
			em.disposeEventsForObject(enterCode);
			em.disposeEventsForObject(skip);
			removeChild(player);
			removeChild(cover);
			removeChild(enterCode);
			removeChild(continueToBunker);
			removeChild(skip);
			sh = null;
			em = null;
			skip = null;
			continueToBunker = null;
			cover = null;
			player = null;
			enterCode = null;
		}	}}