package net.guttershark.util 
{
	public class TokenReplacer
	{
		
		private static var inst:TokenReplacer;
		
		public static function gi():TokenReplacer
		{
			if(!inst)inst=Singleton.gi(TokenReplacer);
			return inst;
		}
		
		public function replace(target:String,tokens:Array,replacements:Array):void
		{
		}	}}