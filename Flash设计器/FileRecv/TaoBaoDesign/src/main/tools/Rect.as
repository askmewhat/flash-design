package main.tools
{
	public class Rect extends ComSprite
	{
		private var _bgcolor:uint=0x0085B2 ;
		private var _bordercolor:uint=0x000000;
		private var _borderstyle:Number=0;// 0:solid, 1:dotted, 2:dashed, 3:double
		private var _borderthickness:Number=1;
		private var _rectalpha:Number=1;
		
		// 点状线属性
		public var dottedlength:Number=2;
		public var dotteddistance:Number=5;
		
		// 虚线属性
		public var dashlength:Number=10;
		public var dashdistance:Number = 10;
		
		/*
		实线-solid(默认) 
			点状线-dotted 
			虚线-dashed 
			双线-double
		*/
		public function Rect()
		{
			super();
		}

		public function get bgcolor():uint
		{
			return _bgcolor;
		}

		public function set bgcolor(value:uint):void
		{
			_bgcolor = value;
		}

		public function get bordercolor():uint
		{
			return _bordercolor;
		}

		public function set bordercolor(value:uint):void
		{
			_bordercolor = value;
		}

		public function get borderstyle():Number
		{
			return _borderstyle;
		}

		public function set borderstyle(value:Number):void
		{
			_borderstyle = value;
		}

		public function get borderthickness():Number
		{
			return _borderthickness;
		}

		public function set borderthickness(value:Number):void
		{
			_borderthickness = value;
		}

		public function get rectalpha():Number
		{
			return _rectalpha;
		}

		public function set rectalpha(value:Number):void
		{
			_rectalpha = value;
		}


	}
}