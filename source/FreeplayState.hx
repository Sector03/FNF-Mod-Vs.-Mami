package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import lime.utils.Assets;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;
	var selectedSong = false;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var songPlaying:Bool = false;
	var playingSongText:FlxText;
	var menuLeftSide:FlxSprite;
	var freePlaylock:FlxSprite;
	var freePlaylock1:FlxSprite;

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1]));
		}

		 
		if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Freeplay Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);

		menuLeftSide = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplaymenu/left_section'));
		menuLeftSide.scrollFactor.set(0, 0);
		menuLeftSide.setGraphicSize(Std.int(menuLeftSide.width * 1));
		menuLeftSide.updateHitbox();
		menuLeftSide.screenCenter();
		menuLeftSide.antialiasing = true;
		add(menuLeftSide);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		freePlaylock = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplaymenu/freeplaylock'));
		freePlaylock.scrollFactor.set(0, 0);
		freePlaylock.setGraphicSize(Std.int(freePlaylock.width * 0.5));
		add(freePlaylock);

		if (FlxG.save.data.progressStoryClearHard == false)
			{
				freePlaylock1 = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplaymenu/freeplaylock1'));
			}
		else
			{
				freePlaylock1 = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplaymenu/freeplaylock1reveal'));
			}

		freePlaylock1.scrollFactor.set(0, 0);
		freePlaylock1.setGraphicSize(Std.int(freePlaylock1.width * 0.5));
		add(freePlaylock1);

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 32, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		playingSongText = new FlxText(FlxG.width * 0.1, 32, 0, "Press P to toggle song previews. (OFF)", 32);
		playingSongText.setFormat("VCR OSD Mono", 32, FlxColor.GRAY, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(playingSongText);

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.Y)
			{
				FlxG.save.data.progressStoryClearHard = true;
			}
		
		if (FlxG.keys.justPressed.H)
			{
				FlxG.save.data.progressStoryClearHard = false;
			}	

		if (FlxG.keys.justPressed.U)
			{
				FlxG.save.data.progressStoryClearTetris = true;
			}
		
		if (FlxG.keys.justPressed.J)
			{
				FlxG.save.data.progressStoryClearTetris = false;
			}	
		

		if (FlxG.save.data.progressStoryClearHard == false)
			{
			freePlaylock.x = grpSongs.members[3].x - 420;
			freePlaylock.y = grpSongs.members[3].y - 90;
			freePlaylock.alpha = 1.0;
			}
		else
			freePlaylock.alpha = 0;

		if (FlxG.save.data.progressStoryClearTetris == false)
			{
			freePlaylock1.x = grpSongs.members[4].x - 420;
			freePlaylock1.y = grpSongs.members[4].y - 90;
			freePlaylock1.alpha = 1.0;
			}
		else
			freePlaylock1.alpha = 0;
		

		if (FlxG.keys.justPressed.P && !selectedSong)
			{
				songPlaying = !songPlaying;
			}

		if (FlxG.keys.justPressed.P && songPlaying && !selectedSong)
			{
				FlxTween.completeTweensOf(playingSongText);
				FlxTween.color(playingSongText, .5, FlxColor.GRAY, FlxColor.WHITE, {ease: FlxEase.quadOut});

				if (curSelected <= 2)
					{
						if (FlxG.save.data.copyrightedMusic && curSelected == 0)
							{
							FlxG.sound.playMusic(Paths.instcr(songs[curSelected].songName), 0);
							}
						else
							{
								FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
							}
					}

				playingSongText.text = "Press P to toggle song previews. (ON)";
				playingSongText.size = 32;
			}

		if (FlxG.keys.justPressed.P && !songPlaying && !selectedSong)
			{
				FlxTween.completeTweensOf(playingSongText);
				FlxTween.color(playingSongText, .5, FlxColor.WHITE, FlxColor.GRAY, {ease: FlxEase.quadOut});
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				playingSongText.color = FlxColor.WHITE;
				playingSongText.text = "Press P to toggle song previews. (OFF)";
				playingSongText.size = 32;
			}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (!selectedSong)
			{
			if (upP)
			{
				changeSelection(-1);
			}
			if (downP)
			{
				changeSelection(1);
			}

			if (controls.LEFT_P)
				changeDiff(-1);
			if (controls.RIGHT_P)
				changeDiff(1);

			if (controls.BACK)
			{
				FlxG.switchState(new MainMenuState());
			}

			if (accepted)
			{
				if (curSelected == 3 && FlxG.save.data.progressStoryClearHard)
					{
					FlxG.sound.music.stop();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					selectedSong = true;
					changeSelection(0); //I KNOW I'M SO FUCKING STUPID
					var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

					trace(poop);

					PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = curDifficulty;
					PlayState.storyWeek = songs[curSelected].week;

					new FlxTimer().start(1, function(tmr:FlxTimer)
						{
							trace('CUR WEEK' + PlayState.storyWeek);
							LoadingState.loadAndSwitchState(new PlayState());
						});
					}
				else if (curSelected == 4 && FlxG.save.data.progressStoryClearTetris)
					{
						FlxG.sound.music.stop();
						FlxG.sound.play(Paths.sound('confirmMenu'));
						selectedSong = true;
						changeSelection(0); //I KNOW I'M SO FUCKING STUPID
						var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
	
						trace(poop);
	
						PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = curDifficulty;
						PlayState.storyWeek = songs[curSelected].week;
	
						new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								trace('CUR WEEK' + PlayState.storyWeek);
								LoadingState.loadAndSwitchState(new PlayState());
							});
					}
				else if (curSelected <= 2)
					{
						FlxG.sound.music.stop();
						FlxG.sound.play(Paths.sound('confirmMenu'));
						selectedSong = true;
						changeSelection(0); //I KNOW I'M SO FUCKING STUPID
						var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
	
						trace(poop);
	
						PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = curDifficulty;
						PlayState.storyWeek = songs[curSelected].week;
	
						new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								trace('CUR WEEK' + PlayState.storyWeek);
								LoadingState.loadAndSwitchState(new PlayState());
							});
					} //FUCK THIS IS WEIRD
			}
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curSelected >= 3)
			{
			if (curDifficulty < 2)
				curDifficulty = 3;
			if (curDifficulty > 3) //curdiff 4 for master
				curDifficulty = 2;
			}
		else
			{
			if (curDifficulty < 0)
				curDifficulty = 3;
			if (curDifficulty > 3)
				curDifficulty = 0;
			}

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		FlxTween.completeTweensOf(diffText);
		diffText.alpha = 0;
		diffText.x += 25;
		FlxTween.tween(diffText, {x: 896, alpha: 1}, 0.1, {ease: FlxEase.quartOut});

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
				diffText.color = FlxColor.LIME;
			case 1:
				diffText.text = 'NORMAL';
				diffText.color = FlxColor.YELLOW;
			case 2:
				diffText.text = "HARD";
				diffText.color = FlxColor.RED;
			case 3:
				diffText.text = "HOLY";
				diffText.color = 0xFFFEE897;
		}
	}

	function changeSelection(change:Int = 0)
	{
		if (selectedSong)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));
		}

		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		if (!selectedSong)
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected >= 3 && curDiffiuclty <= 2)
			{
			if (curDifficulty < 2)
				curDifficulty = 3;
			if (curDifficulty > 3) //curdiff 4 for master
				curDifficulty = 2;
			}

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		if (songPlaying && !selectedSong && curSelected <= 2)
			{
				if (curSelected == 0 && FlxG.save.data.copyrightedMusic)
					{
					FlxG.sound.playMusic(Paths.instcr(songs[curSelected].songName), 0);
					}
				else
					{
						FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
					}
			}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		for (item in grpSongs.members)
			{
				item.alpha = 0.6;
			}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.alpha = 0.6;
			
			FlxTween.completeTweensOf(item);

			item.alpha = 0.6;

			item.targetY = bullShit - curSelected;
			bullShit++;

			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				if (selectedSong)
					{
						item.alpha = 1;
						FlxG.sound.play(Paths.sound('confirmMenu'));
						FlxTween.color(item, 3, FlxColor.YELLOW, FlxColor.WHITE, {ease: FlxEase.quadOut});
						FlxFlicker.flicker(item, 1, 0.2, true);
					}
				else
					{
						//FlxTween.color(item, 1, FlxColor.YELLOW, FlxColor.WHITE, {ease: FlxEase.quadOut});
						item.alpha = 1;
					}
			}
			else
				{
					if (selectedSong) // this code got so messy after adding locked freeplay stuff
						{
							FlxTween.tween(item, {x: 1000, "alpha": 0}, 1, {ease: FlxEase.quadIn});
							if (FlxG.save.data.progressStoryClearHard == false) //hard story not cleared, when selecting a unlocked song they will fade away and not spoil the secret song name
								{
								FlxTween.tween(freePlaylock, {"alpha": 0}, 1, {ease: FlxEase.quadIn});
								FlxTween.tween(freePlaylock1, {"alpha": 0}, 1, {ease: FlxEase.quadIn});
								grpSongs.members[3].alpha = 0;
								grpSongs.members[4].alpha = 0;
								}

							for (i in 0...iconArray.length)
								{
									FlxTween.tween(iconArray[i], {x: 1200, "alpha": 0}, 1, {ease: FlxEase.quadIn});
									FlxTween.cancelTweensOf(iconArray[curSelected]);

									if (FlxG.save.data.progressStoryClearHard == false) //same exact thing but with icons
										{
										iconArray[3].alpha = 0;
										iconArray[4].alpha = 0;
										}
								}
						}
				}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
