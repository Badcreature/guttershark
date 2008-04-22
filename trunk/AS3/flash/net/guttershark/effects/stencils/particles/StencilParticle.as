package net.guttershark.effects.stencils.particles
{
	
	import flash.display.MovieClip;
	
	import net.guttershark.effects.stencils.pixel.Pixel;

	//import gs.TweenMax;
	
	/**
	 * The StencilParticle class is meant to be bound to a
	 * movie clip that you want to be a particle that is used
	 * in rendering a stencil
	 */
	public class StencilParticle extends MovieClip
	{

		/**
		 * The pixel that this particle currently represents.
		 */
		public var pixel:Pixel;
	}
}