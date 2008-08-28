package net.guttershark.util 
{
	
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	import net.guttershark.core.IDisposable;	
	
	/**
	 * The BitField class is a wrapper class that manages
	 * using an unsigned integer as a bit field. This concept
	 * is taken from C if you want to read more on the subject,
	 * look up the Programming in C book - Chapter 11 specifically.
	 * 
	 * <p>Essentially this class allows you to store data
	 * in any part of an unsigned integer. This class manages
	 * the reading and writing from the unsigned int.</p>
	 * 
	 * <p>As an example, say you have two flag variables you want to
	 * track, <code>hasPanelBeenRendered</code> and <code>hasXMLLoaded</code>.
	 * Using a bitfield uses 1 unsigned integer internally, to store those
	 * two flags. So say you have this byte. 00000011. The least significant (right-most)
	 * 1 represents hasPanelBeenRendered, and the 1 in the 2's spot represents
	 * the hasXMLLoaded flag. So you can setup a bitfield to read and write those
	 * properties like so:</p>
	 * 
	 * <listing>	
	 * var bf:BitField = new BitField();
	 * bf.addField("hasPanelBeenRendered",1,0); //1 bit, from 0 offset (right side).
	 * bf.addField("hasXMLLoaded",1,1); //1 bit, next bit in sequence (in the 2's spot);
	 * //read and write these props.
	 * bf.hasPanelBeenRendered = 1;
	 * bf.hasXMLLoaded = 1;
	 * </listing>
	 * 
	 * <p>So this example is only using 1 unsigned integer internally to the bitfield,
	 * which will save on memory. It's pretty nit picky, but every "bit" helps.</p>
	 */
	dynamic public class BitField extends Proxy implements IDisposable
	{

		/**
		 * The unsigned int that has all the fields in it.
		 */
		private var field:uint;
		
		/**
		 * A dicationary of field objects with keys that denote
		 * the label, bitCount, and bitLength.
		 */
		private var fields:Dictionary;

		/**
		 * Constructor for BitField instances.
		 * 
		 * @param	initialFieldValue	An initial value of the entire field.
		 * 
		 * @see	#addField()
		 */
		public function BitField(initialFieldValue:uint = 0):void
		{
			field = initialFieldValue;
			fields = new Dictionary(false);
		}

		/**
		 * Add a field.
		 * 
		 * @param	label	The property name you want to use to read and write to the field.
		 * @param	bitCount	The number of bits to use in the internal unsigned integer.
		 * @param	bitOffset	The number of bits from the right. This is an offset for each piece of information
		 * you want in different bytes of the unsigned integer.
		 * 
		 * @example Creating and adding a field.
		 * <listing>	
		 * import net.guttershark.util.BitField;
		 * var bf = new BitField();
		 * bf.addField("isOpen",4,0);
		 * bf.addField("isTest",4,4);
		 * bf.addField("anotherState",1,8);
		 * bf.isOpen = -16;
		 * bf.isTest = 15;
		 * bf.anotherState = 1;
		 * trace(bf.isOpen);
		 * trace(bf.isTest);
		 * trace(bf.anotherState);
		 * </listing>
		 */
		public function addField(label:String, bitCount:int, bitOffset:int):void
		{
			fields[label] = {bitCount:bitCount,bitOffset:bitOffset};
		}
		
		private function getMaxValueFromBitCount(count:int):uint
		{
			return Math.pow(2,count) - 1;
		}
				
		/**
		 * @private
		 */
		flash_proxy override function setProperty(name:*,value:*):void
		{
			if(!fields[name]) throw new Error("Property " + name + " not found in BitField");
			var f:Object = fields[name];
			f.neg = false;
			var max:int = getMaxValueFromBitCount(f.bitCount);
			if(value < 0)
			{
				//if(f.bitCount == 1) throw new AccessError("Field operation out of range, the minumum value that can be represented by this field is 0");
				f.neg = true;
				var t:int = -(max) - 1;
				if(value < t) throw new Error("Field operation out of range, the minumum value that can be represented by this field is " + t.toString());
				value = ~(value+1);
			}
			if(value > max) throw new Error("Field operation out of range, the maximum value that can be represented by this field is " + max.toString());
			if(f.bitOffset > 0) field = (field & ~(max << f.bitOffset)) | ((value & max) << f.bitOffset);
			else field = (field & ~(max)) | ((value & max));
		}
		
		/**
		 * @private
		 * 
		 * getProperty - override getters to return null always
		 */
		flash_proxy override function getProperty(name:*):*
		{
			if(!fields[name]) throw new Error("Property " + name + " does not exist on this BitField");
			var f:Object = fields[name];
			var max:int = getMaxValueFromBitCount(f.bitCount);
			var v:int = ((field >> f.bitOffset) & max);
			if(f.neg) v = (~(v)-1);
			return v;
		}
		
		/**
		 * Dispose of all internally used variables for managing the bit field.
		 */
		public function dispose():void
		{
			field = 0;
			fields = new Dictionary(false);
		}
	}
}
