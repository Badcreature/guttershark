package scenes.bunker.views
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import fl.motion.easing.Quadratic;
	
	import gs.TweenMax;
	
	import scenes.bunker.subviews.Keypad;	

	public class EnterCodeView extends ZoomView 
	{
		
		public var keypad:Keypad;
		public var cover:MovieClip;
		public var blocker:MovieClip;
		private var pcm:PasswordedClipManager;

		public function EnterCodeView()
		{
			super();
			pcm = PasswordedClipManager.gi();
			pcm.addEventListener("unlock",onUnlock);
		}

		override public function onCloseClick():void
		{
			super.onCloseClick();
			dispatchEvent(new Event("closing"));
		}
		
		private function onUnlock(e:*):void
		{
			setTimeout(dohide,500);
		}

		private function dohide():void
		{
			TweenMax.to(cover,.3,{autoAlpha:1,ease:Quadratic.easeOut});
			setTimeout(hide, 2000);
		}
		
		override public function hide():void
		{
			dispatchEvent(new Event("hiding"));
			if(cover)
			{
				cover.alpha = 0;
				cover.visible = false;
			}
			super.hide();
		}

		override protected function animationComplete():void
		{
			super.animationComplete();
			cover.visible = false;
			cover.alpha = 0;
			if(pcm.unlocked)
			{
				keypad.green.visible = true;
				keypad.red.visible = false;
			}
			//stage.focus = keypad;
		}	}}