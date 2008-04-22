package net.guttershark.effects.stencils.particles
{
	
	import flash.display.MovieClip;
	
	import net.guttershark.effects.stencils.pixel.Pixel;

	import gs.TweenMax;
	
	/**
	 * The StencilParticle class is meant to be bound to a
	 * movie clip that you want to be a particle that is used
	 * in rendering a stencil
	 */
	public class PopulistParticle extends MovieClip
	{

		/**
		 * The pixel that this particle currently represents.
		 */
		public var pixel:Pixel;
		
		/**
		 * A warpper for a vector piece. So that this can be
		 * tweened as well if needed.
		 */
		public var vector:MovieClip;
		
		private var jittering:Boolean = false;
		
		public function stopJitter():void
		{
			jittering = false;
			TweenMax.to(this.vector,1,{x:0,y:0});
		}

		public function startJitter(swayModifier:Number, swayDuration:Number):void
		{
			if(jittering) return;
			else
			{
				jittering = true;
				jitter(swayModifier,swayDuration);
			}
		}

		public function jitter(swayModifier:int, swayDuration:int):void
		{
			return;
			if(!jittering) return;
			var ji:Number = swayModifier / 2;
			var s:Number = Math.ceil(Math.random() * swayModifier - ji);
			var t:Number = Math.ceil(Math.random() * swayModifier - ji);
			TweenMax.to(this.vector,swayDuration,{x:s, y:t,onComplete:jitter,onCompleteParams:[swayModifier,swayDuration]});
		}
	}
}