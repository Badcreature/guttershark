package net.guttershark.util 
{
	
	
	/**
	 * 
	 */
	public class LoopRange
	{
		
		public var min:Number;
	    public var max:Number;
	    private var _current:Number;
		
	    function LoopRange(min:Number, max:Number, start:Number)
	    {
	        this.min = min;
	        this.max = max;
	        _current = start || min;
	    }
	   
	    public function next():Number
	    {
	        _current = _current+1 <= max? _current+1 : min;
	        return _current;   
	    }
		
		public function previous():Number
	    {
	        _current = _current-1>= min? _current-1 : max;
	        return _current;   
	    }
		
		public function set current(value:Number):void
	    {
	        if( value>= min && value <= max ) _current = value;
	        else throw new Error( 'number ' + value + ' is out of range [ ' + min + ', ' + max + ' ]' );
	    }
		
	    public function get current():Number
	    {
	        return _current;   
	    }	}}