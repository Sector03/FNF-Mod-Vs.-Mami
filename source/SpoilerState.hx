package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;



class SpoilerState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";


	var bg:FlxSprite;

	override function create()
	{
		var tex = Paths.getSparrowAtlas('spoiler','shared');
		bg = new FlxSprite(-200, -100);
		bg.frames = tex;
		bg.animation.addByPrefix('idle', 'spoiler loop');
		bg.scale.x *= 2.57;
		bg.scale.y *= 2.57;
		bg.screenCenter();
		bg.animation.play('idle', true);
		bg.alpha = 0.5;
		add(bg);


		super.create();
		
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Hi Person\n"
			+ " So this mod has like spoilers and shit to the Madoka Magica series "
			+ "\nand"
			+ "\nMagia Record(I think)"
			+ "\nPress Enter if you actually watched the series or just don't care lol",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}
}
