package main
{
	import ViewLib.transform.TransformTool;
	
	import com.yahoo.astra.fl.managers.AlertManager;
	
	import fl.controls.CheckBox;
	import fl.controls.ColorPicker;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import fl.events.ColorPickerEvent;
	import fl.events.ComponentEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import main.tools.HotArea;
	import main.tools.TextBox;
	import main.util.DesignConst;
	
	public class Main extends Sprite
	{
		[Embed(source="/assets/main.swf", mimeType="application/octet-stream")]
		private const Cmain:Class;
		
		private var load:Loader;
		private var mc:MovieClip;
		
		private var spBack:Sprite;
		private var spContent:Sprite;
		
		private var tf:TransformTool;
		
		private var choseTools:int = 0;
		
		private const TOOLS_RQ:String = "rq";
		private const TOOLS_Font:String = "wb";
		private const TOOLS_IMAGE:String = "tp";
		
		private var arrHX1:Array = [];
		private var arrHX2:Array = [];
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
		}
		
		private function init(evt:Event):void
		{
			load = new Loader();
			load.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
//			load.load(new URLRequest("assets/main.swf"));
			var swf:ByteArray = new Cmain() as ByteArray;
			var lc:LoaderContext = new LoaderContext();
			load.loadBytes(swf, lc);
		}
		
		private function loadCompleteHandler(evt:Event):void
		{
			load.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			mc = load.content as MovieClip;
			addChild(mc);
			mc.step3.gotoAndStop(1);
			mc.step3.isGou.gotoAndStop(1);
			mc.outData.visible = false;
			
			spBack = new Sprite();
			spBack.graphics.beginFill(0,0);
			spBack.graphics.drawRect(0,0,mc.mcDrawBack.width, mc.mcDrawBack.height);
			spBack.graphics.endFill();
			mc.mcDrawBack.addChild(spBack);
			spBack.mouseEnabled = false;
			
			spContent = new Sprite();
			spContent.graphics.beginFill(0,0);
			spContent.graphics.drawRect(0,0,mc.mcDrawBack.width, mc.mcDrawBack.height);
			spContent.graphics.endFill();
			mc.mcDrawBack.addChild(spContent);
			spContent.mouseEnabled = false;
			
			tf = new TransformTool();
			addChild(tf);
			tf.raiseNewTargets = false;
			tf.moveNewTargets = true;
			tf.moveUnderObjects = false;
			tf.registrationEnabled = false;
			tf.rememberRegistration = false;
			tf.rotationEnabled = false;
			tf.skewEnabled = false;
			
			arrHX1.push("11111111111111111111111");
			arrHX1.push("2222222222222");
			arrHX1.push("333333333333333333333333");
			arrHX1.push("4444444444444444");
			arrHX1.push("555555555555555555555555");
			
			arrHX2.push("aaaaaaaaaaaa");
			arrHX2.push("bbbbbbbbbbbbbbbbbbbbb");
			arrHX2.push("cccccccccccccc");
			arrHX2.push("dddddddddddddddddddddddd");
			arrHX2.push("eeeeeeeeeeeeeeee");
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			addEventListener(MouseEvent.MOUSE_UP, upHandler);
			mc.btn_ok.addEventListener(MouseEvent.CLICK, ok_click_handler);
			mc.btnOut.addEventListener(MouseEvent.CLICK, exportData);
			mc.btn_delete.addEventListener(MouseEvent.CLICK, deleteOperateObject);
		}
		
		private function deleteOperateObject(e:MouseEvent):void
		{
			if(nowOperateTargetObject is HotArea){
				
				delete hotareaDictionary[(nowOperateTargetObject as HotArea).id];
				
			} else if (nowOperateTargetObject is TextBox){
				delete textDictionary[(nowOperateTargetObject as TextBox).id];
			}
			tf.target = null;
			spContent.removeChild(nowOperateTargetObject);
			nowOperateTargetObject = null;
		}
		
		protected function upHandler(evt:MouseEvent):void
		{
			if(tf.target is HotArea){
				var hotarea:HotArea = tf.target as HotArea;
				
				var _scaleX:Number = hotarea.scaleX;
				var _scaleY:Number = hotarea.scaleY;
				
				var _w:Number = hotarea.width;
				var _h:Number = hotarea.height;
				var _x:Number = hotarea.x;
				var _y:Number = hotarea.y;
				
				hotarea.scaleX = 1;
				hotarea.scaleY = 1;
				hotarea.width = _w;
				hotarea.height = _h;
				hotarea.graphics.clear();
				hotarea.graphics.lineStyle(hotarea.thickness, hotarea.borderColor);
				hotarea.graphics.beginFill(hotarea.backgroundColor);
				hotarea.graphics.drawRect(0, 0, _w - hotarea.thickness, _h - hotarea.thickness);
				hotarea.graphics.endFill();
				hotarea.scaleX = 1;
				hotarea.scaleY = 1;
				
				tf.target = hotarea;
				
			}
		}
		
		private var bgloader:Loader;
		
		private function ok_click_handler(e:MouseEvent):void
		{
			if(mc.txt_bgurl.text !=""){
				
				bgloader = new Loader();
				bgloader.contentLoaderInfo.addEventListener(Event.COMPLETE, compelete_load_handler);
				bgloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, error_load_handler);
				bgloader.load(new URLRequest(mc.txt_bgurl.text));
			}
			else
			{
				AlertManager.createAlert(this, "\n请输入图片地址\n",DesignConst.ALERT_ERROR_TITLE);
			}
			
			
		}
		
		protected function error_load_handler(event:IOErrorEvent):void
		{
			AlertManager.createAlert(this, "\n图片加载失败\n",DesignConst.ALERT_ERROR_TITLE);
		}
		
		private var bgImage:DisplayObject;
		
		protected function compelete_load_handler(event:Event):void
		{
			if(bgImage)
				(mc.mcDrawBack as MovieClip).removeChild(bgImage);
			
			var bitmap:Bitmap = Bitmap(bgloader.content);
			var background:DisplayObject = bitmap;
			bgImage = background;
			(mc.mcDrawBack as MovieClip).addChildAt(background, 0);
			
		}
		
		private var addID:int;
		private function downHandler(evt:MouseEvent):void
		{
			
			if (evt.target is HotArea)
			{
				nowOperateTargetObject = evt.target;
				changeTransformProperty(evt.target as HotArea, tf.boundsTopLeft);
				updatePropertiesForm();
				
			}
			else if (evt.target is TextBox)
			{
				tf.target = null;
				
				nowOperateTargetObject = evt.target;
				
				updatePropertiesForm();
			}
			else if(evt.target is Image)
			{
//				tf.target = null;
				tf.target = evt.target as Image;
				tf.registration = tf.boundsTopLeft;
			}
		}
		
		private function changeTransformProperty(target:DisplayObject, registration:Point):void
		{
			tf.target = target;
			tf.registration = registration;
			
			
		}
		
		var rq:RQ;
		var font:TextBox;
		var img:Image;
		var arr:Array = [];
		private function saveRQ(id:int):void
		{
			for(var i:int = 0;i<arr.length;i++)
			{
				if(arr[i][0] == id)
				{
					arr[i][0] = rq.id;
					arr[i][1] = TOOLS_RQ;
					arr[i][2] = rq.x;
					arr[i][3] = rq.y;
					arr[i][4] = rq.width;
					arr[i][5] = rq.height;
					arr[i][6] = rq.link;
					arr[i][7] = rq.isGouxuan;
					return;
				}
			}
			var obj:Array = [];
			obj[0] = rq.id;
			obj[1] = TOOLS_RQ;
			obj[2] = rq.x;
			obj[3] = rq.y;
			obj[4] = rq.width;
			obj[5] = rq.height;
			obj[6] = rq.link;
			obj[7] = rq.isGouxuan;
			arr.push(obj);
		}
		
		private function saveFont(name:String):void
		{
			for(var i:int = 0;i<arr.length;i++)
			{
				if(arr[i][0] == int(name))
				{
					arr[i][0] = int(font.name);
					arr[i][1] = TOOLS_Font;
					arr[i][2] = font.x;
					arr[i][3] = font.y;
					arr[i][4] = font.width;
					arr[i][5] = font.height;
					arr[i][6] = font.text;
					arr[i][7] = font.link;
					arr[i][8] = font.tf.font;
					arr[i][9] = "#"+font.color;
					arr[i][10] = font.tf.size;
					arr[i][11] = font.bold;
					arr[i][12] = font.italic;
//					arr[i][13] = font.underLine;
					arr[i][14] = font.isOpen;
					return;
				}
			}
			var obj:Array = [];
			obj[0] = int(font.name);
			obj[1] = TOOLS_Font;
			obj[2] = font.x;
			obj[3] = font.y;
			obj[4] = font.width;
			obj[5] = font.height;
			obj[6] = font.text;
			obj[7] = font.link;
			obj[8] = font.tf.font;
			obj[9] = "#"+font.color;
			obj[10] = font.tf.size;
			obj[11] = font.bold;
			obj[12] = font.italic;
//			obj[13] = font.underLine;
			obj[14] = font.isOpen;
			arr.push(obj);
		}
		
		private function saveImg(id:int):void
		{
			for(var i:int = 0;i<arr.length;i++)
			{
				if(arr[i][0] == id)
				{
					arr[i][0] = img.id;
					arr[i][1] = TOOLS_IMAGE;
					arr[i][2] = img.url;
					arr[i][3] = img.x;
					arr[i][4] = img.y;
					arr[i][5] = img.width;
					arr[i][6] = img.height;
					arr[i][7] = img.link;
					arr[i][8] = img.isOpen;
					arr[i][9] = img.tanchuType;
					arr[i][10] = img.tanchuPos;
					return;
				}
			}
			var obj:Array = [];
			obj[0] = img.id;
			obj[1] = TOOLS_IMAGE;
			obj[2] = img.url;
			obj[3] = img.x;
			obj[4] = img.y;
			obj[5] = img.width;
			obj[6] = img.height;
			obj[7] = img.link;
			obj[8] = img.isOpen;
			obj[9] = img.tanchuType;
			obj[10] = img.tanchuPos;
			arr.push(obj);
		}
		
		var choseSprite:content;
		var cb:ComboBox;
		var cp:ColorPicker;
		var isB:CheckBox;
		var isI:CheckBox;
		var isU:CheckBox;
		var isOpenNewWindow:CheckBox;
		var arrFont:Array;
		var choseFont:TextBox;
		var tanchuType:ComboBox;
		var arrTanchuType:Array = [];
		var tanchuPos:ComboBox;
		var arrTanchuPos:Array = [];
		private function clickHandler(evt:MouseEvent):void
		{
			var clickToolsName:String = evt.target.name;
			switch(clickToolsName)
			{
				case "TOOLS_HOTAREA":
					addToolHotarea();
					break;
				case "TOOLS_TEXT":
					addToolText();
					break;
				case "TOOLS_IMAGE":
					addToolImage();
					break;
				case "TOOLS_RECT":
					addToolRect();
					break;
				case "TOOLS_COUNTDOWN":
					addToolCountdown();
					break;
				case "TOOLS_MAGAZINE":
					addToolMagazine();
					break;
				case "TOOLS_SEARCH":
					addToolSearch();
					break;
				case "TOOLS_DCODE":
					addToolDcode();
					break;
				case "TOOLS_SUPPORT":
					addToolSupport();
					break;
				case "TOOLS_CHART":
					addToolChart();
					break;
				case "TOOLS_COLLECTION":
					addToolCollection();
					break;
				case "TOOLS_SHARE":
					addToolShare();
					break;
				
				
				
			}
			
			
			
			
			
			
			
			return;
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			trace("clickHandler: ", evt.target, evt.target.name);
			var tmp:String = evt.target.name;
			if(tmp.substr(0, 8) == "btnTools")
			{
				choseTools = int(tmp.substr(8, tmp.length-1));
				trace("toolsId: ", choseTools);
				if(choseTools == 1)
				{
					cleraFontZJ();
					clearImageZJ();
					addID ++;
					rq = new RQ();
					rq.id = addID;
					rq.graphics.clear();
					rq.graphics.lineStyle(1,rq.frameColor);
					rq.graphics.beginFill(rq.backColor);
					rq.graphics.drawRect(0,0, 100, 100);
					rq.graphics.endFill();
					spContent.addChild(rq);
					mc.step3.gotoAndStop(1);
					mc.step3.isGou.gotoAndStop(1);
					mc.step3.linkText.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, saveRQtextLink);
					
					choseTools = 0;
				}
				if(choseTools == 2)
				{
					clearImageZJ();
					addID ++;
					font = new TextBox("自行修改该文本内容");
					font.name = addID.toString();
					spContent.addChild(font);
					mc.step3.gotoAndStop(2);
					mc.step3.textContent.text = "自行修改该文本内容";
					mc.step3.textSize.text = "12";
					mc.step3.textLink.text = "";
					mc.step3.textContent.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, saveTextContent);
					mc.step3.textLink.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, saveTextLink);
					mc.step3.textSize.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, saveTextSize);
					mc.step3.textSize.restrict = "0-9";
					if(!cb)
						cb = new ComboBox();
					arrFont = new Array("宋体","黑体","微软雅黑","隶书","幼圆","Georgia","Times New Roman","Impact","Courier New","Arial","Verdana","Tahoma");
					cb.dataProvider = new DataProvider(arrFont);
					mc.step3.addChild(cb);
					cb.x = 61;
					cb.y = 124;
					cb.addEventListener(Event.CHANGE, function setFont(evt:Event):void
					{
						trace(cb.selectedLabel);
						font.setFont(cb.selectedLabel);
						saveFont(font.name);
					});
					if(!cp)
						cp = new ColorPicker();
					mc.step3.addChild(cp);
					cp.x = 62;
					cp.y = 150;
					cp.addEventListener(ColorPickerEvent.CHANGE, function enter(evt:Event):void
					{
						trace(cp.hexValue);
						font.setColor(cp.selectedColor, cp.hexValue);
						saveFont(font.name);
					});
					if(!isB)
						isB = new CheckBox();
					isB.label = "";
					isB.x = 192;
					isB.y = 121;
					mc.step3.addChild(isB);
					isB.addEventListener(ComponentEvent.BUTTON_DOWN, function d(evt:ComponentEvent):void
					{
						trace(isB.selected);
						if(isB.selected)
						{
							font.setBold(1);
						}else
						{
							font.setBold(0);
						}
						saveFont(font.name);
					});
					if(!isI)
						isI = new CheckBox();
					isI.label = "";
					isI.x = 192;
					isI.y = 151;
					mc.step3.addChild(isI);
					isI.addEventListener(ComponentEvent.BUTTON_DOWN, function d(evt:ComponentEvent):void
					{
						trace(isI.selected);
						if(isI.selected)
						{
							font.setItalic(1);
						}else
						{
							font.setItalic(0);
						}
						saveFont(font.name);
					});
					if(!isU)
						isU = new CheckBox();
					isU.label = "";
					isU.x = 192;
					isU.y = 176;
					mc.step3.addChild(isU);
					isU.addEventListener(ComponentEvent.BUTTON_DOWN, function d(evt:ComponentEvent):void
					{
						trace(isU.selected);
						if(isU.selected)
						{
//							font.setUnderline(1);
						}else
						{
//							font.setUnderline(0);
						}
						saveFont(font.name);
					});
					if(!isOpenNewWindow)
						isOpenNewWindow = new CheckBox();
					isOpenNewWindow.label = "";
					isOpenNewWindow.x = 80;
					isOpenNewWindow.y = 228;
					mc.step3.addChild(isOpenNewWindow);
					isOpenNewWindow.selected = true;
					isOpenNewWindow.addEventListener(ComponentEvent.BUTTON_DOWN, function d(evt:ComponentEvent):void
					{
						trace(isOpenNewWindow.selected);
						if(isOpenNewWindow.selected)
						{
							font.setOpen(1);
						}else
						{
							font.setOpen(0);
						}
						saveFont(font.name);
					});
					
					choseTools = 0;
				}
				if(choseTools == 3)
				{
					cleraFontZJ();
					addID ++;
					
					img = new Image();
					img.graphics.beginFill(0);
					img.graphics.drawRect(0,0,100,100);
					img.graphics.endFill();
					
					img.id = addID;
					spContent.addChild(img); 
					
					mc.step3.gotoAndStop(3);
					mc.step3.txt_imgurl.text = "";
					mc.step3.txt_imgurl.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, changeImg);
					mc.step3.txt_linkurl.text = "";
					mc.step3.txt_linkurl.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, setImgLink);
					mc.step3.tanchuContent.text = "";
					mc.step3.tanchuContent.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, setTanchuContent);
					if(!isOpenNewWindow)
						isOpenNewWindow = new CheckBox();
					isOpenNewWindow.label = "";
					isOpenNewWindow.x = 78;
					isOpenNewWindow.y = 95;
					mc.step3.addChild(isOpenNewWindow);
					isOpenNewWindow.selected = true;
					isOpenNewWindow.addEventListener(ComponentEvent.BUTTON_DOWN, function d(evt:ComponentEvent):void
					{
						trace(isOpenNewWindow.selected);
						if(isOpenNewWindow.selected)
						{
							img.setOpen(1);
						}else
						{
							img.setOpen(0);
						}
						saveImg(img.id);
					});
					
					if(!tanchuType)
					{
						tanchuType = new ComboBox();
					}
					arrTanchuType = new Array("无弹出", "弹出自定义内容");
					tanchuType.dataProvider = new DataProvider(arrTanchuType);
					mc.step3.addChild(tanchuType);
					tanchuType.x = 82;
					tanchuType.y = 118;
					tanchuType.height = 20;
					tanchuType.addEventListener(Event.CHANGE, function setTanchuType(evt:Event):void
					{
						trace(tanchuType.selectedLabel);
						img.tanchuType = tanchuType.selectedLabel;
						saveImg(img.id);
					});
					
					if(!tanchuPos)
					{
						tanchuPos = new ComboBox();
					}
					arrTanchuPos = new Array("中心","左上角","右上角","左下角","右下角","上侧（右对齐）","上侧（居中对齐","上侧（左对齐）","下侧（右对齐）","下侧（居中对齐）","下侧（左对齐）","左侧（下对齐）","左侧（居中对齐）","左侧（上对齐）","右侧（下对齐）","右侧（居中对齐）","右侧（上对齐）");
					tanchuPos.dataProvider = new DataProvider(arrTanchuPos);
					mc.step3.addChild(tanchuPos);
					tanchuPos.x = 82;
					tanchuPos.y = 143;
					tanchuPos.height = 20;
					tanchuPos.addEventListener(Event.CHANGE, function setTanchuType(evt:Event):void
					{
						trace(tanchuPos.selectedLabel);
						img.tanchuPos = tanchuPos.selectedLabel;
						saveImg(img.id);
					});
					
					choseTools = 0;
				}
			}
			if(tmp == "mcDrawBack" || evt.target is SimpleButton || evt.target is TextBox)
			{
				tf.target = null;
				if(rq)
				{
					saveRQ(rq.id);
				}
				if(font)
				{
					saveFont(font.name);
				}
			}
			if(evt.target is RQ)
			{
				cleraFontZJ();
				clearImageZJ();
				
				trace(evt.target.x, evt.target.y, evt.target.width, evt.target.height);
				rq = evt.target as RQ;
			
				mc.step3.gotoAndStop(1);
				mc.step3.linkText.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, saveRQtextLink);
				if(mc.step3.linkText)
				{
					mc.step3.linkText.text = rq.link;
				}
				if(rq.isGouxuan == 1)
				{
					mc.step3.isGou.gotoAndStop(1);
				}else
				{
					mc.step3.isGou.gotoAndStop(2);
				}
			}
			if(evt.target is Image)
			{
				cleraFontZJ();
				img = evt.target as Image;
				mc.step3.gotoAndStop(3);
				addImgZJ();
				mc.step3.imgUrl.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, changeImg);
				mc.step3.imgLinkUrl.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, setImgLink);
				if(mc.step3.imgUrl)
				{
					mc.step3.imgUrl.text = img.url;
				}
				if(mc.step3.imgLinkUrl)
				{
					mc.step3.imgLinkUrl.text = img.link;
				}
				isOpenNewWindow.selected = img.isOpen;
				for(var i:int = 0;i<arrTanchuType.length;i++)
				{
					if(arrTanchuType[i] == img.tanchuType)
					{
						tanchuType.selectedIndex = i;
					}
				}
				
				for(var j:int = 0;j<arrTanchuPos.length;j++)
				{
					if(arrTanchuPos[j] == img.tanchuPos)
					{
						tanchuPos.selectedIndex = j;
					}
				}
			}
			
			if(evt.target is TextBox)
			{
				clearImageZJ();
				font = evt.target as TextBox;
				mc.step3.gotoAndStop(2);
				addFontZJ();
				mc.step3.textContent.text = font.text;
				mc.step3.textLink.text = font.link;
				mc.step3.textSize.text = font.tf.size;
				for(var i:int = 0;i<arrFont.length;i++)
				{
					if(font.tf.font == arrFont[i])	
					{
						cb.selectedIndex = i;
					}
				}
				cp.selectedColor = uint(font.tf.color);
				isB.selected = font.bold;
				isI.selected = font.italic;
//				isU.selected = font.underLine;
				isOpenNewWindow.selected = font.isOpen;
				
				if (font) 
				{ 
					choseFont&&(choseFont.focus = false); 
					font.focus = true;  
					choseFont = font; 
				} 
			}else
			{
				if(choseFont)
				{
					choseFont.focus = false;
				}
			}
			if(tmp == "isGou")
			{
				if(rq)
				{
					if(rq.isGouxuan == 1)
					{
						rq.isGouxuan = 0;
						mc.step3.isGou.gotoAndStop(2);
					}else
					{
						rq.isGouxuan = 1;
						mc.step3.isGou.gotoAndStop(1);
					}
					saveRQ(rq.id);
				}
			}
			if(tmp == "btnDel")		//删除热区
			{
				for(var i:int = 0;i<arr.length;i++)
				{
					if(arr[i][0] == rq.id)
					{
						arr.splice(i,1);
					}
				}
				rq.parent.removeChild(rq);
				rq = null;
			}
			
			if(tmp == "btnDelFont")		//删除文本
			{
				for(var i:int = 0;i<arr.length;i++)
				{
					if(arr[i][0] == font.name)
					{
						arr.splice(i,1);
					}
				}
				font.parent.removeChild(font);
				font = null;
			}
			
			if(tmp == "delImg")
			{
				for(var i:int = 0;i<arr.length;i++)
				{
					if(arr[i][0] == img.id)
					{
						arr.splice(i,1);
					}
				}
				img.parent.removeChild(img);
				img = null;
			}
			if(tmp == "btnOut")
			{
				outStr = "";
				var rand:int = Math.random()*5;
				outStr += arrHX1[rand]+"|";
				var rand:int = Math.random()*5;
				outStr += arrHX2[rand]+"|";
				mc.outData.visible = true;	
				for(var i:int = 0;i<arr.length;i++)
				{
					if(arr[i])
					{
						var str:String = arr[i].join("*");
						
						outStr += str+"|";
					}
				}
				trace(outStr);
				mc.outData.text.text = outStr;
			}
			if(tmp == "btnLogo")
			{
				navigateToURL(new URLRequest("http://www.taobao.com"));
			}
