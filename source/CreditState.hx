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
		'vidztext', //Vidz
		'sectortext', //Sector
		'magbrostext']; //Magbros
	#else
	var optionShit:Array<String> = [
		'Fade Revamped', //Fade Revamped
		'Egg Overlord', //Egg Overlord
		'TheAwfulUsername', //TheAwfulUsername
		'BoinkBonk', //BoinkBonk
		'Vidz', //Vidz
		'Sector', //Sector
		'Magbros']; //Magbros
	#end
	//ROLES
	#if !switch
	var credinfolist:Array<String> = [
		'Lead Director, Charter, Vocalist', //Fade Revamped
		'Co-Director, Publisher, Art', //Egg Overlord
		'Co-Director, Vocalist, Advisor', //TheAwfulUsername
		'Animator', //BoinkBonk
		'Coder', //Vidz
		'Coder, Art Quality Assurance, Charter', //Sector
		'Musician']; //Magbros
	#else
	var credinfolist:Array<String> = [
		'Lead Director, Charter, Vocalist', //Fade Revamped
		'Co-Director, Publisher, Art', //Egg Overlord
		'Co-Director, Vocalist, Advisor', //TheAwfulUsername
		'Animator', //BoinkBonk
		'Coder', //Vidz
		'Coder, Art QA', //Sector
		'Musician']; //Magbros
	#end
	//ICONS
	#if !switch
	var crediconlist:Array<String> = [
		'faderevampedicon', //Fade Revamped
		'eggoverlordicon', //Egg Overlord
		'theawfulusernameicon', //TheAwfulUsername
		'boinkbonkicon', //BoinkBonk
		'vidzicon', //Vidz
		'sectoricon', //Sector
		'magbrosicon']; //Magbros
	#else
	var crediconlist:Array<String> = [
		'faderevamped', //Fade Revamped
		'eggoverlord', //Egg Overlord
		'theawfulusername', //TheAwfulUsername
		'boinkbonk', //BoinkBonk
		'vidz', //Vidz
		'sector', //Sector
		'magbros']; //Magbros
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
			var menuItem:FlxSprite = new FlxSprite(-250, 150 + (i * 60));
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

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var tex = Paths.getSparrowAtlas('credits/icons');

		//ICONS
		credicons = new FlxTypedGroup<FlxSprite>();
		add(credicons);

		for (i in 0...crediconlist.length)
			{
				var crediticon:FlxSprite = new FlxSprite(650, 150);
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
		
		creditRoleText = new FlxText(680, 550, 420, "Lead Director, Charter, Vocalist", 38);
		creditRoleText.setFormat(Paths.font("vcr.ttf"), 38, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		creditRoleText.text = "Lead Director, Charter, Vocalist";
		creditRoleText.scrollFactor.set();
		add(creditRoleText);
	
		creditNameText = new FlxText(680, 100, 460, "Fade Revamped", 48);
		creditNameText.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		creditNameText.text = "Fade Revamped";
		creditNameText.scrollFactor.set();
		add(creditNameText);

		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

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
				FlxG.switchState(new MainMenuState());
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
				else
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));

						var daChoice:String = optionShit[curSelected];

						switch (daChoice)
						{
							case 'faderevampedtext':
								#if linux
								Sys.command('/usr/bin/xdg-open', ["https://gamebanana.com/members/1945012", "&"]);
								#else
								FlxG.openURL('https://gamebanana.com/members/1945012');
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
								Sys.command('/usr/bin/xdg-open', ["https://gamebanana.com/members/1784261", "&"]);
								#else
								FlxG.openURL('https://gamebanana.com/members/1784261');
								#end
							case 'vidztext':
								#if linux
								Sys.command('/usr/bin/xdg-open', ["https://twitter.com/ItsVidz3", "&"]);
								#else
								FlxG.openURL('https://twitter.com/ItsVidz3');
								#end
							case 'sectortext':
								#if linux
								Sys.command('/usr/bin/xdg-open', ["https://twitter.com/Sector0003", "&"]);
								#else
								FlxG.openURL('https://twitter.com/Sector0003');
								#end
							case 'magbrostext':
								#if linux
								Sys.command('/usr/bin/xdg-open', ["https://gamebanana.com/members/1805209", "&"]);
								#else
								FlxG.openURL('https://gamebanana.com/members/1805209');
								#end
					};
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
				creditRoleText.text = "Coder";
				creditNameText.text = "Vidz";
			case 5:
				creditRoleText.text = "Coder, Art QA";	
				creditNameText.text = "Sector";
			case 6:
				creditRoleText.text = "Musician";
				creditNameText.text = "Magbros";
		}
	}
}