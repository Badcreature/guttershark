package net.guttershark.effects.stencils
{
	
	import flash.display.MovieClip;
	
	import net.guttershark.effects.stencils.Pixel;
	
	/**
	 * The StencilParticle must extend the movie clip you are
	 * using as a particle for an IRendererEffect.
	 */
	public class StencilParticle extends MovieClip
	{

		/**
		 * The pixel that this particle currently represents.
		 */
		public var pixel:Pixel;
	}
}