package main.tools
{
	import com.yahoo.astra.fl.managers.AlertManager;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class Image extends ComSprite
	{
		private var _id:int;
		private var _imgurl:String;
		private var _linkurl:String;
		private var _mouseoverimgurl:String;
		private var _newwindow:Boolean;
		
		private var load:Loader;
		private var imgbitmap:Bitmap;
		

		
		public function Image()
		{
			
		}
		
		public function loadImg(_url:String):void
		{
			load = new Loader();
			load.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImageComplete);
			load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioerror_event_handler);
			load.load(new URLRequest(_url));
		}
		
		protected function ioerror_event_handler(event:IOErrorEvent):void
		{
			AlertManager.createAlert(this,"图片加载失败\n"+event.text,"错误提示");
		}
		
		private function loadImageComplete(evt:Event):void
		{
			load.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadImageComplete);
			if(imgbitmap)
				removeChild(imgbitmap);
			
			imgbitmap = load.content as Bitmap;
			addChild(imgbitmap);
		}
		
		public function get imgurl():String
		{
			return _imgurl;
		}

		public function set imgurl(value:String):void
		{
			_imgurl = value;
		}

		public function get linkurl():String
		{
			return _linkurl;
		}

		public function set linkurl(value:String):void
		{
			_linkurl = value;
		}
		
		public function get mouseoverimgurl():String
		{
			return _mouseoverimgurl;
		}
		
		public function set mouseoverimgurl(value:String):void
		{
			_mouseoverimgurl = value;
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