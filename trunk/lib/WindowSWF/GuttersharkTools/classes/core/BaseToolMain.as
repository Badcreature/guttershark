package core
{
	import model.GSToolsModel;
	
	import net.guttershark.display.views.BasicView;		

	public class BaseToolMain extends BasicView
	{

		public var gm:GSToolsModel;
		public var jp:JSFLProxy;
		public var tabBar:TabBar;
		public var id:String;
		public var controller:*;
		public var saved:Boolean;
		
		public function BaseToolMain()
		{
			super();
			gm = GSToolsModel.gi();
			jp = JSFLProxy.gi();
		}
		
		/**
		 * Called anytime a new FLA has been selected in the IDE.
		 */
		public function changeFLA():void{}
		
		/**
		 * Called on each BaseToolMain anytime a different
		 * top level tool is selected.
		 */
		public function save():void{}	}}