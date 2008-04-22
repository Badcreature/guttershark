package net.guttershark.effects.stencils.effects
{
	import flash.display.DisplayObject;	
	
	public interface IRendererEffect 
	{
		
		/**
		 * Render method that is called internally from the StencilRenderer.
		 */
		function render(stencil:DisplayObject, particles:Array, leftOvers:Array):void;
		
		/**
		 * The render in method should be used to render particles that are coming in.
		 */
		function renderIn(particle:*):void;
		
		/**
		 * The render out method should be used to render particles that are going out.
		 */
		function renderOut(particle:*):void;
		
		function renderAllOut(particles:Array):void;
		
		function updateRender(particles:Array):void;
		
		/**
		 * The update option method is available so you can update options that effect
		 * rendering of particles.
		 */
		function updateOptions(object:Object):void;
	}
}