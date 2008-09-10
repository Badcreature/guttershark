package publishtools
{
	import core.BaseToolMain;
	import core.TabBar;
	
	import net.guttershark.display.controls.buttons.MovieClipButton;
	import net.guttershark.util.MovieClipUtils;
	
	import publishtools.excludeclasses.ExcludeClassesView;	

	public class PublishToolsMain extends BaseToolMain
	{
		
		public var excludeClasses:MovieClipButton;
		public var excludeClassesView:ExcludeClassesView;

		public function PublishToolsMain()
		{
			super();
			excludeClassesView.visible = false;
			var tabs:Array = [
				{button:excludeClasses,view:excludeClassesView}
			];
			tabBar = new TabBar(tabs);
			MovieClipUtils.SetMouseChildren(false,excludeClasses);
			MovieClipUtils.SetButtonMode(true,excludeClasses);
		}
		
		override public function changeFLA():void
		{
			excludeClassesView.changeFLA();
		}	}}