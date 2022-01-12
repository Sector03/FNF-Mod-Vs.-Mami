package;

import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;
import llua.Convert;
import llua.Lua;
import llua.State;
import llua.LuaL;
import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.effects.FlxFlicker;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import openfl.filters.ColorMatrixFilter;

#if windows
import Discord.DiscordClient;
#end
#if desktop
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var deathCause:String = '';
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	public static var isDisco:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;
	private var lowhpmusic:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var notehealthdmg:Float = 0.00;
	private var maxhealth:Float = 1;
	private var healthcap:Float = 0;
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;
	public var scrollSpeedAddictive:Float = 0;
	public var deathByHolyNote:Bool = false;

	public var cameraZoomrate:Int = 4;

	public var debugCommandsText:FlxText;
	private var holyMisses:Float = 0.40;
	public var godmodecheat:Bool = false;
	public var allowBFanimupdate = true;

	public var songCleared = false;
	
	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camOVERLAY:FlxCamera;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	private var healthDrainIndicator:FlxSprite;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var dialoguePOST:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var weebGorl:FlxSprite;

	//subwayarea
	var gorls:FlxSprite;
	var holyHomura:FlxSprite;
	var connectLight:FlxSprite;
	var lampsLeft:FlxSprite;

	//salvation
	var blackOverlay:FlxSprite;
	var darknessOverlay:FlxSprite;

	var gunSwarm:FlxSprite;
	var gunSwarmBack:FlxBackdrop;
	var gunSwarmFront:FlxBackdrop;
	var thisBitchSnapped:Bool = false;
	var whiteBG:FlxSprite;

	var otherBGStuff:FlxSprite;
	var lampsSubway:FlxSprite;
	var stageFront:FlxSprite;

	//tetris
	var tetrisLight:FlxSprite;
	var colorCycle:Int = 0;

	var latched:Bool = false;

	var tetrisCrowd:FlxSprite;

	//mamigation

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	var tetrisZoom:Float = 0.00;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	public static var dadnoteMovementXoffset:Int = 0;
	public static var dadnoteMovementYoffset:Int = 0;

	public static var bfnoteMovementXoffset:Int = 0;
	public static var bfnoteMovementYoffset:Int = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;

	private var executeModchart = false;

	// LUA SHIT
		
	public static var lua:State = null;

	function callLua(func_name : String, args : Array<Dynamic>, ?type : String) : Dynamic
	{
		var result : Any = null;

		Lua.getglobal(lua, func_name);

		for( arg in args ) {
		Convert.toLua(lua, arg);
		}

		result = Lua.pcall(lua, args.length, 1, 0);

		if (getLuaErrorMessage(lua) != null)
			trace(func_name + ' LUA CALL ERROR ' + Lua.tostring(lua,result));

		if( result == null) {
			return null;
		} else {
			return convert(result, type);
		}

	}

	function getType(l, type):Any
	{
		return switch Lua.type(l,type) {
			case t if (t == Lua.LUA_TNIL): null;
			case t if (t == Lua.LUA_TNUMBER): Lua.tonumber(l, type);
			case t if (t == Lua.LUA_TSTRING): (Lua.tostring(l, type):String);
			case t if (t == Lua.LUA_TBOOLEAN): Lua.toboolean(l, type);
			case t: throw 'you don goofed up. lua type error ($t)';
		}
	}

	function getReturnValues(l) {
		var lua_v:Int;
		var v:Any = null;
		while((lua_v = Lua.gettop(l)) != 0) {
			var type:String = getType(l,lua_v);
			v = convert(lua_v, type);
			Lua.pop(l, 1);
		}
		return v;
	}


	private function convert(v : Any, type : String) : Dynamic { // I didn't write this lol
		if( Std.is(v, String) && type != null ) {
		var v : String = v;
		if( type.substr(0, 4) == 'array' ) {
			if( type.substr(4) == 'float' ) {
			var array : Array<String> = v.split(',');
			var array2 : Array<Float> = new Array();

			for( vars in array ) {
				array2.push(Std.parseFloat(vars));
			}

			return array2;
			} else if( type.substr(4) == 'int' ) {
			var array : Array<String> = v.split(',');
			var array2 : Array<Int> = new Array();

			for( vars in array ) {
				array2.push(Std.parseInt(vars));
			}

			return array2;
			} else {
			var array : Array<String> = v.split(',');
			return array;
			}
		} else if( type == 'float' ) {
			return Std.parseFloat(v);
		} else if( type == 'int' ) {
			return Std.parseInt(v);
		} else if( type == 'bool' ) {
			if( v == 'true' ) {
			return true;
			} else {
			return false;
			}
		} else {
			return v;
		}
		} else {
		return v;
		}
	}

	function getLuaErrorMessage(l) {
		var v:String = Lua.tostring(l, -1);
		Lua.pop(l, 1);
		return v;
	}

	public function setVar(var_name : String, object : Dynamic){
		// trace('setting variable ' + var_name + ' to ' + object);

		Lua.pushnumber(lua,object);
		Lua.setglobal(lua, var_name);
	}

	public function getVar(var_name : String, type : String) : Dynamic {
		var result : Any = null;

		// trace('getting variable ' + var_name + ' with a type of ' + type);

		Lua.getglobal(lua, var_name);
		result = Convert.fromLua(lua,-1);
		Lua.pop(lua,1);

		if( result == null ) {
		return null;
		} else {
		var result = convert(result, type);
		//trace(var_name + ' result: ' + result);
		return result;
		}
	}

	function getActorByName(id:String):Dynamic
	{
		// pre defined names
		switch(id)
		{
			case 'boyfriend':
				return boyfriend;
			case 'girlfriend':
				return gf;
			case 'dad':
				return dad;
		}
		// lua objects or what ever
		if (luaSprites.get(id) == null)
			return strumLineNotes.members[Std.parseInt(id)];
		return luaSprites.get(id);
	}

	public static var luaSprites:Map<String,FlxSprite> = [];



	function makeLuaSprite(spritePath:String,toBeCalled:String, drawBehind:Bool)
	{
		#if sys
		var data:BitmapData = BitmapData.fromFile(Sys.getCwd() + "assets/data/" + PlayState.SONG.song.toLowerCase() + '/' + spritePath + ".png");

		var sprite:FlxSprite = new FlxSprite(0,0);
		var imgWidth:Float = FlxG.width / data.width;
		var imgHeight:Float = FlxG.height / data.height;
		var scale:Float = imgWidth <= imgHeight ? imgWidth : imgHeight;

		// Cap the scale at x1
		if (scale > 1)
		{
			scale = 1;
		}

		sprite.makeGraphic(Std.int(data.width * scale),Std.int(data.width * scale),FlxColor.TRANSPARENT);

		var data2:BitmapData = sprite.pixels.clone();
		var matrix:Matrix = new Matrix();
		matrix.identity();
		matrix.scale(scale, scale);
		data2.fillRect(data2.rect, FlxColor.TRANSPARENT);
		data2.draw(data, matrix, null, null, null, true);
		sprite.pixels = data2;
		
		luaSprites.set(toBeCalled,sprite);
		// and I quote:
		// shitty layering but it works!
		if (drawBehind)
		{
			remove(gf);
			remove(boyfriend);
			remove(dad);
		}
		add(sprite);
		if (drawBehind)
		{
			add(gf);
			add(boyfriend);
			add(dad);
		}
		#end
		return toBeCalled;
	}

	// LUA SHIT

	override public function create()
	{

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		holyMisses = 0.40;
		notehealthdmg = 0;
		tetrisZoom = 0.00;
		scrollSpeedAddictive = 0;
		isDisco = false;
		thisBitchSnapped = false;
		cameraZoomrate = 4;
		setChrome(0.0);
		deathCause = '';

		songCleared = false;

		swagShader = new ColorSwap(); //shamelessly took this from psych engine, credits to shadowmario <3
		swagShader.hue = 0;

		dadnoteMovementXoffset = 0;
		dadnoteMovementYoffset = 0;

		bfnoteMovementXoffset = 0;
		bfnoteMovementYoffset = 0;

		#if sys
		executeModchart = FileSystem.exists(Paths.lua(PlayState.SONG.song.toLowerCase()  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
			case 3:
				storyDifficultyText = "Holy";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camOVERLAY = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOVERLAY.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camOVERLAY);

		FlxCamera.defaultCameras = [camGame];

		FlxG.camera.setFilters([]);

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale);
		
		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'connect':
				if (FlxG.save.data.langoEnglish)
					dialogue = CoolUtil.coolTextFile(Paths.txt('connect/ENG_connectdio'));
				else if (FlxG.save.data.langoRussian)
					dialogue = CoolUtil.coolTextFile(Paths.txt('connect/RUS_connectdio'));
			case 'reminisce':
				if (FlxG.save.data.langoEnglish)
					dialogue = CoolUtil.coolTextFile(Paths.txt('reminisce/ENG_reminiscedio'));
				else if (FlxG.save.data.langoRussian)
					dialogue = CoolUtil.coolTextFile(Paths.txt('reminisce/RUS_reminiscedio'));
			case 'salvation':
				if (FlxG.save.data.langoEnglish)
					{
					dialogue = CoolUtil.coolTextFile(Paths.txt('salvation/ENG_salvationdio'));
					dialoguePOST = CoolUtil.coolTextFile(Paths.txt('salvation/ENG_salvationdioPOST'));
					}
				else if (FlxG.save.data.langoRussian)
					{
					dialogue = CoolUtil.coolTextFile(Paths.txt('salvation/RUS_salvationdio'));
					dialoguePOST = CoolUtil.coolTextFile(Paths.txt('salvation/RUS_salvationdioPOST'));
					}
		}

		if (FlxG.save.data.noteSplash)
			{
					var preloadidk:FlxSprite = new FlxSprite(-500, -100).loadGraphic(Paths.image('noteSplashes', 'preload'));
					var preloadidk2:FlxSprite = new FlxSprite(-500, -100).loadGraphic(Paths.image('noteSplashes-alt', 'preload'));

					add(preloadidk);
					add(preloadidk2);

			}

		switch(SONG.song.toLowerCase())
		{
			case 'connect' | 'reminisce' | 'konnect':
				{
						defaultCamZoom = 0.7;
						curStage = 'subway';
						var bg:FlxSprite = new FlxSprite(-500, -500).loadGraphic(Paths.image('mami/BG/BGSky'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);

						var trainSubway:FlxSprite = new FlxSprite(-500, -100).loadGraphic(Paths.image('mami/BG/BGTrain', 'shared'));
						trainSubway.updateHitbox();
						trainSubway.antialiasing = true;
						trainSubway.scrollFactor.set(0.9, 0.9);
						trainSubway.active = false;
						add(trainSubway);

						stageFront = new FlxSprite(-500, 600).loadGraphic(Paths.image('mami/BG/BGFloor', 'shared'));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);

						lampsSubway = new FlxSprite(-500, -300).loadGraphic(Paths.image('mami/BG/BGLamps', 'shared'));
						lampsSubway.updateHitbox();
						lampsSubway.antialiasing = true;
						lampsSubway.scrollFactor.set(0.9, 0.9);
						lampsSubway.active = false;
						add(lampsSubway);

						lampsLeft = new FlxSprite(-500, -300).loadGraphic(Paths.image('mami/BG/BGLampLights', 'shared'));
						lampsLeft.updateHitbox();
						lampsLeft.antialiasing = true;
						lampsLeft.scrollFactor.set(0.9, 0.9);
						lampsLeft.active = false;

						weebGorl = new FlxSprite(1200, 0);
						weebGorl.frames = Paths.getSparrowAtlas('mami/BG/BGbackgirl', 'shared');
						weebGorl.animation.addByPrefix('move', "Symbol 6 instance 1", 24, false);
						weebGorl.antialiasing = true;
						weebGorl.scrollFactor.set(0.9, 0.9);
						weebGorl.updateHitbox();
						weebGorl.active = true;
						add(weebGorl);

						otherBGStuff = new FlxSprite(-530, -50).loadGraphic(Paths.image('mami/BG/BGRandomshit', 'shared'));
						otherBGStuff.updateHitbox();
						otherBGStuff.antialiasing = true;
						otherBGStuff.scrollFactor.set(0.9, 0.9);
						otherBGStuff.active = false;
						add(otherBGStuff);		
					
						gorls = new FlxSprite(-360, 150);
						gorls.frames = Paths.getSparrowAtlas('mami/BG/BGGirlsDance', 'shared');
						gorls.animation.addByPrefix('move', "girls dancing instance 1", 24, false);
						gorls.antialiasing = true;
						gorls.scrollFactor.set(0.9, 0.9);
						gorls.updateHitbox();
						gorls.active = true;
						add(gorls);

						connectLight = new FlxSprite(0, 0).loadGraphic(Paths.image('mami/BG/connect_flash', 'shared'));
						connectLight.setGraphicSize(Std.int(connectLight.width * 1));
						connectLight.updateHitbox();
						connectLight.antialiasing = true;
						connectLight.scrollFactor.set(0, 0);
						connectLight.active = false;
						connectLight.alpha = 0.0;
						connectLight.cameras = [camOVERLAY];
					}

			case 'tetris':
				{
						defaultCamZoom = 0.7;
						curStage = 'subway-tetris';
						var bg:FlxSprite = new FlxSprite(-500, -500).loadGraphic(Paths.image('mami/BG/BGSky'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						bg.shader = swagShader.shader;
						add(bg);

						var trainSubway:FlxSprite = new FlxSprite(-500, -100).loadGraphic(Paths.image('mami/BG/BGTrain', 'shared'));
						trainSubway.updateHitbox();
						trainSubway.antialiasing = true;
						trainSubway.scrollFactor.set(0.9, 0.9);
						trainSubway.active = false;
						trainSubway.shader = swagShader.shader;
						add(trainSubway);

						var stageFront:FlxSprite = new FlxSprite(-500, 600).loadGraphic(Paths.image('mami/BG/BGFloor', 'shared'));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						stageFront.shader = swagShader.shader;
						add(stageFront);

						var lampsSubway:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('mami/BG/BGLamps', 'shared'));
						lampsSubway.updateHitbox();
						lampsSubway.antialiasing = true;
						lampsSubway.scrollFactor.set(0.9, 0.9);
						lampsSubway.active = false;
						lampsSubway.shader = swagShader.shader;
						add(lampsSubway);

						lampsLeft = new FlxSprite(-500, -300).loadGraphic(Paths.image('mami/BG/BGLampLights', 'shared'));
						lampsLeft.updateHitbox();
						lampsLeft.antialiasing = true;
						lampsLeft.scrollFactor.set(0.9, 0.9);
						lampsLeft.active = false;

						var otherBGStuff:FlxSprite = new FlxSprite(-530, -50).loadGraphic(Paths.image('mami/BG/HOLY/HOLY_objects', 'shared'));
						otherBGStuff.updateHitbox();
						otherBGStuff.antialiasing = true;
						otherBGStuff.scrollFactor.set(0.9, 0.9);
						otherBGStuff.active = false;
						otherBGStuff.shader = swagShader.shader;
						add(otherBGStuff);				

						connectLight = new FlxSprite(0, 0).loadGraphic(Paths.image('mami/BG/connect_flash', 'shared'));
						connectLight.setGraphicSize(Std.int(connectLight.width * 1));
						connectLight.updateHitbox();
						connectLight.antialiasing = true;
						connectLight.scrollFactor.set(0, 0);
						connectLight.active = false;
						connectLight.alpha = 0.0;
						connectLight.cameras = [camOVERLAY];

						holyHomura = new FlxSprite(-360, 350);
						holyHomura.frames = Paths.getSparrowAtlas('mami/BG/HOLY/HOLY_women', 'shared');
						holyHomura.animation.addByPrefix('move', "animegirl", 24, false);
						holyHomura.antialiasing = true;
						holyHomura.scrollFactor.set(0.9, 0.9);
						holyHomura.updateHitbox();
						holyHomura.active = true;
						holyHomura.shader = swagShader.shader;
						add(holyHomura);

						tetrisCrowd = new FlxSprite(-60, 920);
						tetrisCrowd.frames = Paths.getSparrowAtlas('tetris/crowd', 'shared');
						tetrisCrowd.animation.addByPrefix('cheer', "crowd", 24, true);
						tetrisCrowd.setGraphicSize(Std.int(tetrisCrowd.width * 1));
						tetrisCrowd.antialiasing = true;
						tetrisCrowd.scrollFactor.set(1, 1);
						tetrisCrowd.updateHitbox();
						tetrisCrowd.active = true;
						tetrisCrowd.alpha = 1;
						tetrisCrowd.cameras = [camOVERLAY];
						tetrisCrowd.shader = swagShader.shader;
						add(tetrisCrowd);
						tetrisCrowd.animation.play('cheer', true);

						tetrisLight = new FlxSprite(0, 0);
						tetrisLight.frames = Paths.getSparrowAtlas('tetris/connect_flash', 'shared');
						tetrisLight.animation.addByPrefix('red', "RED instance 1", 24, true);
						tetrisLight.animation.addByPrefix('yellow', "YEL instance 1", 24, true);
						tetrisLight.animation.addByPrefix('blue', "BLU instance 1", 24, true);
						tetrisLight.animation.addByPrefix('green', "GRN instance 1", 24, true);
						tetrisLight.animation.addByPrefix('pink', "PNK instance 1", 24, true);
						tetrisLight.setGraphicSize(Std.int(tetrisLight.width * 1));
						tetrisLight.antialiasing = true;
						tetrisLight.scrollFactor.set(1, 1);
						tetrisLight.updateHitbox();
						tetrisLight.active = false;
						tetrisLight.alpha = 0.0;
						tetrisLight.cameras = [camOVERLAY];
						add(tetrisLight);
					}		
					
			case 'salvation': //added some shit cuz yes, Sector gaming B))
			{
					defaultCamZoom = 0.7;
					curStage = 'subway-holy';
					var bg:FlxSprite = new FlxSprite(-500, -500).loadGraphic(Paths.image('mami/BG/BGSky'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var trainSubway:FlxSprite = new FlxSprite(-500, -100).loadGraphic(Paths.image('mami/BG/BGTrain', 'shared'));
					trainSubway.updateHitbox();
					trainSubway.antialiasing = true;
					trainSubway.scrollFactor.set(0.9, 0.9);
					trainSubway.active = false;
					add(trainSubway);

					whiteBG = new FlxSprite(-480, -480).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
					whiteBG.updateHitbox();
					whiteBG.antialiasing = true;
					whiteBG.scrollFactor.set(0, 0);
					whiteBG.active = false;
					whiteBG.alpha = 0.0;
					add(whiteBG);

					gunSwarmBack = new FlxBackdrop(Paths.image('mami/BG/HOLY/HOLY_gunsbackconstant'), 1, 0, true, true);
					gunSwarmBack.scrollFactor.set(0.8, 0);
					add(gunSwarmBack);
					gunSwarmBack.velocity.set(-8500, 1500);
					gunSwarmBack.alpha = 0.0;

					stageFront = new FlxSprite(-500, 600).loadGraphic(Paths.image('mami/BG/HOLY/HOLY_floor', 'shared'));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					lampsSubway = new FlxSprite(-500, -300).loadGraphic(Paths.image('mami/BG/BGLamps', 'shared'));
					lampsSubway.updateHitbox();
					lampsSubway.antialiasing = true;
					lampsSubway.scrollFactor.set(0.9, 0.9);
					lampsSubway.active = false;
					add(lampsSubway);

					lampsLeft = new FlxSprite(-500, -300).loadGraphic(Paths.image('mami/BG/HOLY/HOLY_BGLampLights', 'shared'));
					lampsLeft.updateHitbox();
					lampsLeft.antialiasing = true;
					lampsLeft.scrollFactor.set(0.9, 0.9);
					lampsLeft.active = false;

					otherBGStuff = new FlxSprite(-530, -50).loadGraphic(Paths.image('mami/BG/HOLY/HOLY_objects', 'shared'));
					otherBGStuff.updateHitbox();
					otherBGStuff.antialiasing = true;
					otherBGStuff.scrollFactor.set(0.9, 0.9);
					otherBGStuff.active = false;
					add(otherBGStuff);				

					holyHomura = new FlxSprite(-360, 350);
					holyHomura.frames = Paths.getSparrowAtlas('mami/BG/HOLY/HOLY_women', 'shared');
					holyHomura.animation.addByPrefix('move', "animegirl", 24, false);
					holyHomura.antialiasing = true;
					holyHomura.scrollFactor.set(0.9, 0.9);
					holyHomura.updateHitbox();
					holyHomura.active = true;
					add(holyHomura);

					gunSwarm = new FlxSprite(-1000, 0).loadGraphic(Paths.image('mami/BG/HOLY/HOLY_guns', 'shared'));
					gunSwarm.setGraphicSize(Std.int(gunSwarm.width * 1));
					gunSwarm.antialiasing = true;
					gunSwarm.scrollFactor.set(0.9, 0.9);
					gunSwarm.updateHitbox();
					gunSwarm.active = true;

					gunSwarmFront = new FlxBackdrop(Paths.image('mami/BG/HOLY/HOLY_gunsfrontconstant'), 1, 0, true, true);
					gunSwarmFront.scrollFactor.set(1.1, 0);

					darknessOverlay = new FlxSprite(-480, -480).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), 0xFF21102b);
					darknessOverlay.updateHitbox();
					darknessOverlay.antialiasing = true;
					darknessOverlay.scrollFactor.set(0, 0);
					darknessOverlay.active = false;
					darknessOverlay.alpha = 0.5;
					//darknessOverlay.cameras = [camOVERLAY];
					//darknessOverlay.blend = MULTIPLY;

					blackOverlay = new FlxSprite(-480, -480).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					blackOverlay.updateHitbox();
					blackOverlay.antialiasing = true;
					blackOverlay.scrollFactor.set(0, 0);
					blackOverlay.active = false;
					blackOverlay.alpha = 1;
					//darknessOverlay.cameras = [camOVERLAY];
				}

			case 'mamigation': //added some shit cuz yes, Sector gaming B))
			{
					defaultCamZoom = 0.75;
					curStage = 'mamigation';
					var bg:FlxSprite = new FlxSprite(-500, -250).loadGraphic(Paths.image('mami/BG/MAMIGATION/BGSky', 'shared'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var placeholder:FlxSprite = new FlxSprite(-650, -250).loadGraphic(Paths.image('mami/BG/MAMIGATION/placeholder', 'shared'));
					placeholder.updateHitbox();
					placeholder.antialiasing = true;
					placeholder.scrollFactor.set(0.9, 0.9);
					placeholder.active = false;
					add(placeholder);
				}

			default:
			{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
			}
		}
		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
		}

		if (curStage == 'limo')
			gfVersion = 'gf-car';

		if (curStage == 'subway-holy')
			gfVersion = 'gf-holy';

		if (curStage == 'subway-tetris')
			gfVersion = 'gf-holy'; //gf-tetris? 🤔🤔

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case 'dad':
				camPos.x += 400;
			case 'mami':
				dad.x -= 75;
			case 'mami-tetris':
				dad.x -= 75;
			case 'mami-holy':
				dad.x -= 350;
				dad.y += 15;
			case 'mami-holypostsnap':
				dad.x -= 350;
				dad.y += 15;
			case 'mami-mamigation':
				dad.x -= 500;
				dad.y -= 450;
				FlxTween.tween(dad, {y: dad.y - 60}, 3, {type: FlxTweenType.PINGPONG, ease: FlxEase.quadInOut});
				dad.setGraphicSize(Std.int(dad.width * .6));
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		if (curStage == 'subway-tetris')
			{
			gf.shader = swagShader.shader;
			dad.shader = swagShader.shader;
			boyfriend.shader = swagShader.shader;
			}

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'subway':
				boyfriend.x += 80;
				boyfriend.y += 40;

			case 'subway-tetris':
				boyfriend.x += 80;
				boyfriend.y += 40;

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

			case 'subway-holy':
				boyfriend.x += 120;
				boyfriend.y += 40;
				gf.y -= 50;

			case 'mamigation':
				boyfriend.y += 40;

				//var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				//add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);
		}

		add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);
		add(boyfriend);

		if (curStage == 'subway')
			{
			add(lampsLeft);

			add(connectLight);
			}

		if (curStage == 'subway-tetris')
			{
			add(lampsLeft);

			add(tetrisCrowd);
			add(tetrisLight);
			tetrisCrowd.animation.play('cheer', true);
			}

		if (curStage == 'subway-holy')
			{
			add(lampsLeft);
			
			//add(gunSwarm);

			add(gunSwarmFront);
			gunSwarmFront.velocity.set(8500, -1500);
			gunSwarmFront.alpha = 0.0;

			add(darknessOverlay);

			add(blackOverlay);
			}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		
		Conductor.songPosition = -5000;


		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.YELLOW);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.88).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		if (SONG.player2 == "mami" || SONG.player2 == "mami-tetris")
			healthBar.createFilledBar(0xFFFFF6B3, 0xFF36A1BC);
		else if (SONG.player2 == "mami-holy")
			healthBar.createFilledBar(0xFFFDFFCF, 0xFF36A1BC);
		else if (SONG.player2 == "mami-mamigation")
			healthBar.createFilledBar(0xFFFF3027, 0xFF36A1BC);
		else
			healthBar.createFilledBar(0xFF969696, 0xFF36A1BC);
		// healthBar
		add(healthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 46,0,SONG.song + " " + (storyDifficulty == 3 ? "[Holy]" :storyDifficulty == 2 ? "[Hard]" : storyDifficulty == 1 ? "[Normal]" : "[Easy]") + " [v1.03]", 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 335, healthBarBG.y + 45, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		if (offsetTesting)
			scoreTxt.x += 300;

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
			{
				add(replayTxt);
			}

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		add(scoreTxt);

		if (SONG.player2 == 'mami-tetris')
			{	
			iconP2.setGraphicSize(Std.int(.77));
			iconP2.y += 35;
			}

		#if debug
		debugCommandsText = new FlxText(4, 4, 320, "DEBUG COMMANDS\n" + "N - Gain Health\n" + "M - Drain Health\n" + "B - Hit Holy Note\n" + "G - Toggle God Mode\n" + "T - Lower Scroll Speed\n" + "Y - Raise Scroll Speed\n" + "V - Hide Debug Menu\n");
		debugCommandsText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		debugCommandsText.scrollFactor.set();
		debugCommandsText.cameras = [camHUD];
		debugCommandsText.visible = true;
		
		add(debugCommandsText);
		#end

		healthDrainIndicator = new FlxSprite(iconP1.x + 40, iconP1.y + 80).loadGraphic(Paths.image('healthdrainindicator'));
		add(healthDrainIndicator);
		healthDrainIndicator.setGraphicSize(Std.int(healthDrainIndicator.width * 1.5));
		healthDrainIndicator.alpha = 0.0;
		FlxTween.tween(healthDrainIndicator, {y: (iconP1.y + 100) - 10}, 1, {type: FlxTweenType.PINGPONG, ease: FlxEase.quadInOut});

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		healthDrainIndicator.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camOVERLAY];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		if (curSong == 'Mamigation' || curSong == 'Salvation')
			{
				camHUD.alpha = 0.0;
			}

		new FlxTimer().start(1.15, function(tmr:FlxTimer)
			{
				if (healthBar.percent < 20 && !paused)
					{
					FlxTween.color(healthBar, 1, 0xffff8f8f, FlxColor.WHITE, {ease: FlxEase.quartOut});
					FlxTween.color(iconP1, 1, 0xffff8f8f, FlxColor.WHITE, {ease: FlxEase.quartOut});
					FlxTween.color(iconP2, 1, 0xffff8f8f, FlxColor.WHITE, {ease: FlxEase.quartOut});
					}
			}, 0);

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'connect':
					schoolIntro(doof);
				case 'reminisce':
					schoolIntro(doof);
				case 'salvation':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		black.cameras = [camHUD];
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.01;

			if (black.alpha > 0)
			{
				tmr.reset(0.01);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function salvationIntro(?dialogueBox:DialogueBox):Void
		{
			songCleared = true;
			inCutscene = true;
			generatedMusic = false;
			canPause = false;
			camZooming = false;

			vocals.stop();
			vocals.volume = 0;

			FlxG.sound.music.stop();
			FlxG.sound.music.volume = 0;

			lowhpmusic.stop();
			lowhpmusic.volume = 0;

			var senpaiEvil:FlxSprite = new FlxSprite();
			senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
			senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
			senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
			senpaiEvil.scrollFactor.set();
			senpaiEvil.updateHitbox();
			senpaiEvil.screenCenter();

			camHUD.alpha = 0.0;

			var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
			red.scrollFactor.set();

			var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			black.scrollFactor.set();
			black.cameras = [camHUD];
			add(black);
	
			new FlxTimer().start(0.3, function(tmr:FlxTimer)
			{
				black.alpha = 1.0;
	
				if (black.alpha == 0)
				{
					tmr.reset(0.01);
				}
				else
				{
					if (dialogueBox != null)
					{
						inCutscene = true;
	
						if (SONG.song.toLowerCase() == 'thorns')
						{
							add(senpaiEvil);
							senpaiEvil.alpha = 0;
							new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
							{
								senpaiEvil.alpha += 0.15;
								if (senpaiEvil.alpha < 1)
								{
									swagTimer.reset();
								}
								else
								{
									senpaiEvil.animation.play('idle');
									FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
									{
										remove(senpaiEvil);
										remove(red);
										FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
										{
											add(dialogueBox);
										}, true);
									});
									new FlxTimer().start(3.2, function(deadTime:FlxTimer)
									{
										FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
									});
								}
							});
						}
						else
						{
							add(dialogueBox);
						}
					}
	
					remove(black);
				}
			});
		}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);


		if (executeModchart) // dude I hate lua (jkjkjkjk)
			{
				trace('opening a lua state (because we are cool :))');
				lua = LuaL.newstate();
				LuaL.openlibs(lua);
				trace("Lua version: " + Lua.version());
				trace("LuaJIT version: " + Lua.versionJIT());
				Lua.init_callbacks(lua);
				
				var result = LuaL.dofile(lua, Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart")); // execute le file
	
				if (result != 0)
					trace('COMPILE ERROR\n' + getLuaErrorMessage(lua));

				// get some fukin globals up in here bois
	
				setVar("bpm", Conductor.bpm);
				setVar("fpsCap", FlxG.save.data.fpsCap);
				setVar("downscroll", FlxG.save.data.downscroll);
	
				setVar("curStep", 0);
				setVar("curBeat", 0);
	
				setVar("hudZoom", camHUD.zoom);
				setVar("cameraZoom", FlxG.camera.zoom);
	
				setVar("cameraAngle", FlxG.camera.angle);
				setVar("camHudAngle", camHUD.angle);
	
				setVar("followXOffset",0);
				setVar("followYOffset",0);
	
				setVar("showOnlyStrums", false);
				setVar("strumLine1Visible", true);
				setVar("strumLine2Visible", true);
	
				setVar("screenWidth",FlxG.width);
				setVar("screenHeight",FlxG.height);
				setVar("hudWidth", camHUD.width);
				setVar("hudHeight", camHUD.height);
	
				// callbacks
	
				// sprites
	
				trace(Lua_helper.add_callback(lua,"makeSprite", makeLuaSprite));
	
				Lua_helper.add_callback(lua,"destroySprite", function(id:String) {
					var sprite = luaSprites.get(id);
					if (sprite == null)
						return false;
					remove(sprite);
					return true;
				});
	
				// hud/camera
	
				trace(Lua_helper.add_callback(lua,"setHudPosition", function (x:Int, y:Int) {
					camHUD.x = x;
					camHUD.y = y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getHudX", function () {
					return camHUD.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getHudY", function () {
					return camHUD.y;
				}));
				
				trace(Lua_helper.add_callback(lua,"setCamPosition", function (x:Int, y:Int) {
					FlxG.camera.x = x;
					FlxG.camera.y = y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getCameraX", function () {
					return FlxG.camera.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getCameraY", function () {
					return FlxG.camera.y;
				}));
	
				trace(Lua_helper.add_callback(lua,"setCamZoom", function(zoomAmount:Int) {
					FlxG.camera.zoom = zoomAmount;
				}));
	
				trace(Lua_helper.add_callback(lua,"setHudZoom", function(zoomAmount:Int) {
					camHUD.zoom = zoomAmount;
				}));
	
				// actors
				
				trace(Lua_helper.add_callback(lua,"getRenderedNotes", function() {
					return notes.length;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteX", function(id:Int) {
					return notes.members[id].x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteY", function(id:Int) {
					return notes.members[id].y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteScaleX", function(id:Int) {
					return notes.members[id].scale.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteScaleY", function(id:Int) {
					return notes.members[id].scale.y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteAlpha", function(id:Int) {
					return notes.members[id].alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNotePos", function(x:Int,y:Int, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].x = x;
					notes.members[id].y = y;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteAlpha", function(alpha:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].alpha = alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteScale", function(scale:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].setGraphicSize(Std.int(notes.members[id].width * scale));
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteScaleX", function(scale:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].scale.x = scale;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteScaleY", function(scale:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].scale.y = scale;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorX", function(x:Int,id:String) {
					getActorByName(id).x = x;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorAlpha", function(alpha:Int,id:String) {
					getActorByName(id).alpha = alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorY", function(y:Int,id:String) {
					getActorByName(id).y = y;
				}));
							
				trace(Lua_helper.add_callback(lua,"setActorAngle", function(angle:Int,id:String) {
					getActorByName(id).angle = angle;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorScale", function(scale:Float,id:String) {
					getActorByName(id).setGraphicSize(Std.int(getActorByName(id).width * scale));
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorScaleX", function(scale:Float,id:String) {
					getActorByName(id).scale.x = scale;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorScaleY", function(scale:Float,id:String) {
					getActorByName(id).scale.y = scale;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorWidth", function (id:String) {
					return getActorByName(id).width;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorHeight", function (id:String) {
					return getActorByName(id).height;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorAlpha", function(id:String) {
					return getActorByName(id).alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorAngle", function(id:String) {
					return getActorByName(id).angle;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorX", function (id:String) {
					return getActorByName(id).x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorY", function (id:String) {
					return getActorByName(id).y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorScaleX", function (id:String) {
					return getActorByName(id).scale.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorScaleY", function (id:String) {
					return getActorByName(id).scale.y;
				}));
	
				// tweens
				
				Lua_helper.add_callback(lua,"tweenPos", function(id:String, toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, y: toY}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosXAngle", function(id:String, toX:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosYAngle", function(id:String, toY:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {y: toY, angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenAngle", function(id:String, toAngle:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenFadeIn", function(id:String, toAlpha:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {ease: FlxEase.circIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenFadeOut", function(id:String, toAlpha:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {ease: FlxEase.circOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				for (i in 0...strumLineNotes.length) {
					var member = strumLineNotes.members[i];
					trace(strumLineNotes.members[i].x + " " + strumLineNotes.members[i].y + " " + strumLineNotes.members[i].angle + " | strum" + i);
					//setVar("strum" + i + "X", Math.floor(member.x));
					setVar("defaultStrum" + i + "X", Math.floor(member.x));
					//setVar("strum" + i + "Y", Math.floor(member.y));
					setVar("defaultStrum" + i + "Y", Math.floor(member.y));
					//setVar("strum" + i + "Angle", Math.floor(member.angle));
					setVar("defaultStrum" + i + "Angle", Math.floor(member.angle));
					trace("Adding strum" + i);
				}
	
				trace('calling start function');
	
				trace('return: ' + Lua.tostring(lua,callLua('start', [PlayState.SONG.song])));
			}

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			if (allowBFanimupdate)
				boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			if (curSong == 'Mamigation' || curSong == 'Salvation')
				{
					swagCounter = 4;
				}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			if (FlxG.save.data.copyrightedMusic && curSong == 'Connect')
				FlxG.sound.playMusic(Paths.instcr(PlayState.SONG.song), 1, false);
			else
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = stopSong;
		vocals.play();
		lowhpmusic.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, 0xFFFFF6B3);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		lowhpmusic = new FlxSound().loadEmbedded(Paths.lowhpmusic(PlayState.SONG.song));
		FlxG.sound.list.add(lowhpmusic);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if desktop
			var songPath = 'assets/data/' + PlayState.SONG.song.toLowerCase() + '/';
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);
			var playerNotes:Array<Int> = [0, 1, 2, 3, 8, 9, 10, 11];

			for (songNotes in section.sectionNotes)
				{
					var daStrumTime:Float = songNotes[0];
					var daNoteData:Int = Std.int(songNotes[1]);
	
					var gottaHitNote:Bool = section.mustHitSection;
	
					if (!playerNotes.contains(songNotes[1]))
					{
						gottaHitNote = !section.mustHitSection;
					}
	
					var oldNote:Note;
					if (unspawnNotes.length > 0)
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					else
						oldNote = null;
	
					var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
					swagNote.sustainLength = songNotes[2];
					swagNote.scrollFactor.set(0, 0);
	
					var susLength:Float = swagNote.sustainLength;
	
					susLength = susLength / Conductor.stepCrochet;
					unspawnNotes.push(swagNote);
	
					for (susNote in 0...Math.floor(susLength))
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
	
						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);
	
						sustainNote.mustPress = gottaHitNote;
	
						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
					}
	
					swagNote.mustPress = gottaHitNote;
	
					if (swagNote.mustPress)
					{
						swagNote.x += FlxG.width / 2; // general offset
					}
					else
					{
					}
				}
				daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				case 'subway-tetris':
					if(FlxG.save.data.arrowColorCustom)
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets_tetris'); //make alt version later
					else
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets_tetris');

					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}

				default:
					if(FlxG.save.data.arrowColorCustom)
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-alt');
					else
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');

					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
				lowhpmusic.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
				resyncLowhpmusic();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	function resyncLowhpmusic():Void
		{
			lowhpmusic.pause();
	
			lowhpmusic.time = Conductor.songPosition;
			lowhpmusic.play();
		}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}


	function generateRanking():String
	{
		var ranking:String = "N/A";

		if (misses == 0 && bads == 0 && shits == 0 && goods == 0) // Marvelous (SICK) Full Combo
			ranking = "(MFC)";
		else if (misses == 0 && bads == 0 && shits == 0 && goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
			ranking = "(GFC)";
		else if (misses == 0) // Regular FC
			ranking = "(FC)";
		else if (misses < 10) // Single Digit Combo Breaks
			ranking = "(SDCB)";
		else
			ranking = "(Clear)";

		// WIFE TIME :)))) (based on Wife3)

		var wifeConditions:Array<Bool> = [
			accuracy >= 99.9935, // AAAAA
			accuracy >= 99.980, // AAAA:
			accuracy >= 99.970, // AAAA.
			accuracy >= 99.955, // AAAA
			accuracy >= 99.90, // AAA:
			accuracy >= 99.80, // AAA.
			accuracy >= 99.70, // AAA
			accuracy >= 99, // AA:
			accuracy >= 96.50, // AA.
			accuracy >= 93, // AA
			accuracy >= 90, // A:
			accuracy >= 85, // A.
			accuracy >= 80, // A
			accuracy >= 70, // B
			accuracy >= 60, // C
			accuracy < 60 // D
		];

		for(i in 0...wifeConditions.length)
		{
			var b = wifeConditions[i];
			if (b)
			{
				switch(i)
				{
					case 0:
						ranking += " AAAAA";
					case 1:
						ranking += " AAAA:";
					case 2:
						ranking += " AAAA.";
					case 3:
						ranking += " AAAA";
					case 4:
						ranking += " AAA:";
					case 5:
						ranking += " AAA.";
					case 6:
						ranking += " AAA";
					case 7:
						ranking += " AA:";
					case 8:
						ranking += " AA.";
					case 9:
						ranking += " AA";
					case 10:
						ranking += " A:";
					case 11:
						ranking += " A.";
					case 12:
						ranking += " A";
					case 13:
						ranking += " B";
					case 14:
						ranking += " C";
					case 15:
						ranking += " D";
				}
				break;
			}
		}

		if (accuracy == 0)
			ranking = "N/A";

		return ranking;
	}

	public static var songRate = 1.5;

	var swagShader:ColorSwap = null;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (executeModchart && lua != null && songStarted)
		{
			setVar('songPos',Conductor.songPosition);
			setVar('hudZoom', camHUD.zoom);
			setVar('cameraZoom',FlxG.camera.zoom);
			callLua('update', [elapsed]);

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = getVar("strum" + i + "X", "float");
				member.y = getVar("strum" + i + "Y", "float");
				member.angle = getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = getVar('cameraAngle', 'float');
			camHUD.angle = getVar('camHudAngle','float');

			if (getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = getVar("strumLine1Visible",'bool');
			var p2 = getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		if (currentFrames == FlxG.save.data.fpsCap)
		{
			for(i in 0...notesHitArray.length)
			{
				var cock:Date = notesHitArray[i];
				if (cock != null)
					if (cock.getTime() + 2000 < Date.now().getTime())
						notesHitArray.remove(cock);
			}
			nps = Math.floor(notesHitArray.length / 2);
			currentFrames = 0;
		}
		else
			currentFrames++;

		if (FlxG.keys.justPressed.NINE)
			{
				if (iconP1.animation.curAnim.name == 'bf-old')
					iconP1.animation.play(SONG.player1);
				else
					iconP1.animation.play('bf-old');
			}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		if (curSong == 'Tetris') 
			{
				if (tetrisLight.alpha >= 0.05)
				tetrisLight.alpha -= .015;
			}

		super.update(elapsed);

		if (!offsetTesting)
		{
			if (FlxG.save.data.accuracyDisplay)
			{
				if (curSong == 'Salvation')
					scoreTxt.text = (FlxG.save.data.npsDisplay ? "NPS: " + nps + " | " : "") + "Score:" + (Conductor.safeFrames != 10 ? songScore + " (" + songScoreDef + ")" : "" + songScore) + " | Holy Power:" + (holyMisses * 50) + "% | Combo Breaks:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% | " + generateRanking();
				else
					scoreTxt.text = (FlxG.save.data.npsDisplay ? "NPS: " + nps + " | " : "") + "Score:" + (Conductor.safeFrames != 10 ? songScore + " (" + songScoreDef + ")" : "" + songScore) + " | Combo Breaks:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% | " + generateRanking();
			}
			else
			{
				scoreTxt.text = (FlxG.save.data.npsDisplay ? "NPS: " + nps + " | " : "") + "Score:" + songScore;
			}
		}
		else
		{
			scoreTxt.text = "Suggested Offset: " + offsetTest;

		}
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			if (lua != null)
			{
				Lua.close(lua);
				lua = null;
			}
		}

		
		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.width, 150, 0.25)));

		if (SONG.player2 != 'mami-tetris')
			{	
			iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP1.width, 150, 0.25)));
			}
		else
			{
			iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP1.width - 50, 100, 0.25)));
			}

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		healthDrainIndicator.x = iconP1.x + 110;
		
		if (SONG.player2 != 'mami-tetris')
			{	
				iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
			}
		else
			{
				iconP2.x = (healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset)) - 24;
			}

		if (health > maxhealth)
			health = maxhealth;

		if (health < -0.1)
			health = 0;

		maxhealth = 2 - healthcap;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else if (healthBar.percent > 80)
			iconP1.animation.curAnim.curFrame = 2;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (SONG.player2 != 'mami-tetris'){	
			if (healthBar.percent > 80)
				iconP2.animation.curAnim.curFrame = 1;
			else if (healthBar.percent < 20)
				iconP2.animation.curAnim.curFrame = 2;
			else
				iconP2.animation.curAnim.curFrame = 0;
		}

		//anim 0 = normal, anim 1 = defeat, anim 2 = winning

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		if (curSong == 'Salvation' && !songCleared && curBeat >= 878)
			{
				camHUD.alpha -= 0.0015;
			}

		if (curSong == 'Salvation' && !songCleared && curBeat >= 878 && curBeat <= 896)
			{
				dad.playAnim('singUP', true);
			}

		if (curSong == 'Salvation' && !songCleared)
			{
				if (health <= 1)
					{
					FlxG.sound.music.volume = health;
					lowhpmusic.volume = 1 - health;
					}
				else
					{
					FlxG.sound.music.volume = 1;
					lowhpmusic.volume = 0;
					}

				var chromeOffset:Float = ((2 - ((health / 0.5))));
				chromeOffset /= 350;
				if (chromeOffset <= 0)
					setChrome(0.0);
				else
					{
					setChrome(chromeOffset);
					}	
			}

		if (curSong == 'Mamigation')
			{
				var chromeOffset:Float = ((2 - ((health / 0.5))));
				chromeOffset /= 600;
				if (chromeOffset <= 0)
					setChrome(0.0);
				else
					{
					setChrome(chromeOffset);
					}	
			}	

		if (FlxG.keys.pressed.R)
			if (FlxG.save.data.resetButton)
				health -= 2;

		#if debug
		//AWESOME OVERHAULED DEBUG COMMANDS :D

		// health changer cheat debug
		if (FlxG.keys.pressed.N)
			health += 0.02;

		if (FlxG.keys.pressed.M)
			health -= 0.02;

		if (FlxG.keys.justPressed.B)
			holyNoteHit();

		//god mode
		if (FlxG.keys.justPressed.G)
			godmodecheat = !godmodecheat;

		if (FlxG.keys.pressed.T)
			scrollSpeedAddictive -= 0.01;
			//trace(scrollSpeedAddictive);

		if (FlxG.keys.pressed.Y)
			scrollSpeedAddictive += 0.01;
			//trace(scrollSpeedAddictive);

		if (FlxG.keys.pressed.N || FlxG.keys.pressed.M || FlxG.keys.justPressed.B || FlxG.keys.justPressed.G || FlxG.keys.pressed.T || FlxG.keys.pressed.Y)
			kadeEngineWatermark.color = FlxColor.YELLOW;

		if (FlxG.keys.justPressed.F)
			ribbongrab(65, 7);

		if (FlxG.keys.justPressed.V) //why the fuck doesn't it come backbruh
			{
				if (debugCommandsText.visible = true)
					debugCommandsText.visible = false;
				else if (!debugCommandsText.visible)
					debugCommandsText.visible = true;
			}

		if (FlxG.keys.justPressed.SPACE)
			{
				thisBitchSnapped = !thisBitchSnapped;
			}

		if(FlxG.keys.justPressed.TWO) //also from shadowmario, really neat debug for skipping parts of a song
			{
			FlxG.sound.music.pause();
			vocals.pause();
			lowhpmusic.pause();
			Conductor.songPosition += 10000;
			notes.forEachAlive(function(daNote:Note)
			{
				if(daNote.strumTime + 800 < Conductor.songPosition) {
					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
			for (i in 0...unspawnNotes.length) {
				var daNote:Note = unspawnNotes[0];
				if(daNote.strumTime + 800 >= Conductor.songPosition) {
					break;
				}

				daNote.active = false;
				daNote.visible = false;

				daNote.kill();
				unspawnNotes.splice(unspawnNotes.indexOf(daNote), 1);
				daNote.destroy();
			}

			FlxG.sound.music.time = Conductor.songPosition;
			FlxG.sound.music.play();

			vocals.time = Conductor.songPosition;
			vocals.play();

			lowhpmusic.time = Conductor.songPosition;
			lowhpmusic.play();
		}


		#end

		if (!latched && camHUD.angle >= -0.005)
			camHUD.angle /= 1.25;
		else if (camHUD.angle <= -0.005)
			camHUD.angle = 0;

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(new AnimationDebug(SONG.player2));
			if (lua != null)
			{
				Lua.close(lua);
				lua = null;
			}
		}
		
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			if (camFollow.x != dad.getMidpoint().x + 150 + dadnoteMovementXoffset && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				if (FlxG.save.data.reducedMotion)
				camFollow.setPosition(dad.getMidpoint().x + 150 + (lua != null ? getVar("followXOffset", "float") : 0), dad.getMidpoint().y - 100 + (lua != null ? getVar("followYOffset", "float") : 0));
				else
					camFollow.setPosition(dad.getMidpoint().x + 150 + dadnoteMovementXoffset + (lua != null ? getVar("followXOffset", "float") : 0), dad.getMidpoint().y - 100 + dadnoteMovementYoffset + (lua != null ? getVar("followYOffset", "float") : 0));
				
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				if (FlxG.save.data.reducedMotion)
					camFollow.setPosition(boyfriend.getMidpoint().x - 100 + (lua != null ? getVar("followXOffset", "float") : 0), boyfriend.getMidpoint().y - 100 + (lua != null ? getVar("followYOffset", "float") : 0));
				else
					camFollow.setPosition(boyfriend.getMidpoint().x - 100 + bfnoteMovementXoffset + (lua != null ? getVar("followXOffset", "float") : 0), boyfriend.getMidpoint().y - 100 + bfnoteMovementYoffset + (lua != null ? getVar("followYOffset", "float") : 0));

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;

				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
		if (loadRep) // rep debug
			{
				FlxG.watch.addQuick('rep rpesses',repPresses);
				FlxG.watch.addQuick('rep releases',repReleases);
				// FlxG.watch.addQuick('Queued',inputsQueued);
			}

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0 && godmodecheat == false && !songCleared)
		{
			setChrome(0.0);
			if (deathByHolyNote && FlxG.save.data.flashingLights)
				{
					deathCause = 'holynote';
					FlxG.camera.flash(FlxColor.RED, 1.5);
				}

			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();
			lowhpmusic.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(),"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	
					if (daNote.y > FlxG.height)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}
	
						if (notehealthdmg >= 0.01)
							{
							healthDrainIndicator.alpha = 1.0;
							healthDrainIndicator.visible = true;
							}

						if (curSong == 'Connect' && storyDifficulty == 3)
							{
								notehealthdmg = 0.015;

								if (health > 0.05)
									if (daNote.isSustainNote)
										{
											health -= notehealthdmg / 4;
										}
									else
										{
											health -= notehealthdmg;
										}
							}

						if (curSong == 'Reminisce' && storyDifficulty == 3)
							{
								notehealthdmg = 0.02;

								if (health > 0.05)
									if (daNote.isSustainNote)
										{
											health -= notehealthdmg / 4;
										}
									else
										{
											health -= notehealthdmg;
										}
							}

						if (curSong == 'Salvation')
							{
								if (health > 0.05)
									if (daNote.isSustainNote)
										{
											health -= notehealthdmg / 4;
										}
									else
										{
											health -= notehealthdmg;
										}
							}

						if (curSong == 'Tetris')
							{
								if (daNote.isSustainNote)
									{
										health -= notehealthdmg / 4;
									}
								else
									{
										health -= notehealthdmg;
									}

								if (!FlxG.save.data.reducedMotion)
									camHUD.shake((notehealthdmg / 7.5), 0.25);
							}

						if (curSong == 'Mamigation')
							{
								notehealthdmg = 0.010;

								if (health > 0.2)
									if (daNote.isSustainNote)
										{
											health -= notehealthdmg / 2;
										}
									else
										{
											health -= notehealthdmg;
										}
		
								if (!FlxG.save.data.reducedMotion)
									camHUD.shake((notehealthdmg / 15), 0.25);
							}

						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + altAnim, true);
								dadnoteMovementYoffset = -15;
								dadnoteMovementXoffset = 0;
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
								dadnoteMovementXoffset = 15;
								dadnoteMovementYoffset = 0;
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
								dadnoteMovementYoffset = 15;
								dadnoteMovementXoffset = 0;
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
								dadnoteMovementXoffset = -15;
								dadnoteMovementYoffset = 0;
						}
	
						if (FlxG.save.data.cpuStrums)
							{
								cpuStrums.forEach(function(spr:FlxSprite)
								{
									if (Math.abs(daNote.noteData) == spr.ID)
									{
										spr.animation.play('confirm', true);
									}
									if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
									{
										spr.centerOffsets();
										spr.offset.x -= 13;
										spr.offset.y -= 13;
									}
									else
										spr.centerOffsets();
								});
							}

						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
	
					if (FlxG.save.data.downscroll)
						{
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed + scrollSpeedAddictive : FlxG.save.data.scrollSpeed, 2)));						}
					else
						daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed + scrollSpeedAddictive : FlxG.save.data.scrollSpeed, 2)));

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
					
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll) && daNote.mustPress)
					{
						if (daNote.isSustainNote && daNote.wasGoodHit)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
						else
						{
							healthbarshake(1.0);
							health -= 0.1;
							if(daNote.isSustainNote)
								misses++;

							if (daNote.holy)
							{
								holyNoteHit();
								daNote.rating == 'evade';
							}

							vocals.volume = 0;
							if (theFunne)
								noteMiss(daNote.noteData, daNote);
						}
						
						daNote.active = false;
						daNote.visible = false;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}

		if (FlxG.save.data.cpuStrums)
			{
				cpuStrums.forEach(function(spr:FlxSprite)
				{
					if (spr.animation.finished)
					{
						spr.animation.play('static');
						spr.centerOffsets();
					}
				});
			}

		if (!inCutscene)
			keyShit();

		if (healthDrainIndicator.alpha >= 0.0)
			{
				healthDrainIndicator.alpha -= 0.01;
			}

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function holyNoteHit()
		{
			allowBFanimupdate = false;
			healthbarshake(3.0);
			deathByHolyNote = true;
			health -= holyMisses; //0.5 for first time, 1.0 for second time, 1.5 for third time, kinda like a strike system but with 4 strikes?
			if (curSong == 'Tetris')
				iconP1.animation.play('bf-tetris-shot');
			else
				iconP1.animation.play('bf-shot');
			//dad.playAnim('shoot', true); //no animation bruh
			FlxG.sound.play(Paths.sound('MAMI_shoot','shared'));
			FlxG.camera.shake(0.02, 0.2);
			boyfriend.playAnim('hit', true);
			holyMisses += 0.4;
			FlxTween.color(healthBar, .20, FlxColor.RED, FlxColor.WHITE, {ease: FlxEase.quadOut});
			FlxTween.color(iconP1, .20, FlxColor.RED, FlxColor.WHITE, {ease: FlxEase.quadOut});
			FlxTween.color(iconP2, .20, FlxColor.RED, FlxColor.WHITE, {ease: FlxEase.quadOut});
			new FlxTimer().start(0.15, function(tmr:FlxTimer)
				{
					deathByHolyNote = false;
				});
			new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					allowBFanimupdate = true;
					if (curSong == 'Tetris')
						iconP1.animation.play('bf-tetris');
					else
						iconP1.animation.play('bf');
				});
		}

	function stopSong():Void
		{
			var doof2:DialogueBox = new DialogueBox(false, dialoguePOST);
			// doof.x += 70;
			// doof.y = FlxG.height * 0.5;
			doof2.scrollFactor.set();
			doof2.finishThing = endSong;
			doof2.cameras = [camOVERLAY];

			songCleared = true;
			canPause = false;
			FlxG.sound.music.volume = 0;
			vocals.volume = 0;

			if (isStoryMode)
			{
				switch(SONG.song.toLowerCase())
				{
					case 'salvation':
						salvationIntro(doof2);
					default:
						endSong();
				}
			}
			else
				{
					switch (curSong.toLowerCase())
					{
						default:
							endSong();
					}
				}
				
		}

	function endSong():Void
	{
		if (!loadRep)
			rep.SaveReplay();

		if (executeModchart)
		{
			Lua.close(lua);
			lua = null;
		}

		songCleared = true;
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, Math.round(songScore), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					FlxG.switchState(new StoryMenuState());

					if (lua != null)
					{
						Lua.close(lua);
						lua = null;
					}

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-easy';

					if (storyDifficulty == 2)
						difficulty = '-hard';

					if (storyDifficulty == 3)
						difficulty = '-holy';

					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

					if (SONG.song.toLowerCase() == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();
					switch(SONG.song.toLowerCase())
					{
						case 'salvation':
							LoadingState.loadAndSwitchState(new VideoState("assets/videos/Salvation_Finale.webm", new PlayState()));
						default:
							LoadingState.loadAndSwitchState(new PlayState());
					}

					if (SONG.song.toLowerCase() == 'salvation')
						{
							FlxG.save.data.progressStoryClear = true;
						}
					if (SONG.song.toLowerCase() == 'salvation' && storyDifficulty >= 2)
						{
							FlxG.save.data.progressStoryClearHard = true;
						}
					if (SONG.song.toLowerCase() == 'tetris')
						{
							FlxG.save.data.progressStoryClearTetris = true;
						}
				}
			}
			else
			{
				switch(curSong)
					{
						case 'Connect':
							{
								switch (storyDifficulty)
								{
									case 1:
										FlxG.save.data.tickets += 1;
									case 2:
										FlxG.save.data.tickets += 2;
									case 3:
										FlxG.save.data.tickets += 3;
								}
							}

						case 'Reminisce':
							{
								switch (storyDifficulty)
								{
									case 0:
										FlxG.save.data.tickets += 1;
									case 1:
										FlxG.save.data.tickets += 2;
									case 2:
										FlxG.save.data.tickets += 3;
									case 3:
										FlxG.save.data.tickets += 4;
								}
							}

						case 'Salvation':
							{
								switch (storyDifficulty)
								{
									case 0:
										FlxG.save.data.tickets += 2;
									case 1:
										FlxG.save.data.tickets += 3;
									case 2:
										FlxG.save.data.tickets += 4;
									case 3:
										FlxG.save.data.tickets += 5;
								}
							}
							
						case 'Tetris':
							{
								FlxG.save.data.progressStoryClearTetris = true;
								switch (storyDifficulty)
								{
									case 2:
										FlxG.save.data.tickets += 4;
									case 3:
										FlxG.save.data.tickets += 5;
								}
							}

						case 'Mamigation':
							{
								FlxG.save.data.progressStoryClearMamigation = true;
								switch (storyDifficulty)
								{
									case 2:
										FlxG.save.data.tickets += 4;
									case 3:
										FlxG.save.data.tickets += 5;
								}
							}
					}

				trace('WENT BACK TO FREEPLAY??');
				FlxG.switchState(new FreeplayState());
			}
		}
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	//tetris blockage bugs that i know and will prob fix tomorrow
	//pausing during a blockage will keep the blockage timer going and disappear
	//upscroll support

	public function tetrisblockage(percentageBlockage:Int, duration:Int, instant:Bool = false)
		{
			canPause = false; //temp(hopefully) solution to people avoiding tetris blocking mechanic 
			var tetrisBlockagePiece:FlxSprite = new FlxSprite(0, -1080).loadGraphic(Paths.image('tetris/health_blockage'));
			tetrisBlockagePiece.cameras = [camHUD];
			tetrisBlockagePiece.antialiasing = false;

			tetrisBlockagePiece.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(100 - percentageBlockage, 0, 100, 100, 0) * 0.01)) - 240;
			tetrisBlockagePiece.y = -720;
			tetrisBlockagePiece.setGraphicSize(Std.int(tetrisBlockagePiece.width * 0.075));

			add(tetrisBlockagePiece);

			if(!instant)
				if (FlxG.save.data.downscroll)
					{
						tetrisBlockagePiece.y = 150;
						trace(tetrisBlockagePiece.y);
					}
				else
					{
						tetrisBlockagePiece.y = -1080;
						trace(tetrisBlockagePiece.y);
					}
				FlxG.sound.play(Paths.sound('tetris/hpblockage_spawn','shared'));
				FlxFlicker.flicker(tetrisBlockagePiece, 1, 0.2, true);
				new FlxTimer().start(1, function(tmr:FlxTimer) //ik this is ugly but it works lol
					{
						if (FlxG.save.data.downscroll)
							{
								tetrisBlockagePiece.y -= 75;
								trace(tetrisBlockagePiece.y);
							}
						else
							{
								tetrisBlockagePiece.y += 75;
								trace(tetrisBlockagePiece.y);
							}
						FlxG.sound.play(Paths.sound('tetris/hpblockage_move','shared'));
						new FlxTimer().start(.15, function(tmr:FlxTimer)
							{
								if (FlxG.save.data.downscroll)
									{
										tetrisBlockagePiece.y -= 75;
										trace(tetrisBlockagePiece.y);
									}
								else
									{
										tetrisBlockagePiece.y += 75;
										trace(tetrisBlockagePiece.y);
									}
								FlxG.sound.play(Paths.sound('tetris/hpblockage_move','shared'));
							},11);
					},1);
				new FlxTimer().start(2.65, function(tmr:FlxTimer)
					{
						camHUD.shake(0.002, 0.5);
						FlxG.sound.play(Paths.sound('tetris/hpblockage_thud','shared'));
						healthcap = (percentageBlockage / 50);
						if (FlxG.save.data.downscroll)
							{
								tetrisBlockagePiece.y -= 15;
								trace(tetrisBlockagePiece.y);
							}
						else
							{
								tetrisBlockagePiece.y += 15;
								trace(tetrisBlockagePiece.y);
							}
						//tetrisBlockagePiece.y = -100;
					},1);

				if(!instant)
					new FlxTimer().start(duration + 2.65, function(tmr:FlxTimer)
						{
							FlxG.sound.play(Paths.sound('tetris/hpblockage_clear','shared'));
							remove(tetrisBlockagePiece);
							healthcap = 0;
							canPause = true; //temp(hopefully) solution to people avoiding tetris blocking mechanic 
						},1);
		}

		public function salvationLightFlicker()
			{
				lampsLeft.visible = !lampsLeft.visible;
			}

		public function ribbongrab(tiltpower:Int, duration:Int)
			{
				canPause = false; //temp(hopefully) solution to people avoiding the mechanic
				latched = true;
				var ribbongrab:FlxSprite = new FlxSprite(1000, 520);
				ribbongrab.frames = Paths.getSparrowAtlas('salvation/healthribbon');
				ribbongrab.antialiasing = true;
				ribbongrab.animation.addByPrefix('popout', 'ribbon_show', 24, false); //ribbon pops out
				ribbongrab.animation.addByPrefix('latch', 'ribbon_move', 24, false); //ribbon laches onto healthbar
				ribbongrab.animation.addByPrefix('pulling', 'ribbon_dragging', 24, true); //ribbon pulling the healthbar down
				ribbongrab.animation.addByPrefix('unlatch', 'ribbon_ungrab', 24, false); //ribbon unlaches and leaves
				ribbongrab.setGraphicSize(Std.int(ribbongrab.width * 1.0));
				add(ribbongrab);
				if (FlxG.save.data.downscroll)
					{
						ribbongrab.flipX = true;
						ribbongrab.flipY = true;
						ribbongrab.x = 100;
						ribbongrab.y = -115;
					}

				ribbongrab.animation.play('popout');
				ribbongrab.updateHitbox();
				ribbongrab.cameras = [camHUD];

				FlxG.sound.play(Paths.sound('salvation/ribbonpull_appear','shared'));

				new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						ribbongrab.animation.play('latch', true);
					});

				new FlxTimer().start(1.35, function(tmr:FlxTimer)
					{
						FlxG.sound.play(Paths.sound('salvation/ribbonpull_grab','shared'));
						new FlxTimer().start(.035, function(tmr:FlxTimer)
							{
								ribbongrab.animation.play('pulling');
								camHUD.angle += 0.05;
								
								if (FlxG.save.data.downscroll)
									{
										ribbongrab.y = -20;
									}

							},tiltpower);
					});

				new FlxTimer().start(duration + 2.5, function(tmr:FlxTimer)
					{
						ribbongrab.animation.play('unlatch');
						new FlxTimer().start(.25, function(tmr:FlxTimer)
							{
								remove(ribbongrab);
								latched = false;
							});
						new FlxTimer().start(.5, function(tmr:FlxTimer)
							{
								remove(ribbongrab);
								latched = false;
								canPause = true;
							});
					});
			}

	public function healthbarshake(intensity:Float)
		{
		new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				iconP1.y += (10 * intensity);
				iconP2.y += (10 * intensity);
				healthBar.y += (10 * intensity);
				healthBarBG.y += (10 * intensity);
				healthDrainIndicator.y += (10 * intensity);
			});
			new FlxTimer().start(0.05, function(tmr:FlxTimer)
			{
				iconP1.y -= (15 * intensity);
				iconP2.y -= (15 * intensity);
				healthBar.y -= (15 * intensity);
				healthBarBG.y -= (15 * intensity);
				healthDrainIndicator.y -= (15 * intensity);
			});
			new FlxTimer().start(0.10, function(tmr:FlxTimer)
			{
				iconP1.y += (8 * intensity);
				iconP2.y += (8 * intensity);
				healthBar.y += (8 * intensity);
				healthBarBG.y += (8 * intensity);
				healthDrainIndicator.y += (8 * intensity);
			});
			new FlxTimer().start(0.15, function(tmr:FlxTimer)
			{
				iconP1.y -= (5 * intensity);
				iconP2.y -= (5 * intensity);
				healthBar.y -= (5 * intensity);
				healthBarBG.y -= (5 * intensity);
				healthDrainIndicator.y -= (5 * intensity);
			});
			new FlxTimer().start(0.20, function(tmr:FlxTimer)
			{
				iconP1.y += (3 * intensity);
				iconP2.y += (3 * intensity);
				healthBar.y += (3 * intensity);
				healthBarBG.y += (3 * intensity);
				healthDrainIndicator.y += (3 * intensity);
			});
			new FlxTimer().start(0.25, function(tmr:FlxTimer)
			{
				iconP1.y -= (1 * intensity);
				iconP2.y -= (1 * intensity);
				healthBar.y -= (1 * intensity);
				healthBarBG.y -= (1 * intensity);
				healthDrainIndicator.y -= (1 * intensity);
			});
		}

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
			var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;
			if (daNote.holy)
				{
					daRating = 'evade';
				}

			switch(daRating)
			{
				case 'shit':
					score = -300;
					combo = 0;
					misses++;
					ss = false;
					shits++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.25;

					health -= 0.2;
					if (storyDifficulty == 3)
						{
							health -= 0.2;
						}

				case 'bad':
					daRating = 'bad';
					score = 0;
					ss = false;
					bads++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.50;

					health -= 0.06;
					if (storyDifficulty == 3)
						{
							health -= 0.06;
						}

				case 'good':
					daRating = 'good';
					score = 200;
					ss = false;
					goods++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.75;

					if (health < maxhealth)
						health += 0.01;

				case 'sick':
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 1;
					sicks++;

					

					if (health < maxhealth)
						health += 0.04;

				case 'evade':
					daRating = 'evade';
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 1;
					sicks++;

					
			}

			if (FlxG.save.data.noteSplash)
				{
					var sploosh:FlxSprite = new FlxSprite(daNote.x, playerStrums.members[daNote.noteData].y);
					if (!curStage.startsWith('school'))
					{
						var tex:flixel.graphics.frames.FlxAtlasFrames = Paths.getSparrowAtlas('noteSplashes', 'preload');
						var tex2:flixel.graphics.frames.FlxAtlasFrames = Paths.getSparrowAtlas('noteSplashes-alt', 'preload');

						if (!FlxG.save.data.arrowColorCustom)
							sploosh.frames = tex;
						if (FlxG.save.data.arrowColorCustom)
							sploosh.frames = tex2;
						sploosh.animation.addByPrefix('splash 0 0', 'note impact 1 purple', 24, false);
						sploosh.animation.addByPrefix('splash 0 1', 'note impact 1 blue', 24, false);
						sploosh.animation.addByPrefix('splash 0 2', 'note impact 1 green', 24, false);
						sploosh.animation.addByPrefix('splash 0 3', 'note impact 1 red', 24, false);
						sploosh.animation.addByPrefix('splash 1 0', 'note impact 2 purple', 24, false);
						sploosh.animation.addByPrefix('splash 1 1', 'note impact 2 blue', 24, false);
						sploosh.animation.addByPrefix('splash 1 2', 'note impact 2 green', 24, false);
						sploosh.animation.addByPrefix('splash 1 3', 'note impact 2 red', 24, false);
						if (daRating == 'sick')
						{
							add(sploosh);
							sploosh.cameras = [camHUD];
							sploosh.animation.play('splash ' + FlxG.random.int(0, 1) + " " + daNote.noteData);
							sploosh.alpha = 0.6;
							sploosh.offset.x += 60;
							sploosh.offset.y += 60;
							sploosh.animation.finishCallback = function(name) sploosh.kill();
						}
					}
				}
		

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
	
			
			var msTiming = truncateFloat(noteDiff, 3);

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
				case 'evade':
					currentTimingShown.color = FlxColor.YELLOW;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			add(currentTimingShown);
			


			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				if (combo >= 10 || combo == 0)
					add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		if (loadRep) // replay code
		{
			// disable input
			up = false;
			down = false;
			right = false;
			left = false;

			// new input


			//if (rep.replay.keys[repPresses].time == Conductor.songPosition)
			//	trace('DO IT!!!!!');

			//timeCurrently = Math.abs(rep.replay.keyPresses[repPresses].time - Conductor.songPosition);
			//timeCurrentlyR = Math.abs(rep.replay.keyReleases[repReleases].time - Conductor.songPosition);

			
			if (repPresses < rep.replay.keyPresses.length && repReleases < rep.replay.keyReleases.length)
			{
				upP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition  && rep.replay.keyPresses[repPresses].key == "up";
				rightP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition && rep.replay.keyPresses[repPresses].key == "right";
				downP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition && rep.replay.keyPresses[repPresses].key == "down";
				leftP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition  && rep.replay.keyPresses[repPresses].key == "left";	

				upR = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "up";
				rightR = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition  && rep.replay.keyReleases[repReleases].key == "right";
				downR = rep.replay.keyPresses[repReleases].time - 1<= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "down";
				leftR = rep.replay.keyPresses[repReleases].time - 1<= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "left";

				upHold = upP ? true : upR ? false : true;
				rightHold = rightP ? true : rightR ? false : true;
				downHold = downP ? true : downR ? false : true;
				leftHold = leftP ? true : leftR ? false : true;
			}
		}
		else if (!loadRep) // record replay code
		{
			if (upP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "up"});
			if (rightP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "right"});
			if (downP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "down"});
			if (leftP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "left"});

			if (upR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "up"});
			if (rightR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "right"});
			if (downR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "down"});
			if (leftR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "left"});
		}
		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
			{
				repPresses++;
				boyfriend.holdTimer = 0;
	
				var possibleNotes:Array<Note> = [];
	
				var ignoreList:Array<Int> = [];
	
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
					{
						// the sorting probably doesn't need to be in here? who cares lol
						possibleNotes.push(daNote);
						possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
	
						ignoreList.push(daNote.noteData);
					}
				});
	
				
				if (possibleNotes.length > 0)
				{
					var daNote = possibleNotes[0];
	
					// Jump notes
					if (possibleNotes.length >= 2)
					{
						if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
						{
							for (coolNote in possibleNotes)
							{

								if (controlArray[coolNote.noteData])
									goodNoteHit(coolNote);
								else
								{
									var inIgnoreList:Bool = false;
									for (shit in 0...ignoreList.length)
									{
										if (controlArray[ignoreList[shit]])
											inIgnoreList = true;
									}
									if (!inIgnoreList && !FlxG.save.data.ghostTapping)
										badNoteCheck();
								}
							}
						}
						else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
						{
							if (loadRep)
							{
								var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);

								daNote.rating = Ratings.CalculateRating(noteDiff);

								if (NearlyEquals(daNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
								{
									goodNoteHit(daNote);
									trace('force note hit');
								}
								else
									noteCheck(controlArray, daNote);
							}
							else
								noteCheck(controlArray, daNote);
						}
						else
						{
							for (coolNote in possibleNotes)
							{
								if (loadRep)
									{
										if (NearlyEquals(coolNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
										{
											var noteDiff:Float = Math.abs(coolNote.strumTime - Conductor.songPosition);

											if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
												coolNote.rating = "shit";
											else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
												coolNote.rating = "bad";
											else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
												coolNote.rating = "good";
											else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
												coolNote.rating = "sick";
											goodNoteHit(coolNote);
											trace('force note hit');
										}
										else
											noteCheck(controlArray, daNote);
									}
								else
									noteCheck(controlArray, coolNote);
							}
						}
					}
					else // regular notes?
					{	
						if (loadRep)
						{
							if (NearlyEquals(daNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
							{
								var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);

								daNote.rating = Ratings.CalculateRating(noteDiff);

								goodNoteHit(daNote);
								trace('force note hit');
							}
							else
								noteCheck(controlArray, daNote);
						}
						else
							noteCheck(controlArray, daNote);
					}
					/* 
						if (controlArray[daNote.noteData])
							goodNoteHit(daNote);
					 */
					// trace(daNote.noteData);
					/* 
						switch (daNote.noteData)
						{
							case 2: // NOTES YOU JUST PRESSED
								if (upP || rightP || downP || leftP)
									noteCheck(upP, daNote);
							case 3:
								if (upP || rightP || downP || leftP)
									noteCheck(rightP, daNote);
							case 1:
								if (upP || rightP || downP || leftP)
									noteCheck(downP, daNote);
							case 0:
								if (upP || rightP || downP || leftP)
									noteCheck(leftP, daNote);
						}
					 */
					if (daNote.wasGoodHit)
					{
						if (daNote.holy)
							{
								FlxG.sound.play(Paths.sound('MAMI_shoot','shared'));
								boyfriend.playAnim('dodge', true); //its just here i will make it work propperly tomorrow or smth
								FlxG.camera.shake(0.015, 0.3);
								camHUD.shake(0.010, 0.3);
							}
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
				else if (!FlxG.save.data.ghostTapping)
					{
						badNoteCheck();
					}
			}
	
			if ((up || right || down || left) && generatedMusic || (upHold || downHold || leftHold || rightHold) && loadRep && generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
					{
						switch (daNote.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 2:
								if (up || upHold)
									goodNoteHit(daNote);
							case 3:
								if (right || rightHold)
									goodNoteHit(daNote);
							case 1:
								if (down || downHold)
									goodNoteHit(daNote);
							case 0:
								if (left || leftHold)
									goodNoteHit(daNote);
						}
					}
				});
			}
	
			if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
			{
				if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				{
					if (allowBFanimupdate)
						boyfriend.playAnim('idle');
				}
			}
	
				playerStrums.forEach(function(spr:FlxSprite)
				{
					switch (spr.ID)
					{
						case 2:
							if (loadRep)
							{
								/*if (upP)
								{
									spr.animation.play('pressed');
									new FlxTimer().start(Math.abs(rep.replay.keyPresses[repReleases].time - Conductor.songPosition) + 10, function(tmr:FlxTimer)
										{
											spr.animation.play('static');
											repReleases++;
										});
								}*/
							}
							else
							{
								if (upP && spr.animation.curAnim.name != 'confirm' && !loadRep)
								{
									spr.animation.play('pressed');
									trace('play');
								}
								if (upR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}
						case 3:
							if (loadRep)
								{
								/*if (upP)
								{
									spr.animation.play('pressed');
									new FlxTimer().start(Math.abs(rep.replay.keyPresses[repReleases].time - Conductor.songPosition) + 10, function(tmr:FlxTimer)
										{
											spr.animation.play('static');
											repReleases++;
										});
								}*/
								}
							else
							{
								if (rightP && spr.animation.curAnim.name != 'confirm' && !loadRep)
									spr.animation.play('pressed');
								if (rightR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}	
						case 1:
							if (loadRep)
								{
								/*if (upP)
								{
									spr.animation.play('pressed');
									new FlxTimer().start(Math.abs(rep.replay.keyPresses[repReleases].time - Conductor.songPosition) + 10, function(tmr:FlxTimer)
										{
											spr.animation.play('static');
											repReleases++;
										});
								}*/
								}
							else
							{
								if (downP && spr.animation.curAnim.name != 'confirm' && !loadRep)
									spr.animation.play('pressed');
								if (downR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}
						case 0:
							if (loadRep)
								{
								/*if (upP)
								{
									spr.animation.play('pressed');
									new FlxTimer().start(Math.abs(rep.replay.keyPresses[repReleases].time - Conductor.songPosition) + 10, function(tmr:FlxTimer)
										{
											spr.animation.play('static');
											repReleases++;
										});
								}*/
								}
							else
							{
								if (leftP && spr.animation.curAnim.name != 'confirm' && !loadRep)
									spr.animation.play('pressed');
								if (leftR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}
					}
					
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
	}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			healthbarshake(1.0);

			if (storyDifficulty == 3)
				{
				if (daNote.isSustainNote)
					health -= 0.10; //you lose less health per sustain note you miss
				else
					health -= 0.250;
				}
			else
				{
				if (daNote.isSustainNote)
					health -= 0.05; //you lose less health per sustain note you miss
				else
					health -= 0.125;
				}


			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');
			if (allowBFanimupdate)
				switch (direction)
				{
					case 0:
						boyfriend.playAnim('singLEFTmiss', true);
					case 1:
						boyfriend.playAnim('singDOWNmiss', true);
					case 2:
						boyfriend.playAnim('singUPmiss', true);
					case 3:
						boyfriend.playAnim('singRIGHTmiss', true);
				}

			updateAccuracy();
		}
	}

	function noteMisswithoutDaNote(direction:Int = 1)
		{
			if (!boyfriend.stunned)
				{
					healthbarshake(1.0);
					health -= 0.15;
					if (storyDifficulty == 3)
						{
							health -= 0.15;
						}
		
					if (combo > 5 && gf.animOffsets.exists('sad'))
					{
						gf.playAnim('sad');
					}
					combo = 0;
					misses++;

				songScore -= 10;
				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

				if (allowBFanimupdate)
					switch (direction)
					{
						case 0:
							boyfriend.playAnim('singLEFTmiss', true);
						case 1:
							boyfriend.playAnim('singDOWNmiss', true);
						case 2:
							boyfriend.playAnim('singUPmiss', true);
						case 3:
							boyfriend.playAnim('singRIGHTmiss', true);
					}

				updateAccuracy();	
				}
		}

	function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMisswithoutDaNote(0);
			if (upP)
				noteMisswithoutDaNote(2);
			if (rightP)
				noteMisswithoutDaNote(3);
			if (downP)
				noteMisswithoutDaNote(1);
			updateAccuracy();
		}
	
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
				note.rating = "shit";
			else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
				note.rating = "bad";
			else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
				note.rating = "good";
			else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
				note.rating = "sick";

			if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note);
					}
				}
			}
			else if (controlArray[note.noteData])
				{
					for (b in controlArray) {
						if (b)
							mashing++;
					}
					// ANTI MASH CODE FOR THE BOYS

					if (mashing <= getKeyPresses(note) && mashViolations < 2)
					{
						mashViolations++;
						
						goodNoteHit(note, (mashing <= getKeyPresses(note)));
					}
					else
					{
						// this is bad but fuck you
						playerStrums.members[0].animation.play('static');
						playerStrums.members[1].animation.play('static');
						playerStrums.members[2].animation.play('static');
						playerStrums.members[3].animation.play('static');
						healthbarshake(1.0);
						health -= 0.15;
						if (storyDifficulty == 3)
							{
								health -= 0.15;
							}
						trace('mash ' + mashing);
					}

					if (mashing != 0)
						mashing = 0;
				}
		}

		var nps:Int = 0;

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				if (!note.isSustainNote)
					notesHitArray.push(Date.now());

				if (resetMashViolation)
					mashViolations--;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	

					switch (note.noteData)
					{
						case 2:
							allowBFanimupdate = true;
							boyfriend.playAnim('singUP', true);
							bfnoteMovementYoffset = -15;
						case 3:
							allowBFanimupdate = true;
							boyfriend.playAnim('singRIGHT', true);
							bfnoteMovementXoffset = 15;
						case 1:
							allowBFanimupdate = true;
							boyfriend.playAnim('singDOWN', true);
							bfnoteMovementYoffset = 15;
						case 0:
							allowBFanimupdate = true;
							boyfriend.playAnim('singLEFT', true);
							bfnoteMovementXoffset = -15;
					}
		
					if (!loadRep)
						playerStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(note.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);
							}
						});
		
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					if (FlxG.save.data.hitSound && !note.isSustainNote)
						FlxG.sound.play(Paths.sound('MAMI_hitsound','shared'));

					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
			resyncLowhpmusic();
		}

		if (executeModchart && lua != null)
		{
			setVar('curStep',curStep);
			callLua('stepHit',[curStep]);
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}

		if (FlxG.random.bool(15) && curSong == 'Salvation' && !songCleared)
			{
				salvationLightFlicker();
			}

		if (curSong == 'Salvation' && !songCleared)
			{
				switch (curStep)
				{
					case 34:
						salvationLightFlicker();

					case 36: 
						salvationLightFlicker();

					case 46: 
						salvationLightFlicker();

					case 51: 
						salvationLightFlicker();

					case 52: 
						salvationLightFlicker();

					case 58: 
						salvationLightFlicker();

					case 74:
						blackOverlay.visible = false;
						camHUD.alpha = 1.0;
				}
			}

		if (curStage == 'subway-holy')
			{
				if (lampsLeft.visible)
					{
						darknessOverlay.alpha = 0.3;
					}
				else
					{
						darknessOverlay.alpha = 0.45;
					}
			}

		if (latched) //salvation ribbon damage
			{
			health -= (camHUD.angle * 0.005);
			healthDrainIndicator.alpha = 1.0;
			healthDrainIndicator.visible = true;
			}

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end	
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (curSong == 'Salvation' && storyDifficulty <= 2 && curBeat % 16 == 15)
			{
				if (holyMisses > 0.40)
					holyMisses -= 0.01;
			}

		if (FlxG.save.data.useShaders)
			{
				FlxG.camera.setFilters([ShadersHandler.chromaticAberration]);
				camHUD.setFilters([ShadersHandler.chromaticAberration]);
			}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (executeModchart && lua != null)
		{
			setVar('curBeat',curBeat);
			callLua('beatHit',[curBeat]);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (curSong.toLowerCase() == 'tetris' && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += (tetrisZoom / 2); //0.02
				camHUD.zoom += tetrisZoom; //0.05
			}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % cameraZoomrate == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			if (allowBFanimupdate)
				boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		if (curSong == 'Connect' && !songCleared) 
			{
				switch (curBeat)
				{
					case 2:
						defaultCamZoom = 0.85;

						if (FlxG.save.data.flashingLights)
							{
							connectLight.alpha = .8;
							FlxTween.tween(connectLight, {alpha: 0}, 3, {ease: FlxEase.quartOut});
							}
					case 32:
						defaultCamZoom = 0.7;
					case 209:
						defaultCamZoom = 0.90;
						connectLight.alpha = .8;

						if (FlxG.save.data.flashingLights)
							{
							connectLight.alpha = .8;
							FlxTween.tween(connectLight, {alpha: 0}, 3, {ease: FlxEase.quartOut});
							}
					case 216:
						defaultCamZoom = 0.7;
					case 225:
						defaultCamZoom = 0.90;
						connectLight.alpha = .8;
						
						if (FlxG.save.data.flashingLights)
							{
							connectLight.alpha = .8;
							FlxTween.tween(connectLight, {alpha: 0}, 3, {ease: FlxEase.quartOut});
							}
					case 240:
						defaultCamZoom = 0.7;
					}
			}

		/*
		if (curSong == 'Reminisce')
			{
				switch (curBeat)
				{
					case 17:
						iconP2.animation.play("dad");

						remove(dad);
						dad = new Character(25, 100, "dad");
						add(dad);
				}
			}
		*/
			
		//FlxTween.linearMotion(gunSwarm, -1500, -200, 2500, 1500, .5, true);

		if (thisBitchSnapped && curSong == 'Salvation' && !FlxG.save.data.reducedMotion)
			{
				if (gunSwarmFront.alpha <= 0.0)
					{
					gunSwarmFront.alpha += 1;
					gunSwarmBack.alpha += 1;
					if (FlxG.save.data.flashingLights)
						FlxG.camera.flash(FlxColor.WHITE, 3);
					}
				}
		else if (!thisBitchSnapped && curSong == 'Salvation' && !FlxG.save.data.reducedMotion)
			{
				if (gunSwarmFront.alpha >= 0.01)
					{
					new FlxTimer().start(.035, function(tmr:FlxTimer)
						{
							gunSwarmFront.alpha -= .1;
							gunSwarmBack.alpha -= .1;
						},10);
					}
			}

		if (thisBitchSnapped && curSong == 'Salvation' && !FlxG.save.data.reducedMotion)
			{
				camera.shake(0.005,0.25);
				camHUD.shake(0.005,0.25);
			}

		if (curSong == 'Salvation' && !songCleared)
			{
				switch (curBeat)
				{
					case 1:
						camHUD.alpha = 0.0;

					case 12:
						FlxG.sound.play(Paths.sound('intro3'), 0.6);

					case 13:
						var salvationcountdownready:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ready', 'shared'));
						FlxG.sound.play(Paths.sound('intro2'), 0.6);
						salvationcountdownready.scrollFactor.set(0, 0);
						salvationcountdownready.updateHitbox();
						salvationcountdownready.cameras = [camOVERLAY];

						salvationcountdownready.screenCenter();
						salvationcountdownready.y -= 100;
						add(salvationcountdownready);
						FlxTween.tween(salvationcountdownready, {y: salvationcountdownready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								salvationcountdownready.destroy();
							}
						});

					case 14:
						var salvationcountdownset:FlxSprite = new FlxSprite().loadGraphic(Paths.image('set', 'shared'));
						FlxG.sound.play(Paths.sound('intro1'), 0.6);
						salvationcountdownset.scrollFactor.set(0, 0);
						salvationcountdownset.updateHitbox();
						salvationcountdownset.cameras = [camOVERLAY];

						salvationcountdownset.screenCenter();
						salvationcountdownset.y -= 100;
						add(salvationcountdownset);
						FlxTween.tween(salvationcountdownset, {y: salvationcountdownset.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								salvationcountdownset.destroy();
							}
						});


					case 15:
						blackOverlay.visible = false;
						camHUD.alpha = 1.0;

						var salvationcountdowngo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('go', 'shared'));
						FlxG.sound.play(Paths.sound('introGo'), 0.6);
						salvationcountdowngo.scrollFactor.set(0, 0);
						salvationcountdowngo.updateHitbox();
						salvationcountdowngo.cameras = [camOVERLAY];

						salvationcountdowngo.screenCenter();
						salvationcountdowngo.y -= 100;
						add(salvationcountdowngo);
						FlxTween.tween(salvationcountdowngo, {y: salvationcountdowngo.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								salvationcountdowngo.destroy();
							}
						});

					case 80:
						FlxG.camera.zoom += 0.03;
						camHUD.zoom += 0.06;

					case 32:
						switch (storyDifficulty)
						{
							case 1:
								ribbongrab(12, 4);

							case 2:
								ribbongrab(35, 8);

							case 3:
								ribbongrab(35, 8);
						}

					case 88:
						FlxG.camera.zoom += 0.03;
						camHUD.zoom += 0.06;

					case 96:
						FlxG.camera.zoom += 0.03;
						camHUD.zoom += 0.06;

					case 104:
						FlxG.camera.zoom += 0.03;
						camHUD.zoom += 0.06;

					case 112:
						FlxG.camera.zoom += 0.03;
						camHUD.zoom += 0.06;

					case 116:
						FlxG.camera.zoom += 0.03;
						camHUD.zoom += 0.06;

					case 120:
						FlxG.camera.zoom += 0.03;
						camHUD.zoom += 0.06;

					case 124:
						FlxG.camera.zoom += 0.03;
						camHUD.zoom += 0.06;

					case 128:
						FlxG.camera.zoom += 0.03;
						camHUD.zoom += 0.06;

					case 132:
						FlxG.camera.zoom += 0.03;
						camHUD.zoom += 0.06;

					case 136:
						FlxG.camera.zoom += 0.03;
						camHUD.zoom += 0.06;

					case 140:
						FlxG.camera.zoom += 0.03;
						camHUD.zoom += 0.06;

					case 144:
						FlxG.camera.zoom += 0.03;
						camHUD.zoom += 0.06;
						
					case 148:
						//thisBitchSnapped = true;
						cameraZoomrate = 1;
						defaultCamZoom = 0.85;
						switch (storyDifficulty)
						{
							case 1:
								ribbongrab(40, 3);

							case 2:
								ribbongrab(90, 5);

							case 3:
								ribbongrab(90, 5);
						}

					case 176:
						//thisBitchSnapped = false;
						cameraZoomrate = 4;
						defaultCamZoom = 0.7;

					case 210:
						cameraZoomrate = 4;
						defaultCamZoom = 1;

					case 218:
						cameraZoomrate = 4;
						defaultCamZoom = 0.7;

					case 312:
						cameraZoomrate = 4;
						defaultCamZoom = 1.15;
						camHUD.alpha = 0.0;
						blackOverlay.visible = true;

					case 316:
						blackOverlay.alpha = 0.8;
						FlxTween.tween(blackOverlay, {alpha: 1}, 2, {ease: FlxEase.quartOut});
					
					case 324:
						blackOverlay.alpha = 0.8;
						FlxTween.tween(blackOverlay, {alpha: 1}, 2, {ease: FlxEase.quartOut});

					case 332:
						blackOverlay.alpha = 0.8;
						FlxTween.tween(blackOverlay, {alpha: 1}, 2, {ease: FlxEase.quartOut});

					case 344:
						blackOverlay.alpha = 1;
						camHUD.alpha = 1.0;
						defaultCamZoom = 0.7;
						FlxTween.tween(blackOverlay, {alpha: 0}, 1.0, {ease: FlxEase.quartOut});

					case 405:
						var salvationcountdownready:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ready', 'shared'));
						salvationcountdownready.scrollFactor.set(0, 0);
						salvationcountdownready.updateHitbox();
						salvationcountdownready.cameras = [camOVERLAY];

						salvationcountdownready.screenCenter();
						salvationcountdownready.y -= 100;
						add(salvationcountdownready);
						FlxTween.tween(salvationcountdownready, {y: salvationcountdownready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								salvationcountdownready.destroy();
							}
						});

					case 406:
						var salvationcountdownset:FlxSprite = new FlxSprite().loadGraphic(Paths.image('set', 'shared'));
						salvationcountdownset.scrollFactor.set(0, 0);
						salvationcountdownset.updateHitbox();
						salvationcountdownset.cameras = [camOVERLAY];

						salvationcountdownset.screenCenter();
						salvationcountdownset.y -= 100;
						add(salvationcountdownset);
						FlxTween.tween(salvationcountdownset, {y: salvationcountdownset.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								salvationcountdownset.destroy();
							}
						});

					case 407:
						blackOverlay.visible = false;
						camHUD.alpha = 1.0;

						var salvationcountdowngo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('go', 'shared'));
						salvationcountdowngo.scrollFactor.set(0, 0);
						salvationcountdowngo.updateHitbox();
						salvationcountdowngo.cameras = [camOVERLAY];

						salvationcountdowngo.screenCenter();
						salvationcountdowngo.y -= 100;
						add(salvationcountdowngo);
						FlxTween.tween(salvationcountdowngo, {y: salvationcountdowngo.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								salvationcountdowngo.destroy();
							}
						});

						blackOverlay.visible = false;
						thisBitchSnapped = true;
						cameraZoomrate = 1;
						defaultCamZoom = 0.85;
						if (storyDifficulty == 3)
							{
							notehealthdmg = 0.0125;
							}
						else if (storyDifficulty == 2)
							{
								notehealthdmg = 0.0060;
							}
						else if (storyDifficulty == 1)
							{
								notehealthdmg = 0.025;
							}
						else if (storyDifficulty == 0)
							{
								notehealthdmg = 0.0;
							}

					case 472:
						thisBitchSnapped = false;
						cameraZoomrate = 4;
						defaultCamZoom = 0.7;
						notehealthdmg = 0.0;

					case 512:
						switch (storyDifficulty)
						{
							case 1:
								ribbongrab(40, 3);

							case 2:
								ribbongrab(90, 5);

							case 3:
								ribbongrab(90, 5);
						}
						
					case 544:
						lampsLeft.visible = false;
						if (FlxG.save.data.flashingLights)
							FlxG.camera.flash(FlxColor.WHITE, 3);
						boyfriend.color = FlxColor.BLACK;
						gf.color = FlxColor.BLACK;
						dad.color = FlxColor.BLACK;
						holyHomura.color = FlxColor.BLACK;
						otherBGStuff.color = FlxColor.BLACK;
						lampsSubway.color = FlxColor.BLACK;
						stageFront.color = FlxColor.BLACK;
						whiteBG.alpha = 1.0;

					case 608:
						lampsLeft.visible = true;
						if (FlxG.save.data.flashingLights)
							FlxG.camera.flash(FlxColor.WHITE, 3);
						boyfriend.color = FlxColor.WHITE;
						gf.color = FlxColor.WHITE;
						dad.color = FlxColor.WHITE;
						holyHomura.color = FlxColor.WHITE;
						otherBGStuff.color = FlxColor.WHITE;
						lampsSubway.color = FlxColor.WHITE;
						stageFront.color = FlxColor.WHITE;
						whiteBG.alpha = 0.0;	
						thisBitchSnapped = true;
						cameraZoomrate = 1;
						defaultCamZoom = 0.85;
						if (storyDifficulty == 3)
							{
							notehealthdmg = 0.0125;
							}
						else if (storyDifficulty == 2)
							{
								notehealthdmg = 0.0060;
							}
						else if (storyDifficulty == 1)
							{
								notehealthdmg = 0.025;
							}
						else if (storyDifficulty == 0)
							{
								notehealthdmg = 0.0;
							}
					case 736:
						if (FlxG.save.data.flashingLights)
							FlxG.camera.flash(FlxColor.WHITE, 3);
						boyfriend.color = FlxColor.BLACK;
						gf.color = FlxColor.BLACK;
						dad.color = FlxColor.BLACK;
						holyHomura.color = FlxColor.BLACK;
						otherBGStuff.color = FlxColor.BLACK;
						lampsSubway.color = FlxColor.BLACK;
						stageFront.color = FlxColor.BLACK;
						thisBitchSnapped = false;
						cameraZoomrate = 4;
						blackOverlay.visible = false;
						whiteBG.alpha = 1.0;
						//camHUD.alpha = 0.0;
						notehealthdmg = 0.00;

						iconP2.animation.play("mami-holy-postsnap");

					case 876:
						if (FlxG.save.data.flashingLights)
							FlxG.camera.flash(FlxColor.WHITE, 3);
						cameraZoomrate = 128;

						remove(dad);
						dad = new Character(-250, 115, "mami-holy-postsnap");
						add(dad);

						FlxTween.color(boyfriend, 5, FlxColor.BLACK, FlxColor.WHITE, {ease: FlxEase.quadInOut});
						FlxTween.color(gf, 5, FlxColor.BLACK, FlxColor.WHITE, {ease: FlxEase.quadInOut});
						FlxTween.color(holyHomura, 5, FlxColor.BLACK, FlxColor.WHITE, {ease: FlxEase.quadInOut});
						FlxTween.color(otherBGStuff, 5, FlxColor.BLACK, FlxColor.WHITE, {ease: FlxEase.quadInOut});
						FlxTween.color(lampsSubway, 5, FlxColor.BLACK, FlxColor.WHITE, {ease: FlxEase.quadInOut});
						FlxTween.color(stageFront, 5, FlxColor.BLACK, FlxColor.WHITE, {ease: FlxEase.quadInOut});
						FlxTween.color(dad, 5, FlxColor.BLACK, FlxColor.WHITE, {ease: FlxEase.quadInOut});
						FlxTween.tween(whiteBG, {alpha: 0}, 5, {ease: FlxEase.quartOut});

						thisBitchSnapped = false;
						blackOverlay.visible = false;
						//camHUD.alpha = 0.0;
						notehealthdmg = 0.00;

					case 877:
						FlxTween.color(dad, 5, FlxColor.BLACK, FlxColor.WHITE, {ease: FlxEase.quadInOut});

					case 900:
						blackOverlay.alpha = 0.0;
						blackOverlay.visible = true;
						FlxTween.tween(blackOverlay, {alpha: 1}, 5, {ease: FlxEase.quartOut});
				}
			}

		if (curSong == 'Tetris' && isDisco && FlxG.save.data.flashingLights && !songCleared) 
			{
				if (colorCycle <= 3)
					{
					colorCycle += 1;
					if (FlxG.save.data.useShaders)
						swagShader.hue += .125;
					}
				else
					{
					colorCycle = 0;
					if (FlxG.save.data.useShaders)
						swagShader.hue = 0.20;
					}

				if (colorCycle == 0)
					tetrisLight.animation.play("red", true);
				else if (colorCycle == 1)
					tetrisLight.animation.play("yellow", true);
				else if (colorCycle == 2)
					tetrisLight.animation.play("blue", true);
				else if (colorCycle == 3)
					tetrisLight.animation.play("green", true);
				else if (colorCycle == 4)
					tetrisLight.animation.play("pink", true);

				tetrisLight.alpha = 1;
			}
		else
			{
				if (FlxG.save.data.useShaders)
					swagShader.hue = 0;
			}

		if (curSong == 'Tetris' && storyDifficulty == 2 && !songCleared) //Tetris HARD events
			{
				switch (curBeat)
				{
					case 0:
						notehealthdmg = 0.0125;
					case 1:
						notehealthdmg = 0.0125;
					case 28:
						tetrisblockage(70, 6, false);
					case 96:
						notehealthdmg = 0.015;
					case 111:
						notehealthdmg = 0.0125;
					case 163:
						notehealthdmg = 0.02;
					case 168:
						notehealthdmg = 0.0125;	
					case 169:
						tetrisblockage(40, 12, false);	
					case 281:
						tetrisblockage(55, 17, false);	
					case 354:
						notehealthdmg = 0.02;	
					case 360:
						notehealthdmg = 0.0150;	
					case 362:
						tetrisblockage(70, 30, false);	
				}
			}

		if (curSong == 'Tetris' && storyDifficulty == 3 && !songCleared) //Tetris HOLY events
			{
				switch (curBeat)
				{
					case 0:
						notehealthdmg = 0.0125;
					case 1:
						notehealthdmg = 0.0125;
					case 28:
						tetrisblockage(75, 6, false);
					case 96:
						notehealthdmg = 0.015;
					case 111:
						notehealthdmg = 0.0125;
					case 163:
						notehealthdmg = 0.02;
					case 168:
						notehealthdmg = 0.0125;	
					case 169:
						tetrisblockage(45, 12, false);	
					case 281:
						tetrisblockage(60, 17, false);	
					case 354:
						notehealthdmg = 0.02;	
					case 360:
						notehealthdmg = 0.0150;	
					case 362:
						tetrisblockage(80, 30, false);	
				}
			}

		if (curSong == 'Tetris' && !songCleared)
			{
				switch (curBeat)
					{
						case 1:
							isDisco = false;
							defaultCamZoom = 0.90;

						case 16:
							defaultCamZoom = 0.7;

						case 32:
							defaultCamZoom = 0.90;

						case 48:
							defaultCamZoom = 0.7;

						case 64:
							isDisco = true;
							tetrisZoom = 0.03;

						case 82:
							tetrisZoom = 0.015;

						case 92:
							tetrisZoom = 0.04;

						case 128:
							tetrisZoom = 0.02;

						case 160:
							isDisco = false;
							tetrisZoom = 0.00;

						case 256:
							tetrisZoom = 0.01;

						case 272:
							tetrisZoom = 0.015;

						case 286:
							isDisco = true;
							tetrisZoom = 0.03;
							FlxTween.tween(tetrisCrowd, {y: 300}, .5, {type: FlxTweenType.ONESHOT, ease: FlxEase.quadOut});

						case 304:
							tetrisZoom = 0.05;

						case 320:
							FlxTween.tween(tetrisCrowd, {y: 900}, .5, {type: FlxTweenType.ONESHOT, ease: FlxEase.quadOut});

						case 352:
							isDisco = false;
							tetrisZoom = 0.02;
					}
			}

		//isDisco = true;

		if (curSong == 'Mamigation' && !songCleared)
			{
				switch (curBeat)
					{
						case 16:
							camHUD.alpha = 1.0;

						case 532:
							dad.playAnim('singUP', true);
							defaultCamZoom = 1.2;

						case 536:
							defaultCamZoom = 0.7;
					}
			}

		switch (curStage)
		{
			case 'subway':
				if(curBeat % 2 == 1)
					{
					gorls.animation.play('move', true);
					weebGorl.animation.play('move', true);
					}


			case 'subway-holy':
				if(curBeat % 2 == 1)
					holyHomura.animation.play('move', true);

			case 'subway-tetris':
				if(curBeat % 2 == 1)
					holyHomura.animation.play('move', true);

				tetrisCrowd.animation.play('cheer', true);

			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}
	

	var curLight:Int = 0;
}
