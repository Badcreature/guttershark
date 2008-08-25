package net.guttershark.control 
{	import flash.utils.Dictionary;
	
	import net.guttershark.core.Singleton;

	/**
	 * The DocumentControllers Class is used as a lookup for
	 * applications that may have more than one FLA, that extend
	 * DocumentController.
	 * 
	 * <p>In each FLA's DocumentController, you would override
	 * registerController(), and register your controller with
	 * this class. You could then get a reference to an 
	 * application controller for any SWF that was registered.</p>
	 */
	public class DocumentControllers
	{
		
		private static var inst:DocumentControllers;
		private var controllers:Dictionary;

		public static function gi():DocumentControllers
		{
			if(!inst) inst = Singleton.gi(DocumentControllers);
			return inst;
		}
		
		public function DocumentControllers():void
		{
			Singleton.assertSingle(DocumentControllers);
			controllers = new Dictionary();
		}
		
		public function registerController(id:String,dc:DocumentController):void
		{
			controllers[id] = dc;
		}
		
		public function getController(dcID:String):DocumentController
		{
			if(!controllers[dcID]) throw new Error("DocumentController {"+dcID+"} not found.");
			return controllers[dcID];
		}
	}}