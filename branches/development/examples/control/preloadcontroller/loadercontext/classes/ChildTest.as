package
{
	import net.guttershark.display.CoreClip;
	
	public class ChildTest extends CoreClip
	{
		public function ChildTest()
		{
			super();
			addChild(am.getMovieClip("Child2"));
			trace(am.getSound("OdeTo"));
		}	}}