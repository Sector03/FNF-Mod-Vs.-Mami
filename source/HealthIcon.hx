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
	switch (char){
			case 'mami-tetris':
				{
					frames = Paths.getSparrowAtlas('mami_tetris_icon');
					animation.addByPrefix('Winning', 'mami_tetris_icon idle', 24);
					animation.play('Winning');
				}
			default: 
			{
				loadGraphic(Paths.image('iconGrid'), true, 150, 150);


				animation.add('bf', [0, 1, 2], 0, false, isPlayer);
				animation.add('bf-old', [3, 4, 5], 0, false, isPlayer);
				animation.add('bf-shot', [24, 24, 24], 0, false, isPlayer);
				animation.add('bf-tetris', [6, 7, 8], 0, false, isPlayer);
				animation.add('bf-tetris-shot', [25, 25, 25], 0, false, isPlayer);
				animation.add('mami', [9, 10, 11], 0, false, isPlayer);
				animation.add('mami-holy', [12, 13, 14], 0, false, isPlayer);
				animation.add('mami-holy-postsnap', [12, 26, 12], 0, false, isPlayer);
				animation.add('dad', [18, 19, 20], 0, false, isPlayer);
				animation.add('mami-mamigation', [21, 22, 23], 0, false, isPlayer);
				
		
				animation.play(char);
		
				antialiasing = true;
				scrollFactor.set();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}