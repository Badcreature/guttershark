package scenes.bunker.subviews
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import fl.motion.easing.Quadratic;
	
	import gs.TweenMax;
	
	import net.guttershark.events.EventManager;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.sound.SoundManager;	

	public class Keypad extends MovieClip 
	{
		
		private var em:EventManager;
		private var pcm:PasswordedClipManager;
		private var pass:String;
		private var aaron:MovieClip;
		
		public var red:MovieClip;
		public var green:MovieClip;
		public var blue:MovieClip;
		public var errorLights:MovieClip;
		
		public function Keypad()
		{
			super();
			init();
			pass = "";
			pcm = PasswordedClipManager.gi();
			pcm.addEventListener("unlock", unlock);
			pcm.addEventListener("failedAttempt",failedAttempt);
		}

		private function init():void
		{
			em = EventManager.gi();
			em.disposeEventsForObject(stage);
			em.handleEvents(stage,this,"onStage");
			for(var i:int = 0; i < 12; i++)
			{
				var b:MovieClip = this["bg" + (i+1)];
				b.buttonMode = true;
				em.disposeEventsForObject(b);
				em.handleEvents(b.hit,this,"onBG",true);
			}
			green.visible = false;
			blue.visible = false;
		}
		
		private function failedAttempt(e:*):void
		{
			PasswordedClipManager.gi().unlocked = false;
			SoundManager.gi().playSound("PasswordIncorrect");
			pass = "";
			flashAll();
		}
		
		public function onBGMouseOver(e:Event):void
		{
			SoundManager.gi().playSound("CodeBtnRollover");
			var b:* = e.target.parent;
			b.loop = true;
			b.play();
		}
		
		public function onBGMouseOut(e:*):void
		{
			var b:* = e.target.parent;
			b.loop = false;
		}
		
		public function onBGClick(e:Event):void
		{
			SoundManager.gi().playSound("CodeBtnRelease");
			var b:String = e.target.parent.name.substring(2);
			keyDown(b);
		}

		private function keyDown(key:String):void
		{
			blue.visible = true;
			pass += key;
			if(pass == "6839") showAaronEgg();
			pcm.tryToUnlock(pass);
			setTimeout(hideBlue, 100);
		}
		
		private function showAaronEgg():void
		{
			aaron = AssetLibrary.gi().getMovieClipFromSWFLibrary("bunker", "AaronEgg");
			aaron.x = -110;
			aaron.y = 553;
			stage.addChild(aaron);
			SoundManager.gi().playSound("toasty");
			TweenMax.to(aaron,.3,{x:0,ease:Quadratic.easeOut,onComplete:hideAaron});
		}

		private function hideAaron():void
		{
			TweenMax.to(aaron,.3,{x:-110,ease:Quadratic.easeIn,delay:.1});
		}

		private function unlock(e:*):void
		{
			SoundManager.gi().playSound("PasswordCorrect");
			green.alpha = 0;
			TweenMax.to(green,.5,{autoAlpha:1,ease:Quadratic.easeIn});
			red.visible = false;
			blue.visible = false;
		}
		
		private function flashAll():void
		{
			red.visible = false;
			blue.visible = false;
			green.visible = false;
			errorLights.play();
		}
		
		private function hideBlue():void
		{
			blue.visible = false;
		}
		
		public function clearFlashAll():void
		{
			red.visible = true;
			pass = "";
		}	}}