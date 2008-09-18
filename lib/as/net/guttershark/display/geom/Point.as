package net.guttershark.display.geom{	import net.guttershark.util.MathUtils;			/**	 * The Point class plots x and y coordinates in a 2D grid.	 */	public class Point	{				/**		 * The x coordinate.		 */		public var x:Number;				/**		 * The y coordinate.		 */		public var y:Number;				/**		 * MathUtils		 */		protected var mu:MathUtils;		/**		 * Constructor for Point instances.		 * 		 * @param x The x coordinate.		 * @param y The y coordinate.		 */		public function Point(x:Number=0,y:Number=0) 		{			super();			this.x = x;			this.y = y;			mu = MathUtils.gi();		}		/**		 * Check if two Points are equal.		 * 		 * @param p The Point to test equality against.		 */		public function isEqual(p:Point):Boolean 		{			return (p.x==x&&p.y==y);		}		/**		 * Get the distance between two points.		 * 		 * @param p The Point whose distance will be calculated.		 */		public function getDistance(p:Point):Number 		{			return mu.getDistance(this,p);		}		/**		 * Algo to give the grid based distance when only vertical & horizontal moves are allowed.		 * 		 * @param p The target Point		 */		public function getAbsoluteGridDistance(p:Point):Number 		{			return Math.abs(x - p.x) + Math.abs(y - p.y);		}		/**		 * Algo to give the grid based distance when diagonal moves are allowed		 * by finding math.min of the differences, we're figuring out how many moves can be diagonal ones.		 * Then we can just substract that number from the normal .getAbsoluteGridDistance() method since diagonals take		 * 1 move instead of the usual 2		 * 		 * @param p The target Point.		 */		public function getAbsoluteGridDistanceAllowDiagonals(p:Point):Number 		{			var offset:Number = Math.min(Math.abs(x - p.x),Math.abs(y - p.y));			return getAbsoluteGridDistance(p) - offset;		}		/**		 * Get the angle degree between this point and a second point.		 * 		 * @param p The target Point.		 */		public function getAngle(p:Point):Number 		{			return Math.atan((this.y-p.y)/(this.x-p.x))/(Math.PI / 180);		}		/**		 * Returns a new point based on this point with x and y offset values.		 * 		 * @param x The x coordinate offset.		 * @param y The y coordinate offset.		 */		public function displace(x:Number, y:Number):Point 		{			return new Point(this.x+x,this.y+y);		}		/**		 * Offset this Point object by a specified amount.		 * 		 * @param x Horizontal offset		 * @param y Vertical offset		 */		public function offset(x:Number, y:Number):void 		{			this.x += x;			this.y += y;		}		/**		 * Rotate this Point around another Point by the specified angle.		 * 		 * @param p The target Point.		 * @param angle The angle to rotate around the target Point.		 */		public function rotate(p:Point,angle:Number):void		{			var radians:Number = mu.angle2radian(angle);			var baseX:Number = this.x - p.x;			var baseY:Number = this.y - p.y;			this.x = (Math.cos(radians) * baseX) - (Math.sin(radians) * baseY) + p.x;			this.y = (Math.sin(radians) * baseX) + (Math.cos(radians) * baseY) + p.y;			}			/**		 * Clone this Point.		 */		public function clone():Point		{			return new Point(this.x,this.y);		}				}}