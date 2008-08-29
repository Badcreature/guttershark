package net.guttershark.ui.views 
{
	
	/**
	 * The ControllerView Class defines a name convention for
	 * a view that is part of an M(VC) paradigm.
	 * 
	 * <p>The ControllerView is a composite class that can have
	 * it's own ControllerView, much like a parent/child relationship - 
	 * just like the display tree. Only this defines a concrete view controller.</p>
	 */
	public class ControllerView extends BasicView 
	{
		
		/**
		 * This ControllerViews' controller (parent/child controller view).
		 */
		public var controller:ControllerView;	}}