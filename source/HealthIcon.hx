package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);


		animation.add('bf', [0, 1, 2], 0, false, isPlayer);
		animation.add('bf-old', [3, 4, 5], 0, false, isPlayer);
		animation.add('bf-tetris', [6, 7, 8], 0, false, isPlayer);
		animation.add('mami', [9, 10, 11], 0, false, isPlayer);
		animation.add('mami-holy', [12, 13, 14], 0, false, isPlayer);
		animation.add('mami-tetris', [15, 16, 17], 0, false, isPlayer);
		animation.add('dad', [18, 19, 20], 0, false, isPlayer);
		animation.add('gf', [21, 22, 23], 0, false, isPlayer);
		animation.play(char);

		antialiasing = true;
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}