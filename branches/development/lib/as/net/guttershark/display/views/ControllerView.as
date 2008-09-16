package net.guttershark.display.views 
{
	
	/**
	 * The ControllerView class defines a name convention for
	 * a view that is part of an M(VC) paradigm.
	 */
	public class ControllerView extends BasicView 
	{
		
		/**
		 * A controller for this view.
		 */
		public var controller:ControllerView;
		
		/**
		 * Constructor for ControllerView instances.
		 */
		public function ControllerView()
		{
			super();
		}	}}