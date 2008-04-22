package net.guttershark.effects.stencils.effects
{
	
	import flash.display.MovieClip;
	
	import net.guttershark.effects.stencils.effects.IRendererEffect;
	
	//import gs.TweenMax;

	/**
	 * The Stub class is a basic example of how you want to take
	 * particles that should be rendered in, and particles that 
	 * should be rendered out.
	 */
	public class Stub implements IRendererEffect
	{
		
		/**
		 * Render sandbox, this is where particles get rendered in.
		 */
		private var renderSandbox:MovieClip;
		
		/**
		 * The stencil being rendered.
		 */
		private var stencil:DisplayObject;
		
		/**
		 * Creates this Stub. Do not use directy, this is just
		 * and example. Read through this code and implement your
		 * own render logic
		 */
		public function Stub(renderSandbox:MovieClip):void
		{
			this.renderSandbox = renderSandbox;
		}
		
		/**
		 * Update any options you want to alter the particles
		 */
		public function updateOptions(options:Object):void{}
		
		/**
		 * Render the partices.
		 * 
		 * @param		MovieClip		The stencil being rendered
		 * @param		Array			The particles that should be rendered in
		 * @param		Array			The particles that should be rendered out
		 */
		public function render(stencil:DisplayObject, particles:Array, leftOvers:Array):void
		{
			this.stencil = stencil;
			var pl:int = particles.length;
			var lol:int = leftOvers.length;
			var i:int;
			var fireOtherRatio:int;
			var fireOtherCounter:int = 0;
			//figure out which array has more items, so we can loop over that one, and
			//intermitantly fire renderIn or renderOut so that it all
			//mixes together			
			if(pl >= lol)
			{
				fireOtherRatio = Math.floor(pl / lol);
				for(i = 0; i < pl; i++)
				{
					if(fireOtherCounter == fireOtherRatio)
					{
						renderOut(leftOvers.shift());
						fireOtherCounter = 0;
					}
					fireOtherCounter++;
					renderIn(particles[i]);
				}
			}
			else
			{
				fireOtherRatio = Math.ceil(lol / pl);
				for(i = 0; i < lol; i++)
				{
					if(fireOtherCounter == fireOtherRatio)
						renderIn(particles[fireOtherCounter]);
					fireOtherCounter++;
					renderOut(leftOvers[i]);
				}
			}
		}
		
		public function renderIn(pt:*):void{}
		public function renderOut(pt:*):void{}
	}
}
