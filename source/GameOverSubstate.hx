package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.FlxCamera;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";
	var camSubtitle:FlxCamera;

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (daStage)
		{
			case 'school':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'schoolEvil':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'subway-tetris':
				stageSuffix = '-tetris';
				daBf = 'bf-tetris';
			default:
				daBf = 'bf';
		}

		var daOpponent = PlayState.SONG.player2;

		var numBah:Int = 0;
		var fadeMusicItemIn:Float = 0.0;

		camSubtitle = new FlxCamera();
		camSubtitle.bgColor.alpha = 0;
		FlxG.cameras.add(camSubtitle);

		var deathlineSubtitle:FlxText;
		deathlineSubtitle = new FlxText(0, 0, 1000, '[DEATHLINE HERE]', 32);
		deathlineSubtitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		deathlineSubtitle.borderSize = 3;
		deathlineSubtitle.scrollFactor.set(1, 1);
		deathlineSubtitle.screenCenter();
		deathlineSubtitle.y += 300;
		deathlineSubtitle.cameras = [camSubtitle];

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		numBah = FlxG.random.int(1, 3);

		new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				if (!isEnding)
					{
					add(deathlineSubtitle);
					FlxG.sound.play(Paths.sound('deathlines/' + daOpponent + "-" + numBah));

					switch (numBah)
						{
							case 1:
								fadeMusicItemIn = 2.75;
								deathlineSubtitle.text = "Shall we have a tea break?";

							case 2:
								fadeMusicItemIn = 2.75;
								deathlineSubtitle.text = "Fear not. There's no way I'll lose.";

							case 3:
								fadeMusicItemIn = 2.5;
								deathlineSubtitle.text = "One job done.";
						}
		
		
					new FlxTimer().start(fadeMusicItemIn, function(tmr:FlxTimer)
						{
							remove(deathlineSubtitle); //something is nulling here i think?
						});	
					}
			});	

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix), 0.5);
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
