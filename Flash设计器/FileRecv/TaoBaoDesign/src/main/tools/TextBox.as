package main.tools
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 文本旋转
	 */
	public class TextBox extends ComSprite
	{ 
		private var _r_btn:Sprite;
		private var _p_txt:TextField;
		private var _tf:TextFormat;
		private var _text:String = "自行修改该文本内容";
		private var _bold:int;
		private var _italic:int;
		private var _isOpen:int = 1;
		private var _link:String = "";
		private var _color:String = "000";
		
		private var _textcontent:String;
		private var _textlink:String;
		private var _fontname:String;
		private var _textbold:Boolean;
		private var _fontcolor:String;
		private var _textitalic:Boolean;
		private var _fontsize:String;
		private var _underline:Boolean;
		private var _newwindow:Boolean;
		
		
		
		public function TextBox(str:String, size:int = 12, color:uint = 0):void 
		{ 
			p_txt = addChild (new TextField) as TextField;
			tf = new TextFormat();
			tf.font = "宋体";
			tf.size = size;
			tf.color = color;
			p_txt.defaultTextFormat=tf;
			p_txt.autoSize = "left";
			p_txt.text = str;
			p_txt.selectable = false;
			p_txt.mouseEnabled = false;
			p_txt.borderColor = 0x333399;
			r_btn = addChild (new Sprite) as Sprite;
			r_btn.graphics.beginFill (0x333399,.6);
			r_btn.graphics.drawCircle (0, 0, 5);
			r_btn.x = p_txt.width * .5;
			r_btn.y = -p_txt.height * .5;
			r_btn.visible = false;
			r_btn.buttonMode = true;
			addEventListener (MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		public function setText(value:String):void
		{
			text = value;
			p_txt.text = value;
			p_txt.setTextFormat(tf);
		}
		
		public function setFontSize(value:int):void
		{
			tf.size = value;
			p_txt.setTextFormat(tf);
		}
		
		public function setLink(value:String):void
		{
			_link = value;
//			p_txt.htmlText = "<font color='#ff9933'><a  href='event:"+ value +"'>"+text+"</a>"
			trace(p_txt.htmlText);
		}
		
		public function setFont(value:String):void
		{
			tf.font = value;
			p_txt.setTextFormat(tf);
		}
		
		public function setColor(value:uint, value1:String):void
		{
			_color = value1;
			tf.color = value;
			p_txt.setTextFormat(tf);
		}
		
		public function setBold(value:int):void
		{
			if(value == 0)
			{
				value = 1;
				tf.bold = true;
			}else
			{
				value = 0;
				tf.bold = false;
			}
			bold = value;
			p_txt.setTextFormat(tf);
		}
		
		public function setItalic(value:int):void
		{
			if(value == 0)	
			{
				value = 1;
				tf.italic = true;
			}else
			{
				value = 0;
				tf.italic = false;
			}
			italic = value;
			p_txt.setTextFormat(tf);
		}
		
		
		public function setOpen(value:int):void
		{
			if(value == 0)
			{
				value = 1;
			}else
			{
				value = 0;
			}
			isOpen = value;
		}
		
		private function mouseDown(_evt:MouseEvent):void 
		{ 
			if (_evt.target != r_btn) 
			{ 
				startDrag (); 
			}else
			{ 
				addEventListener (Event.ENTER_FRAME, startRing); 
			} 
			stage.addEventListener (MouseEvent.MOUSE_UP, mouseUp); 
		} 
		
		private function startRing(_evt:Event):void 
		{ 
			rotationZ = Math.atan2 (parent.mouseY - y, parent.mouseX - x) / Math.PI * 180; 
		} 
		
		private function mouseUp(_evt:MouseEvent ):void 
		{ 
			stopDrag(); 
			removeEventListener (Event.ENTER_FRAME, startRing ); 
			stage.removeEventListener (MouseEvent.MOUSE_UP, mouseUp); 
		} 
		
		public function set focus(_b:Boolean):void 
		{ 
//			r_btn.visible = _b; 
			p_txt.border = _b; 
		} 

		public function get r_btn():Sprite
		{
			return _r_btn;
		}

		public function set r_btn(value:Sprite):void
		{
			_r_btn = value;
		}

		public function get tf():TextFormat
		{
			return _tf;
		}

		public function set tf(value:TextFormat):void
		{
			_tf = value;
		}

		public function get bold():int
		{
			return _bold;
		}

		public function set bold(value:int):void
		{
			_bold = value;
		}

		public function get italic():int
		{
			return _italic;
		}

		public function set italic(value:int):void
		{
			_italic = value;
		}

		public function get isOpen():int
		{
			return _isOpen;
		}

		public function set isOpen(value:int):void
		{
			_isOpen = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}

		public function get link():String
		{
			return _link;
		}

		public function set link(value:String):void
		{
			_link = value;
		}

		public function get color():String
		{
			return _color;
		}

		public function set color(value:String):void
		{
			_color = value;
		}

		public function get p_txt():TextField
		{
			return _p_txt;
		}

		public function set p_txt(value:TextField):void
		{
			_p_txt = value;
		}

		public function get textcontent():String
		{
			return _textcontent;
		}

		public function set textcontent(value:String):void
		{
			_textcontent = value;
		}

		public function get textlink():String
		{
			return _textlink;
		}

		public function set textlink(value:String):void
		{
			_textlink = value;
		}

		public function get fontname():String
		{
			return _fontname;
		}

		public function set fontname(value:String):void
		{
			_fontname = value;
		}

		public function get textbold():Boolean
		{
			return _textbold;
		}

		public function set textbold(value:Boolean):void
		{
			_textbold = value;
		}

		public function get fontcolor():String
		{
			return _fontcolor;
		}

		public function set fontcolor(value:String):void
		{
			_fontcolor = value;
		}

		public function get textitalic():Boolean
		{
			return _textitalic;
		}

		public function set textitalic(value:Boolean):void
		{
			_textitalic = value;
		}

		public function get fontsize():String
		{
			return _fontsize;
		}

		public function set fontsize(value:String):void
		{
			_fontsize = value;
		}

		public function get underline():Boolean
		{
			return _underline;
		}

		public function set underline(value:Boolean):void
		{
			_underline = value;
		}

		public function get newwindow():Boolean
		{
			return _newwindow;
		}

		public function set newwindow(value:Boolean):void
		{
			_newwindow = value;
		}


	}
}