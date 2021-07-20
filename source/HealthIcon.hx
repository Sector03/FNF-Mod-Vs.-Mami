package;

import flixel.FlxSprite;

using StringTools;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	var curchar:String = "";

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		
		curchar = char;

		animation.play(char);
		antialiasing = true;
		scrollFactor.set();

		loadGraphic(Paths.image('healthIcons/' + curchar, 'shared'), true, 150, 150);
		animation.add(curchar, [0, 1], 0, false, isPlayer);

		animation.play(curchar);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}

/**
	Thanks Sector for Making this B)
**/