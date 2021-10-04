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
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class CreditState extends MusicBeatState
{
	var curSelected:Int = 0;
	var onSpecial:Bool = false;
	var credicons:FlxTypedGroup<FlxSprite>;
	var menuRoles:FlxTypedGroup<FlxText>;
	var menuItems:FlxTypedGroup<FlxSprite>;
	//NAMES
	#if !switch
	var optionShit:Array<String> = [
		'faderevampedtext', //Fade Revamped
		'eggoverlordtext', //Egg Overlord
		'theawfulusernametext', //TheAwfulUsername
		'boinkbonktext', //BoinkBonk
		'sectortext', //Sector
		'vidztext', //Vidz
		'magbrostext', //Magbros
		'ascentitext', //Ascenti
		'kayotext', //Cerbera
		'cerberatext']; //Kayo
	#else
	var optionShit:Array<String> = [
		'Fade Revamped', //Fade Revamped
		'Egg Overlord', //Egg Overlord
		'TheAwfulUsername', //TheAwfulUsername
		'BoinkBonk', //BoinkBonk
		'Sector', //Sector
		'Vidz', //Vidz
		'Magbros', //Magbros
		'Ascenti',
		'Kayo',
		'Cerbera'];
	#end
	//ROLES
	#if !switch
	var credinfolist:Array<String> = [
		'Lead Director, Charter, Vocalist', //Fade Revamped
		'Co-Director, Publisher, Art', //Egg Overlord
		'Co-Director, Vocalist, Advisor', //TheAwfulUsername
		'Animator', //BoinkBonk
		'Coder, General Quality Assurance, Charter', //Sector
		'Coder', //Vidz
		'Musician', //Magbros
		'Connect Cutscene Animator', //Ascenti
		'Musician', //Cerbera
		'Charter']; //Kayo
	#else
	var credinfolist:Array<String> = [
		'Lead Director, Charter, Vocalist', //Fade Revamped
		'Co-Director, Publisher, Art', //Egg Overlord
		'Co-Director, Vocalist, Advisor', //TheAwfulUsername
		'Animator', //BoinkBonk
		'Coder, General Quality Assurance, Charter', //Sector
		'Coder', //Vidz
		'Musician', //Magbros
		'Connect Cutscene Animator',
		'Musician',
		'Charter']
	#end
	//ICONS
	#if !switch
	var crediconlist:Array<String> = [
		'faderevampedicon', //Fade Revamped
		'eggoverlordicon', //Egg Overlord
		'theawfulusernameicon', //TheAwfulUsername
		'boinkbonkicon', //BoinkBonk
		'sectoricon', //Sector
		'vidzicon', //Vidz
		'magbrosicon', //Magbros
		'acentiicon',
		'kayoicon',
		'cerberaicon'];	//Ascenti
	#else
	var crediconlist:Array<String> = [
		'faderevampedicon', //Fade Revamped
		'eggoverlordicon', //Egg Overlord
		'theawfulusernameicon', //TheAwfulUsername
		'boinkbonkicon', //BoinkBonk
		'sectoricon', //Sector
		'vidzicon', //Vidz
		'magbrosicon', //Magbros
		'acentiicon',
		'cerberaicon',
		'kayoicon']; //Ascenti
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.4.2" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var creditRoleText:FlxText;
	var creditNameText:FlxText;
	var creditSpecialChange:FlxText;
	var specialThanksText:FlxText;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.15;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

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
		// magenta.scrollFactor.set();

		//NAMES
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('credits/names');
		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(-250, 80 + (i * 60));
			menuItem.alpha = 0;
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0, 0);
			menuItem.antialiasing = true;
			FlxTween.tween(menuItem, {x: 50, alpha: 1}, 1, {type: FlxTweenType.ONESHOT, ease: FlxEase.quadInOut});
		}

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, 'Vs. Mami DEVELOPMENT BUILD 10/3/2021', 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var tex = Paths.getSparrowAtlas('credits/icons');

		//ICONS
		credicons = new FlxTypedGroup<FlxSprite>();
		add(credicons);

		for (i in 0...crediconlist.length)
			{
				var crediticon:FlxSprite = new FlxSprite(650, 130);
				crediticon.angle = -10;
				crediticon.frames = tex;
				crediticon.animation.addByPrefix('idle', crediconlist[i] + " basic", 24);
				crediticon.animation.addByPrefix('selected', crediconlist[i] + " white", 24);
				crediticon.animation.play('idle');
				crediticon.ID = i;
				crediticon.scale.set(1, 1);
				credicons.add(crediticon);
				crediticon.scrollFactor.set();
				crediticon.antialiasing = true;
				FlxTween.tween(crediticon, {angle: 10}, 2.5, {type: FlxTweenType.PINGPONG, ease: FlxEase.quadInOut});
			}
		
		//ROLES
		
		creditRoleText = new FlxText(680, 530, 420, "Lead Director, Charter, Vocalist", 38);
		creditRoleText.setFormat(Paths.font("vcr.ttf"), 38, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		creditRoleText.text = "Lead Director, Charter, Vocalist";
		creditRoleText.scrollFactor.set();
		creditRoleText.borderSize = 2;
		add(creditRoleText);
	
		creditNameText = new FlxText(680, 80, 460, "Fade Revamped", 48);
		creditNameText.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		creditNameText.text = "Fade Revamped";
		creditNameText.scrollFactor.set();
		creditNameText.borderSize = 2;
		add(creditNameText);

		creditSpecialChange = new FlxText(900, 680, 1000, "Press RIGHT to view Special Thanks ->", 32);
		creditSpecialChange.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		creditSpecialChange.text = "Press RIGHT to view Special Thanks ->";
		creditSpecialChange.scrollFactor.set();
		creditSpecialChange.screenCenter(X);
		creditSpecialChange.borderSize = 2;
		add(creditSpecialChange);

		specialThanksText = new FlxText(900, 680, 1280, "Special Thanks", 48);
		specialThanksText.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		specialThanksText.text = "Press RIGHT to view Special Thanks ->";
		specialThanksText.scrollFactor.set();
		specialThanksText.screenCenter(X);
		specialThanksText.screenCenter(Y);
		specialThanksText.borderSize = 3;
		specialThanksText.visible = false;
		specialThanksText.y -= 220;
		add(specialThanksText);

		specialThanksText.text = "SPECIAL THANKS TO THE FOLLOWING\n" + " \n" + "Kade Dev - Kade Engine\n" + "Lexicord - ???\n" + "Shadow Mario - ???\n" + "JADS - ???\n" + "BoinkBonk - Bug Testing\n" + "CaitlinDiVA - Voice Acting\n" + "G4bo - Salvation Cutscene\n" + "Develop Art - Russian Translations\n" + "GWebDev - Chromatic Aberration Shader\n";
		if (FlxG.save.data.progressStoryClearHard)
			specialThanksText.text = "SPECIAL THANKS TO THE FOLLOWING\n" + " \n" + "Kade Dev - Kade Engine\n" + "Lexicord - Tetris Mami Icon\n" + "Shadow Mario - Color Swap Shader\n" + "JADS - ???\n" + "BoinkBonk - Bug Testing\n" + "CaitlinDiVA - Voice Acting\n" + "G4bo - Salvation Cutscene\n" + "Develop Art - Russian Translations\n" + "GWebDev - Chromatic Aberration Shader\n";
		if (FlxG.save.data.progressStoryClearTetris)
			specialThanksText.text = "SPECIAL THANKS TO THE FOLLOWING\n" + " \n" + "Kade Dev - Kade Engine\n" + "Lexicord - Tetris Mami Icon\n" + "Shadow Mario - Color Swap Shader\n" + "JADS - Expurgation Permission\n" + "BoinkBonk - Bug Testing\n" + "CaitlinDiVA - Voice Acting\n" + "G4bo - Salvation Cutscene\n" + "Develop Art - Russian Translations\n" + "GWebDev - Chromatic Aberration Shader\n";


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		onSpecial = false;

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P && !onSpecial)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P && !onSpecial)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new MainMenuState());
			}

			if (controls.RIGHT_P && !onSpecial)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					onSpecial = true;
					FlxTween.completeTweensOf(creditSpecialChange);
					creditSpecialChange.x += 50;
					FlxTween.tween(creditSpecialChange, {x: 160}, 0.15, {ease: FlxEase.quadOut});
					creditSpecialChange.text = "<- Press LEFT to view Main Team";
					updatepage();
				}

			if (controls.LEFT_P && onSpecial)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					onSpecial = false;
					FlxTween.completeTweensOf(creditSpecialChange);
					creditSpecialChange.x -= 50;
					FlxTween.tween(creditSpecialChange, {x: 120}, 0.15, {ease: FlxEase.quadOut});
					creditSpecialChange.text = "Press RIGHT to view Special Thanks ->";
					updatepage();
				}

			if (controls.ACCEPT && !onSpecial)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

					var daChoice:String = optionShit[curSelected];

					switch (daChoice)
					{
						case 'faderevampedtext':
							#if linux
							Sys.command('/usr/bin/xdg-open', ["https://twitter.com/FadeRevamped", "&"]);
							#else
							FlxG.openURL('https://twitter.com/FadeRevamped');
							#end
						case 'eggoverlordtext':
							#if linux
							Sys.command('/usr/bin/xdg-open', ["https://gamebanana.com/members/1891017", "&"]);
							#else
							FlxG.openURL('https://gamebanana.com/members/1891017');
							#end
						case 'theawfulusernametext':
							FlxG.openURL('https://www.youtube.com/channel/UCRnZRp-cIlnNfjmqxsk0dog');

							#if linux
							Sys.command('/usr/bin/xdg-open', ["https://www.youtube.com/channel/UCRnZRp-cIlnNfjmqxsk0dog", "&"]);
							#else
							FlxG.openURL('https://www.youtube.com/channel/UCRnZRp-cIlnNfjmqxsk0dog');
							#end
						case 'boinkbonktext':
							#if linux
							Sys.command('/usr/bin/xdg-open', ["https://twitter.com/BinkBoinkBonk", "&"]);
							#else
							FlxG.openURL('https://twitter.com/BinkBoinkBonk');
							#end
						case 'sectortext':
							#if linux
							Sys.command('/usr/bin/xdg-open', ["https://twitter.com/Sector0003", "&"]);
							#else
							FlxG.openURL('https://twitter.com/Sector0003');
							#end
						case 'vidztext':
							#if linux
							Sys.command('/usr/bin/xdg-open', ["https://twitter.com/ItsVidz3", "&"]);
							#else
							FlxG.openURL('https://twitter.com/ItsVidz3');
							#end
						case 'magbrostext':
							#if linux
							Sys.command('/usr/bin/xdg-open', ["https://gamebanana.com/members/1805209", "&"]);
							#else
							FlxG.openURL('https://gamebanana.com/members/1805209');
							#end
						case 'ascentitext':
							#if linux
							Sys.command('/usr/bin/xdg-open', ["https://gamebanana.com/members/", "&"]);
							#else
							FlxG.openURL('https://gamebanana.com/members/'); //idk it lol
							#end
						case 'kayotext':
							#if linux
							Sys.command('/usr/bin/xdg-open', ["https://twitter.com/zTam_", "&"]);
							#else
							FlxG.openURL('https://twitter.com/zTam_'); //idk it lol
							#end
						case 'cerberatext':
							#if linux
							Sys.command('/usr/bin/xdg-open', ["https://gamebanana.com/members/", "&"]);
							#else
							FlxG.openURL('https://gamebanana.com/members/'); //idk it lol
							#end
					}
				}
			}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;
		
		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});

		credicons.forEach(function(spr:FlxSprite)
			{
				spr.animation.play('idle');
				spr.alpha = 0;

				if (spr.ID == curSelected)
				{
					spr.animation.play('selected');
					spr.alpha = 1;
				}

				spr.updateHitbox();
			});

		switch (curSelected) //not the smartest way to do this but it works
		{
			case 0:
				creditRoleText.text = "Lead Director, Charter, Vocalist";
				creditNameText.text = "Fade Revamped";
			case 1:
				creditRoleText.text = "Co-Director, Publisher, Art";	
				creditNameText.text = "Egg Overlord";
			case 2:
				creditRoleText.text = "Co-Director, Vocalist, Advisor";
				creditNameText.text = "TheAwfulUsername";
			case 3:
				creditRoleText.text = "Animator";	
				creditNameText.text = "BoinkBonk";
			case 4:
				creditRoleText.text = "Lead Coder, General Quality Assurance, Charter";	
				creditNameText.text = "Sector";
			case 5:
				creditRoleText.text = "Coder";
				creditNameText.text = "Vidz";
			case 6:
				creditRoleText.text = "Musician";
				creditNameText.text = "Magbros";
			case 7:
				creditRoleText.text = "Connect Cutscene Animator";
				creditNameText.text = "Ascenti";
			case 8:
				creditRoleText.text = "Musician"; //fix offsets later or smth idk
				creditNameText.text = "Kayo";
			case 9:
				creditRoleText.text = "Charter";
				creditNameText.text = "Cerbera";
		}
	}

	function updatepage()
	{
		if (onSpecial)
			{
				creditRoleText.visible = false;
				menuItems.visible = false;
				creditNameText.visible = false;
				credicons.visible = false;
				specialThanksText.visible = true;
			}
		else
			{
				creditRoleText.visible = true;
				menuItems.visible = true;
				creditNameText.visible = true;
				credicons.visible = true;
				specialThanksText.visible = false;
			}
	}
}