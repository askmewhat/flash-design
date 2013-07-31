package main.tools
{
	import flash.display.Sprite;
	
	public class HotArea extends ComSprite
	{
		
		private var _w:Number;
		private var _h:Number;
		private var _linkurl:String;
		private var _newwindow:Boolean;
		
		public var thickness:Number = 1;
		
		private var _backgroundColor:uint = 0xD96D00;
		private var _borderColor:uint = 0;
		
		public function HotArea()
		{
			super();
		}

		public function get w():Number
		{
			return _w;
		}

		public function set w(value:Number):void
		{
			_w = value;
		}

		public function get h():Number
		{
			return _h;
		}

		public function set h(value:Number):void
		{
			_h = value;
		}

		public function get linkurl():String
		{
			return _linkurl;
		}

		public function set linkurl(value:String):void
		{
			_linkurl = value;
		}

		public function get newwindow():Boolean
		{
			return _newwindow;
		}

		public function set newwindow(value:Boolean):void
		{
			_newwindow = value;
		}

		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}

		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
		}

		public function get borderColor():uint
		{
			return _borderColor;
		}

		public function set borderColor(value:uint):void
		{
			_borderColor = value;
		}


	}
}