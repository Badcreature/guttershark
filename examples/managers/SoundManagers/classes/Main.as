package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import fl.controls.Slider;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.managers.SoundManager;		

	public class Main extends DocumentController 
	{
		public var playEffect:MovieClip;
		public var stopAllEffects:MovieClip;
		public var stopAllEnvironments:MovieClip;
		public var playEnvironment:MovieClip;
		public var stopAll:MovieClip;
		public var toggleVolume:MovieClip;
		public var slider:Slider;
		public var isSoundPlaying:MovieClip;
		private var snm2:SoundManager;

		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			utils.setters.buttonMode(true,playEffect,stopAllEffects,stopAllEnvironments,playEnvironment,stopAll,toggleVolume,isSoundPlaying);
			snm2=snm;
			snm2.addSound("sparkle",am.getSound("Sparkle"));
			snm2.addSound("martini",am.getSound("Martini"));
			em.he(playEffect,this,"onPlayEffect");
			em.he(stopAllEffects,this,"onStopAllEffects");
			em.he(playEnvironment,this,"onPlayEnvironment");
			em.he(stopAllEnvironments,this,"onStopAllEnvironments");
			em.he(stopAll,this,"onStopAll");
			em.he(toggleVolume,this,"onToggle");
			em.he(isSoundPlaying,this,"onIsSoundPlaying");
			snm2.volume=.1;
			slider.addEventListener(Event.CHANGE,onChange);
		}
		
		private function onChange(e:*):void
		{
			var nv:Number=slider.value/slider.maximum;
			//snm2.volume=nv;
			snm2.volumeTo(nv,3);
		}
		
		public function onIsSoundPlayingClick():void
		{
			trace(snm2.isSoundPlaying("sparkle"));
		}
		
		public function onToggleClick():void
		{
			snm2.toggleMute();
		}
		
		public function onPlayEffectClick():void
		{
			snm2.playEffectSound("sparkle");
		}
		
		public function onStopAllEffectsClick():void
		{
			snm2.stopAllEffectSounds();
		}
		
		public function onPlayEnvironmentClick():void
		{
			snm2.playEnvSound("martini");
		}
		
		public function onStopAllEnvironmentsClick():void
		{
			snm2.stopAllEnvSounds();
		}
		
		public function onStopAllClick():void
		{
			snm2.stopAllSounds();
		}	}}