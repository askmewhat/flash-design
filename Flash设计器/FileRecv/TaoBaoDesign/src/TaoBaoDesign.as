package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import main.Main;
	
	[SWF(width="1349", height="750")]
	public class TaoBaoDesign extends Sprite
	{
		private var _main:Main;
		public function TaoBaoDesign()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_main = new Main();
			addChild(_main);
		}
	}
}