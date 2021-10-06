package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'gacha', 'credits', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;

	var ticketsCount:FlxText;
	var ticketIcon:FlxSprite;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.4.2" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var mamiLogo:FlxSprite;
	var titleCharacter:FlxSprite;

	var menuSlide:FlxSprite;
	var canMove:Bool = false;

	var menuCharacterNum:Int = 0;
	var menuBGNum:Int = 0;

	var menuInfomation:FlxText;
	var ticketText:FlxText;

	var menuCharacterIcon:HealthIcon;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		Conductor.changeBPM(120);

		if (!FlxG.sound.music.playing && curSelected <= 4)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		menuBGNum = FlxG.random.int(0, 1);

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('mainmenu/menu_' + menuBGNum));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.15;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		FlxTween.linearMotion(bg, -80, -1280, -80, -80, 2, {ease: FlxEase.quadOut});

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.15;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		FlxTween.linearMotion(magenta, -80, -1280, -80, -80, 2, {ease: FlxEase.quadOut});

		//random character code here
		if (FlxG.save.data.progressStoryClearHard)
			{
				menuCharacterNum = FlxG.random.int(0, 2);
			}
		else
			{
				menuCharacterNum = FlxG.random.int(0, 1);
			}

		titleCharacter = new FlxSprite(FlxG.width * 0.25, -50);
		titleCharacter.frames = Paths.getSparrowAtlas('mainmenu/titlecharacter_' + menuCharacterNum);
		titleCharacter.antialiasing = true;
		titleCharacter.setGraphicSize(Std.int(titleCharacter.width * 1.35));
		titleCharacter.animation.addByPrefix('idle', 'IDLE', 24, false);
		titleCharacter.animation.play('idle');
		titleCharacter.scrollFactor.set(0, 0.05);
		titleCharacter.updateHitbox();
		titleCharacter.alpha = 0;
		add(titleCharacter);

		mamiLogo = new FlxSprite(768, 25);
		mamiLogo.frames = Paths.getSparrowAtlas('mainmenu/mamilogo');
		mamiLogo.antialiasing = true;
		mamiLogo.setGraphicSize(Std.int(mamiLogo.width * 0.5));
		mamiLogo.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		mamiLogo.animation.play('bump');
		mamiLogo.scrollFactor.set(0, 0);
		mamiLogo.updateHitbox();
		add(mamiLogo);
		FlxTween.linearMotion(mamiLogo, 768, -1280, 768, 25, 2, {ease: FlxEase.quadOut});

		var menuBottom:FlxSprite = new FlxSprite(0, 1280).loadGraphic(Paths.image('mainmenu/menubottom_' + menuCharacterNum));
		menuBottom.scrollFactor.set(0, 0);
		menuBottom.setGraphicSize(Std.int(menuBottom.width * 1));
		menuBottom.updateHitbox();
		menuBottom.screenCenter();
		menuBottom.antialiasing = true;
		add(menuBottom);
		FlxTween.linearMotion(menuBottom, 0, 1280, 0, 0, 2, {ease: FlxEase.quadOut});

		var menuSlide:FlxSprite = new FlxSprite(-1280, 0).loadGraphic(Paths.image('mainmenu/menuslide'));
		menuSlide.scrollFactor.set(0, 0);
		menuSlide.setGraphicSize(Std.int(menuSlide.width * 1));
		menuSlide.updateHitbox();
		menuSlide.screenCenter();
		menuSlide.antialiasing = true;
		add(menuSlide);
		FlxTween.linearMotion(menuSlide, 0, -1280, 0, 0, 2, {ease: FlxEase.quadOut});

		if (FlxG.save.data.progressStoryClearHard)
			{
			switch (menuCharacterNum)
				{
					case 0:
						menuCharacterIcon = new HealthIcon("bf", false);
					case 1:
						menuCharacterIcon = new HealthIcon("mami", false);
					case 2:
						menuCharacterIcon = new HealthIcon("mami-holy", false);
				}
			}
		else
			{
				switch (menuCharacterNum)
				{
					case 0:
						menuCharacterIcon = new HealthIcon("bf", false);
					case 1:
						menuCharacterIcon = new HealthIcon("mami", false);
				}	
			}

		menuCharacterIcon.x = 1100;
		menuCharacterIcon.y = 550;
		menuCharacterIcon.flipX = true;
		menuCharacterIcon.setGraphicSize(Std.int(menuCharacterIcon.width * 1.5));
		menuCharacterIcon.animation.curAnim.curFrame = 2;
		menuCharacterIcon.angle = -10;
		menuCharacterIcon.alpha = 0.0;
		menuCharacterIcon.scrollFactor.set(0, 0);
		add(menuCharacterIcon);
		FlxTween.linearMotion(menuCharacterIcon, 1100, 1280, 1100, 550, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(menuCharacterIcon, {angle: 10}, 2.5, {type: FlxTweenType.PINGPONG, ease: FlxEase.quadInOut});
		FlxTween.tween(menuCharacterIcon, {alpha: 1}, 3, {type: FlxTweenType.ONESHOT, ease: FlxEase.quadInOut});

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		menuInfomation = new FlxText(110, 675, 1000, "Please select a option.", 28);
		menuInfomation.setFormat("VCR OSD Mono", 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		menuInfomation.scrollFactor.set(0, 0);
		menuInfomation.borderSize = 2;
		add(menuInfomation);

		ticketIcon = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/gacha_icon'));
		ticketIcon.scrollFactor.set(0, 0);
		ticketIcon.setGraphicSize(Std.int(ticketIcon.width * .100));
		ticketIcon.updateHitbox();
		ticketIcon.antialiasing = true;
		add(ticketIcon);
		
		var tex = Paths.getSparrowAtlas('mainmenu/FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(90, 40 + (i * 100));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.x = 30;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			FlxTween.linearMotion(menuItem, 30, -1280 + (i * 100), 30, 40 + (i * 100), 2, {ease: FlxEase.quadOut});
		}

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, 'Vs. Mami FULL WEEK 1.01', 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();


		ticketsCount = new FlxText(FlxG.width * 0.9, 35, 0, "", 32);
		ticketsCount.setFormat("VCR OSD Mono", 64, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		ticketsCount.alpha = 1;
		ticketsCount.text = FlxG.save.data.tickets;
		ticketsCount.scrollFactor.set(0, 0);
		//add(ticketsCount);

		ticketText = new FlxText(110, 675, 1000, "x0", 28);
		ticketText.setFormat("VCR OSD Mono", 28, FlxColor.GRAY, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		ticketText.scrollFactor.set(0, 0);
		ticketText.borderSize = 2;
		add(ticketText);

		ticketText.text = ("x" + FlxG.save.data.tickets);

		new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				titleCharacter.x = -600;
				titleCharacter.alpha = 0;
				FlxTween.tween(titleCharacter,{alpha: 1}, 4, {ease: FlxEase.quartOut});
				FlxTween.tween(titleCharacter,{x: 200}, 8, {ease: FlxEase.quartOut});
				canMove = true;
			});

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		ticketIcon.x = menuItems.members[2].x + 625;
		ticketIcon.y = menuItems.members[2].y + 50;

		ticketText.x = menuItems.members[2].x + 250;
		ticketText.y = menuItems.members[2].y + 65;

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin && canMove)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else if (optionShit[curSelected] == 'gacha')
					{
						FlxG.sound.play(Paths.sound('errorMenu'));
						//FlxG.switchState(new SummonState());
					}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxTween.tween(ticketIcon, {alpha: 0}, 1.3, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							ticketIcon.kill();
						}
					});


					FlxTween.tween(ticketText, {alpha: 0}, 1.3, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							ticketText.kill();
						}
					});

					//FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());

										trace("Freeplay Menu Selected");

									case 'credits':
										FlxG.switchState(new CreditState());

									case 'options':
										FlxG.sound.music.stop();
										FlxG.switchState(new OptionsMenu());
								}
							});
						}
					});
				}
			}
		}

		FlxG.camera.zoom = FlxMath.lerp(1.0, FlxG.camera.zoom, 0.95);

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
			{
				if (spr.ID != curSelected)
					{
						spr.x = 0;
					}
			});
	}

	override function beatHit()
		{
			FlxG.log.add(curBeat);
	
			if (curBeat % 2 == 0)
				{
					mamiLogo.animation.play('bump', true);
					titleCharacter.animation.play('idle', true);
				}

			if (curBeat % 4 == 0)
				{
					FlxG.camera.zoom += 0.02;
				}
			
			super.beatHit();
		}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		switch (curSelected) //putting this in update because changeitem was not being nice to me
			{
				case 0:
					menuInfomation.text = "Play through the Story Mode!";
					menuInfomation.color = FlxColor.WHITE;
				case 1:
					menuInfomation.text = "Play any song from the mod you'd like.";
					menuInfomation.color = FlxColor.WHITE;
				case 2:
					menuInfomation.text = "[COMING IN VERSION 1.1]";
					menuInfomation.color = FlxColor.GRAY;
				case 3:
					menuInfomation.text = "View the list of people who help created this mod.";
					menuInfomation.color = FlxColor.WHITE;
				case 4:
					menuInfomation.text = "Donate to the OFFICAL Friday Night Funkin' team.";
					menuInfomation.color = FlxColor.WHITE;
				case 5:
					menuInfomation.text = "Configure your settings here.";
					menuInfomation.color = FlxColor.WHITE;
			}

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (canMove)
				FlxTween.completeTweensOf(spr);
			spr.x = 0;
			spr.updateHitbox();
			if (spr.ID == curSelected)
				{
					spr.animation.play('selected');
					camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
					FlxTween.tween(spr,{x: 60}, .3, {ease: FlxEase.quartOut});
				}
		});
	}
}
