package haxe.ui.builder;

import openfl.display.Sprite;

@:keep
class Smiley extends Sprite {
	private static inline var DEFAULT_SIZE:Int = 100;
	
	public function new() {
		super();
		draw();
	}
	
	private function draw():Void {
		var size:Float = DEFAULT_SIZE / 2;
		var eyeHeight:Float = size / 3;
		var eyeWidth:Float = eyeHeight / 2;

		graphics.lineStyle(size / 30,0x000000);
		graphics.beginFill(0xFFFF00);
		graphics.drawCircle(size, size, size);
		graphics.endFill();

		graphics.beginFill(0x000000);
		graphics.drawEllipse(size - eyeHeight, size-(3*eyeWidth), eyeWidth, eyeHeight);
		graphics.drawEllipse(size + eyeWidth, size-(3*eyeWidth), eyeWidth, eyeHeight);

		graphics.endFill();
		
		graphics.moveTo(eyeHeight, size + eyeHeight);
		graphics.curveTo(size, size * 2, (size * 2) - eyeHeight, size + eyeHeight);
		
		width = DEFAULT_SIZE;
		height = DEFAULT_SIZE;
	}
}