//			if(tmp == "enterRQ")
//			{
//				if(mc.step3.linkText.text != "")
//				{
//					rq.link = mc.step3.linkText.text;
//				}else
//				{
//					rq.link = "http://www.taobao.com";
//				}
//				saveRQ(rq.id);
//			}
		}
		
		private function addToolShare():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function addToolCollection():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function addToolChart():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function addToolSupport():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function addToolDcode():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function addToolSearch():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function addToolMagazine():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function addToolCountdown():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function addToolRect():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function addToolImage():void
		{
			// TODO Auto Generated method stub
			
		}
		private var fontArray:Array = new Array("宋体","黑体","微软雅黑","隶书","幼圆","Georgia","Times New Roman","Impact","Courier New","Arial","Verdana","Tahoma");
		
		// 操作对象，只能有一个
		private var nowOperateTargetObject:*;
		
		/*****************/
		/****文本处理*****/
		/****************/
		
		/**
		 * 添加文本
		 */
		private function addToolText():void
		{
			addID++;
			// 进入文本属性设置页面
			mc.step3.gotoAndStop(2);
//			updateTextPropertiesForm();
			updateTextPropertiesForm("自行修改该文本内容","选填","宋体",false,"0x000000",false,"12",false,false);
			
			mc.step3.txt_textlink.alpha = 0.4;
			mc.step3.txt_textlink.addEventListener(FocusEvent.FOCUS_IN, function():void
			{
				if(mc.step3.txt_textlink.text == "选填"){
					mc.step3.txt_textlink.text = "";
					mc.step3.txt_textlink.alpha = 1;
				}
			});
			
			mc.step3.txt_textlink.addEventListener(FocusEvent.FOCUS_OUT, function():void
			{
				if (mc.step3.txt_textlink.text == ""){
					mc.step3.txt_textlink.text = "选填";
					mc.step3.txt_textlink.alpha = 0.4;
				}
				saveOperateObjectData();
			});
			
			 // 添加文本到设计区域
			var textbox:TextBox = new TextBox(mc.step3.text_txtcontent.text);
			spContent.addChild(textbox);
			textbox.id = addID;
			
			// add to dictionary
			textDictionary[addID] = textbox;
			
			// add event for save data
			mc.step3.text_txtcontent.addEventListener(FocusEvent.FOCUS_OUT, text_focusout_handler);
			mc.step3.text_combobox_font.addEventListener(Event.CHANGE, text_change_handler);
			mc.step3.text_checkbox_bold.addEventListener(Event.CHANGE, text_change_handler);
			(mc.step3.text_colorpicker_fontcolor as ColorPicker).addEventListener(ColorPickerEvent.CHANGE, text_color_picker_change_handler);
			mc.step3.text_checkbox_italic.addEventListener(Event.CHANGE, text_change_handler);
			mc.step3.text_txt_fontsize.addEventListener(FocusEvent.FOCUS_OUT, text_focusout_handler);
			mc.step3.text_checkbox_underline.addEventListener(Event.CHANGE, text_change_handler);
			mc.step3.text_checkbox_newwindow.addEventListener(Event.CHANGE, text_change_handler);
			nowOperateTargetObject = textbox;
			saveOperateObjectData();
		}
		
		protected function text_color_picker_change_handler(event:ColorPickerEvent):void
		{
			saveOperateObjectData();
			changeTextBoxStyle();
		}
		
		private function text_change_handler(e:Event):void
		{
			saveOperateObjectData();
			changeTextBoxStyle();
		}
		
		private function text_focusout_handler(e:FocusEvent):void
		{
			saveOperateObjectData();
			changeTextBoxStyle();
		}		
		
		private function changeTextBoxStyle():void
		{
			var textbox:TextBox = nowOperateTargetObject as TextBox;
			
			textbox.tf.bold = mc.step3.text_checkbox_bold.selected;
			textbox.tf.italic = mc.step3.text_checkbox_italic.selected;
			textbox.tf.underline = mc.step3.text_checkbox_underline.selected;
			textbox.tf.color = (mc.step3.text_colorpicker_fontcolor as ColorPicker).selectedColor;
			textbox.tf.font = (mc.step3.text_combobox_font as ComboBox).selectedLabel;
			textbox.tf.size = mc.step3.text_txt_fontsize.text;
			textbox.p_txt.text = mc.step3.text_txtcontent.text;
			textbox.p_txt.setTextFormat(textbox.tf);
		}
		
		private function updateTextPropertiesForm(textcontent:String="自行修改该文本内容", textlink:String="选填", fontname:String="宋体", textbold:Boolean=false, fontcolor:String="0x000000", textitalic:Boolean=false, fontsize:String="12", underline:Boolean=false, newwindow:Boolean=false):void
		{
			mc.step3.text_txtcontent.text = textcontent ? textcontent : " ";
			mc.step3.txt_textlink.text = textlink ? textlink : " ";
			(mc.step3.text_combobox_font as ComboBox).dataProvider = new DataProvider( fontArray );
			
			(mc.step3.text_combobox_font as ComboBox).selectedIndex = searchFontIndex(fontname);
			(mc.step3.text_checkbox_bold as CheckBox).selected = textbold;
			mc.step3.text_colorpicker_fontcolor.selectedColor = fontcolor;
			mc.step3.text_checkbox_italic.selected = textitalic;
			mc.step3.text_txt_fontsize.text = fontsize ? fontsize : 1;
			mc.step3.text_checkbox_underline.selected = underline;
			mc.step3.text_checkbox_newwindow.selected = newwindow;
			
		}
		
		private var hotarea:HotArea;
		
		/*****************/
		/****热区处理*****/
		/****************/
		
		/**
		 * 添加热区
		 */
		private function addToolHotarea():void
		{
			addID ++;
			hotarea = new HotArea();
			hotarea.id = addID;
			hotarea.graphics.clear();
			hotarea.graphics.lineStyle(hotarea.thickness, hotarea.borderColor);
			hotarea.graphics.beginFill(hotarea.backgroundColor);
			hotarea.graphics.drawRect(0,0, 100, 100);
			hotarea.graphics.endFill();
			spContent.addChild(hotarea);
			
			// add to dictionary
			hotareaDictionary[addID] = hotarea;
			
			// change to hotarea propeties form
			mc.step3.gotoAndStop(1);
			
			// initial hotarea propertiesform
			updateHotareaPropertiesForm();
			
			// add event for save data
			mc.step3.txt_linkurl.addEventListener(FocusEvent.FOCUS_OUT, txt_linkurl_focusout);
			(mc.step3.cb_newwindow as CheckBox).addEventListener(Event.CHANGE, hotarea_newwindow_change);
			
			nowOperateTargetObject = hotarea;
		}
		
		protected function hotarea_newwindow_change(event:Event):void
		{
			saveOperateObjectData();
		}
		
		private function txt_linkurl_focusout(e:FocusEvent):void
		{
			saveOperateObjectData();
		}
		
		private function updateHotareaPropertiesForm(linkurl:String = " ", newwindow:Boolean = false):void
		{
			
			mc.step3.txt_linkurl.text = linkurl ? linkurl : " ";
			mc.step3.cb_newwindow.selected = newwindow;
		}
		
		
		/*****************/
		/****公共函数*****/
		/****************/
		
		private function alert(text:String, title:String="提示框"):void
		{
			
			AlertManager.createAlert(this,text,title);
		}
		
		/**
		 * 获取fontname对应的index
		 */
		private function searchFontIndex(fontname:String):int
		{
			if(fontname == null || fontname == ""){
				return 0;
			}else{
				for (var i:int=0;i<fontArray.length; i++)
				{
					if(fontArray[i] == fontname)
						return i;
				}
				return 0;
			}
			
		}
		
		private var hotareaDictionary:Dictionary = new Dictionary();
		private var textDictionary:Dictionary = new Dictionary();
		private var imageDictionary:Dictionary = new Dictionary();
		private var rectDictionary:Dictionary = new Dictionary();
		private var cuontdownDictionary:Dictionary = new Dictionary();
		private var magazineDictionary:Dictionary = new Dictionary();
		private var searchDictionary:Dictionary = new Dictionary();
		private var dcodeDictionary:Dictionary = new Dictionary();
		private var supportDictionary:Dictionary = new Dictionary();
		private var chartDictionary:Dictionary = new Dictionary();
		private var collectionDictionary:Dictionary = new Dictionary();
		private var shareDictionary:Dictionary = new Dictionary();
		
		/********************************/
		/************保存数据方法 Start***/
		/********************************/
		
		/**
		 * save operate object data
		 */
		private function saveOperateObjectData():void
		{
			if(nowOperateTargetObject is HotArea)
			{
				
				var hotarea:HotArea = nowOperateTargetObject as HotArea;
				hotarea.linkurl = mc.step3.txt_linkurl.text;
				hotarea.newwindow = mc.step3.cb_newwindow.selected;
				hotareaDictionary[hotarea.id] = hotarea;
				
			} else if(nowOperateTargetObject is TextBox)
			{
				var textbox:TextBox = nowOperateTargetObject as TextBox;
				
				textbox.textcontent = mc.step3.text_txtcontent.text;
				textbox.textlink = mc.step3.txt_textlink.text;
				textbox.fontname = (mc.step3.text_combobox_font as ComboBox).selectedLabel;
				textbox.textbold = mc.step3.text_checkbox_bold.selected;
				textbox.fontcolor = mc.step3.text_colorpicker_fontcolor.selectedColor;
				textbox.textitalic = mc.step3.text_checkbox_italic.selected;
				textbox.fontsize = mc.step3.text_txt_fontsize.text;
				textbox.underline = mc.step3.text_checkbox_underline.selected;
				textbox.newwindow = mc.step3.text_checkbox_newwindow.selected;
			}
		}
		
		/**
		 * save hotareadata
		 */
		private function saveHotarea(hotarea:HotArea):void
		{
			hotareaDictionary[hotarea.id] = hotarea;
		}
		/********************************/
		/************保存数据方法 End*****/
		/********************************/
		
		/**
		 * 导出数据
		 */
		private function exportData(event:MouseEvent):void
		{
			var propertySeparate:String = "*";
			var toolsSeparate:String = "|";
			var key:Object="";
			var outputdata:String="";
			
			for (key in hotareaDictionary)
			{
				outputdata += key
					+ propertySeparate
					+ (hotareaDictionary[key] as HotArea).linkurl
					+ propertySeparate
					+ (hotareaDictionary[key] as HotArea).newwindow.toString()
					+ toolsSeparate;
				
			}
			
			for (key in textDictionary)
			{
				outputdata += key
					+ propertySeparate
					+ (textDictionary[key] as TextBox).textcontent
					+ propertySeparate
					+ (textDictionary[key] as TextBox).textlink
					+ propertySeparate
					+ (textDictionary[key] as TextBox).fontname
					+ propertySeparate
					+ (textDictionary[key] as TextBox).textbold
					+ propertySeparate
					+ (textDictionary[key] as TextBox).fontcolor
					+ propertySeparate
					+ (textDictionary[key] as TextBox).textitalic
					+ propertySeparate
					+ (textDictionary[key] as TextBox).fontsize
					+ propertySeparate
					+ (textDictionary[key] as TextBox).underline
					+ propertySeparate
					+ (textDictionary[key] as TextBox).newwindow
					+ toolsSeparate;
				
			}
			
			alert(outputdata);
		}
		
		/**
		 * 更新左侧属性框
		 */
		private function updatePropertiesForm():void
		{
			if(nowOperateTargetObject is HotArea)
			{
				var hotarea:HotArea = nowOperateTargetObject as HotArea;
				mc.step3.gotoAndStop(1);
				updateHotareaPropertiesForm(hotarea.linkurl, hotarea.newwindow);
				
			} else if(nowOperateTargetObject is TextBox)
			{
				var textbox:TextBox = nowOperateTargetObject as TextBox;
				mc.step3.gotoAndStop(2);
				updateTextPropertiesForm(textbox.textcontent, textbox.textlink, textbox.fontname, textbox.textbold, textbox.fontcolor, textbox.textitalic, textbox.fontsize, textbox.underline, textbox.newwindow);
			}
		}
		
		
		
		
		
		
		
		
		
		
		var outStr:String = "";
		
		private function cleraFontZJ():void
		{
			removeZJ(isB);
			removeZJ(isU);
			removeZJ(isI);
			removeZJ(isOpenNewWindow);
			removeZJ(cp);
			removeZJ(cb);
		}
		
		private function clearImageZJ():void
		{
			removeZJ(isOpenNewWindow);
			removeZJ(tanchuType);
			removeZJ(tanchuPos);
		}
		
		private function addFontZJ():void
		{
			mc.step3.textContent.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, saveTextContent);
			mc.step3.textLink.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, saveTextLink);
			mc.step3.textSize.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, saveTextSize);
			mc.step3.textSize.restrict = "0-9";
			addZJ(isB, CheckBox, mc.step3, 192, 121);
			addZJ(isI, CheckBox, mc.step3, 192, 151);
			addZJ(isU, CheckBox, mc.step3, 192, 176);
			addZJ(isOpenNewWindow, CheckBox, mc.step3, 80, 228);
			addZJ(cb, ComboBox, mc.step3, 61, 124);
			addZJ(cp, ColorPicker, mc.step3, 62, 150);
		}
		
		private function addZJ(obj:DisplayObject, cla:Class, parent:MovieClip, x:int, y:int):void
		{
			if(!obj)
			{
				obj = new cla();
			}
			parent.addChild(obj);
			obj.x = x;
			obj.y = y;
		}
		
		private function removeZJ(obj:DisplayObject):void
		{
			if(obj)
			{
				try
				{
					obj.parent.removeChild(obj);
				} 
				catch(error:Error) 
				{
					
				}
			}
		}
	
		private function saveTextContent(evt:FocusEvent):void
		{
			if(font && mc.step3.textContent)
			{
				font.setText(mc.step3.textContent.text);
				saveFont(font.name);
			}
		}
		
		private function saveTextSize(evt:FocusEvent):void
		{
			font.setFontSize(int(mc.step3.textSize.text));
			saveFont(font.name);
		}
			
		private function saveTextLink(evt:FocusEvent):void
		{
//			if(mc.step3.textLink && mc.step3.textLink.text != "")
//			{
				font.setLink(mc.step3.textLink.text);
				saveFont(font.name);
//			}
		}

		private function saveRQtextLink(evt:FocusEvent):void
		{
			if(mc.step3.linkText.text != "")
			{
				rq.link = mc.step3.linkText.text;
			}else
			{
				rq.link = "http://www.taobao.com";
			}
			saveRQ(rq.id);
		}
		
		private function changeImg(evt:FocusEvent):void
		{
			mc.step3.imgUrl.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, changeImg);
			
			if(mc.step3.imgUrl.text != "")
			{
				if(img.img)
				{
					img.img.parent.removeChild(img.img);
				}else
				{
					img.graphics.clear();
				}
				img.loadImg(mc.step3.imgUrl.text);
				saveImg(img.id);
			}
		}
		
		private function setImgLink(evt:FocusEvent):void
		{
			if(img && mc.step3.imgLinkUrl.text != "")
			{
				img.link = mc.step3.imgLinkUrl.text;
				saveImg(img.id);
			}
		}
		
		private function setTanchuContent(evt:FocusEvent):void
		{
			var content:String = "";
			content = mc.step3.tanchuContent.text;
			if(content.substr(content.length-3, 3) == "png" ||  content.substr(content.length-1, 3) == "jpg")
			{
//				var load:Loader = new Loader();
//				load.contentLoaderInfo.addEventListener(Event.COMPLETE, function com(evt:Event):void
//				{
//					img.tanchuImg = load.content as Bitmap;
//					img.addEventListener(MouseEvent.MOUSE_OVER, function over(evt:MouseEvent):void
//					{
//						spContent.addChild(img.tanchuImg);
//						if(img.tanchuImg.width > img.width)
//						{
//							img.tanchuImg.x = img.x - (img.tanchuImg.width - img.width)/2;
//						}else
//						{
//							img.tanchuImg.x = img.x + (img.width - img.tanchuImg.width)/2;
//						}
//						if(img.tanchuImg.height > img.height)
//						{
//							img.tanchuImg.y = img.y - (img.tanchuImg.height - img.height)/2;
//						}else
//						{
//							img.tanchuImg.y = img.y + (img.height - img.tanchuImg.height)/2;
//						}
//					});
//					img.addEventListener(MouseEvent.MOUSE_OUT, function out(evt:MouseEvent):void
//					{
//						try
//						{
//							spContent.removeChild(img.tanchuImg);
//						} 
//						catch(error:Error) 
//						{
//							
//						}
//					});
//				});
//				load.load(new URLRequest(content));
			}
		}
		
		private function addImgZJ():void
		{
			addZJ(isOpenNewWindow, CheckBox, mc.step3, 78, 95);
			addZJ(tanchuType, ComboBox, mc.step3, 82, 118);
			addZJ(tanchuPos, ComboBox, mc.step3, 82, 143);
			
		}
		
		private function remove(evt:Event):void
		{
			
		}
	}
}