package  
{
	
	import flash.display.MovieClip;
	
	import net.guttershark.guttershark_internal;
	import net.guttershark.GuttersharkMeta;
	import net.guttershark.effects.stencils.StencilRenderer;
	import net.guttershark.akamai.AkamaiNCManager;

	/**
	 * This class is strictly for showing how to use the guttershark_internal
	 * namespace. Read more about namespaces in Essential AS 3 book
	 */
	
	public class Main extends MovieClip
	{	
		
		guttershark_internal var p1:String;
		
		public function Main()
		{
			guttershark_internal::wordup();
		}
		
		guttershark_internal function wordup():void
		{
			trace(StencilRenderer.guttershark_internal::version);
			trace(GuttersharkMeta.guttershark_internal::version);
			trace(AkamaiNCManager.guttershark_internal::version);
			guttershark_internal::p1 = "word";
			trace(this.guttershark_internal::p1);
			use namespace guttershark_internal;
			p1 = "wordFFFFF";
			trace(p1);
			trace(guttershark_internal::p1);
		}
	}
}
