package;

import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
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

#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;
	public static var alternativeMusic:FlxSound;
	public static var showedDialogue = false;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	public static var misses:Int = 0;

	var songPosBG:FlxSprite;
	var songPosBar:FlxBar;
	var songPosName:FlxFixedText;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxFixedText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var songDiscordText:String = "";
	#end

	private var vocals:FlxSound;

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	public var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;
	private var eventNum = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var bush:Character; //
	public var bushChar:Character;
	public var oldDad:Character;
	public var hasBushBush:Bool = false;
	var isbush:Bool = false; //

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;

	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxFixedText;
	var replayTxt:FlxFixedText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var inCutscene:Bool = false;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botPlayState:FlxFixedText;
	// Replay shit
	private var saveNotes:Array<Float> = [];

	private var executeModchart = false;

	// API stuff
	
	public var downscroll:Bool = false;
	public var npsDisplay:Bool = false;
	public var accuracyMod:Int = 1;
	public var accuracyDisplay:Bool = false;
	public var botPlay:Bool = false;
	public var lightCpuStrums:Bool = false;
	public var ghostTapping:Bool = false;

	var currentTimingShown:FlxFixedText;

	var missSounds:Array<FlxSoundAsset> = [];
	var comboImages:Array<FlxGraphicAsset> = [];
	var ratingImages = new Map<String, FlxGraphicAsset>();

	function cacheImage(name:String) {
		var image = FlxG.bitmap.add(Paths.image(name));
		image.persist = true;
		image.destroyOnNoUse = false;
		return image;
	}

	function uncacheImage(value:FlxGraphicAsset) {
		if((value is FlxGraphic)) {
			var im:FlxGraphic = cast value;
			im.destroyOnNoUse = true;
			im.persist = false;
		}
	}

	override function destroy() {
		for (value in comboImages)
			uncacheImage(value);
		for (value in ratingImages)
			uncacheImage(value);

		missSounds = null;
		comboImages = null;
		ratingImages.clear();
		ratingImages = null;
		super.destroy();
	}

	override public function create()
	{
		instance = this;

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		for(i in [1, 2, 3]) {
			var sound = FlxG.sound.cache(Paths.sound('missnote' + i));
			missSounds.push(sound);
		}
		for(i in 0...10) {
			var image = cacheImage('num' + i);
			comboImages.push(image);
		}
		for(rating in ["shit", "bad", "good", "sick"]) {
			var image = cacheImage(rating);
			ratingImages[rating] = image;
		}

		downscroll = FlxG.save.data.downscroll;
		npsDisplay = FlxG.save.data.npsDisplay;
		accuracyMod = FlxG.save.data.accuracyMod;
		accuracyDisplay = FlxG.save.data.accuracyDisplay;
		botPlay = FlxG.save.data.botplay;
		lightCpuStrums = FlxG.save.data.cpuStrums;
		ghostTapping = FlxG.save.data.ghost;

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		// pre lowercasing the song name (create)
		curSong = PlayState.SONG.song.toLowerCase();
		
		#if windows
		executeModchart = FileSystem.exists(Paths.lua(curSong  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(curSong + "/modchart"));

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

		songDiscordText = SONG.song + " (" + storyDifficultyText + ")";

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + songDiscordText + " " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC);
		#end

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + botPlay);

		switch(SONG.stage)
		{
			case 'halloween': 
			{
				curStage = 'spooky';

				var hallowTex = Paths.getSparrowAtlas('halloween_bg','week2');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				isHalloween = true;
			}

			case 'pixel-bush':
			{
				curStage = 'pixel-bush';

				// defaultCamZoom = 0.9;

				var bg = new FlxSprite().loadGraphic(Paths.image('images/back/main/pixel/background','bushmann'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);
				bg.scale.set(6, 6);
				var repositionShit = -200;
			}

			case 'simp':
			{
				defaultCamZoom = 0.5;

				curStage = 'simp';
				

			var bg:FlxSprite = new FlxSprite(-1200, -800).loadGraphic(Paths.image('back/main/sunset1/city','bushmann'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.4, 0.4);
			bg.active = false;
			add(bg);


			var front:FlxSprite = new FlxSprite(-1500, -800).loadGraphic(Paths.image('back/main/sunset1/front','bushmann'));
			front.antialiasing = true;
			front.active = false;
			add(front);
				
			}

			case 'forest':
			{
				defaultCamZoom = 0.7;

				curStage = 'forest';
			//	var randomOcc = FlxG.random.int(0, 5);
			//	curStage = 'forest';
			//	var bg:FlxSprite = new FlxSprite(-600, -360).loadGraphic(Paths.image('back/main/sunset1/forest' + randomOcc,'bushmann'));
			//	if(randomOcc == 5) {
			//		// code here
			//	}
			//	bg.antialiasing = true;
			//	bg.scrollFactor.set(0.9, 0.9);
			//	bg.active = false;
			//	add(bg);

			var bg:FlxSprite = new FlxSprite(-1200, -800).loadGraphic(Paths.image('back/main/sunset1/city','bushmann'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.4, 0.4);
			bg.active = false;
			add(bg);


			var front:FlxSprite = new FlxSprite(-1500, -800).loadGraphic(Paths.image('back/main/sunset1/front','bushmann'));
			front.antialiasing = true;
			front.active = false;
			add(front);
				
			//	var forestground:FlxSprite = new FlxSprite(-600, -360).loadGraphic(Paths.image('back/main/sunset1/forest-ground','bushmann'));
			//	forestground.setGraphicSize(Std.int(forestground.width * 1.1));
			//	forestground.updateHitbox();
			//	forestground.antialiasing = true;
			//	forestground.scrollFactor.set(0.9, 0.9);
			//	forestground.active = false;
			//	add(forestground);
			
			}
			case 'forest-withpeople':
			{
				curStage = 'forest-withpeople';
				defaultCamZoom = 0.7;
				var bg:FlxSprite = new FlxSprite(-1200, -800).loadGraphic(Paths.image('back/main/sunset1/city','bushmann'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.4, 0.4);
				bg.active = false;
				add(bg);

				
				var front:FlxSprite = new FlxSprite(-1500, -800).loadGraphic(Paths.image('back/main/sunset1/front','bushmann'));
				front.antialiasing = true;
				front.active = false;
				add(front);

				var friendz:FlxSprite = new FlxSprite(-1500, -800).loadGraphic(Paths.image('back/main/sunset1/theboys2','bushmann'));
				friendz.antialiasing = true;
				friendz.active = false;
				add(friendz);
	//			var randomOcc = FlxG.random.int(0, 5);
	//			curStage = 'forest-withpeople';
	//			var bg:FlxSprite = new FlxSprite(-600, -360).loadGraphic(Paths.image('back/main/sunset1/forest' + randomOcc,'bushmann'));
	//			if(randomOcc == 5) {
	//				// code here
	//			}
	//			bg.antialiasing = true;
	//			bg.scrollFactor.set(0.9, 0.9);
	//			bg.active = false;
	//			add(bg);
	//			
	//			var forestground:FlxSprite = new FlxSprite(-600, -360).loadGraphic(Paths.image('back/main/sunset1/forest-ground','bushmann'));
	//			forestground.setGraphicSize(Std.int(forestground.width * 1.1));
	//			forestground.updateHitbox();
	//			forestground.antialiasing = true;
	//			forestground.scrollFactor.set(0.9, 0.9);
	//			forestground.active = false;
	//			add(forestground);
//
	//			var friendz:FlxSprite = new FlxSprite(-600, -360).loadGraphic(Paths.image('back/main/sunset1/theboys','bushmann'));
	//			friendz.setGraphicSize(Std.int(friendz.width * 1.1));
	//			friendz.updateHitbox();
	//			friendz.antialiasing = true;
	//			friendz.scrollFactor.set(0.9, 0.9);
	//			friendz.active = false;
	//			add(friendz);
			}
			case 'forest-night':
			{
	//			defaultCamZoom = 0.9;
	//			var randomOccNight = FlxG.random.int(0, 8);
	//			curStage = 'forest-night';
	//			var bg:FlxSprite = new FlxSprite(-600, -360).loadGraphic(Paths.image('back/main/night2/forest-night' + randomOccNight,'bushmann'));
	//			if(randomOccNight == 3) {
	//				// code here
	//			}
	//			bg.antialiasing = true;
	//			bg.scrollFactor.set(0.9, 0.9);
	//			bg.active = false;
	//			add(bg);
	//			
	//			var forestground:FlxSprite = new FlxSprite(-600, -360).loadGraphic(Paths.image('back/main/night2/forest-night-ground','bushmann'));
	//			forestground.setGraphicSize(Std.int(forestground.width * 1.1));
	//			forestground.updateHitbox();
	//			forestground.antialiasing = true;
	//			forestground.scrollFactor.set(0.9, 0.9);
	//			forestground.active = false;
	//			add(forestground);

	defaultCamZoom = 0.7;

	curStage = 'forest-night';

				var bg:FlxSprite = new FlxSprite(-1200, -800).loadGraphic(Paths.image('back/main/night2/nightground','bushmann'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.4, 0.4);
				bg.active = false;
				add(bg);


				var front:FlxSprite = new FlxSprite(-1500, -800).loadGraphic(Paths.image('back/main/night2/night-background','bushmann'));
				front.antialiasing = true;
				front.active = false;
				add(front);
				
			}
			case 'old': //haha look its old B)
			{
				defaultCamZoom = 0.9;
				curStage = 'old';
				var bg:FlxSprite = new FlxSprite(-600, -360).loadGraphic(Paths.image('back/funkystuff/old','bushmann'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);
			}
			case 'forest-cutscene':
			{
				defaultCamZoom = 0.9;
				curStage = 'forest-cutscene';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('back/cutscene/forest-cutscene','bushmann'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var forestcutground:FlxSprite = new FlxSprite(-600, -360).loadGraphic(Paths.image('back/cutscene/forest-cut-ground','bushmann'));
				forestcutground.setGraphicSize(Std.int(forestcutground.width * 1.1));
				forestcutground.updateHitbox();
				forestcutground.antialiasing = true;
				forestcutground.scrollFactor.set(0.9, 0.9);
				forestcutground.active = false;
				add(forestcutground);
			}	

			case 'witch':
			{
				defaultCamZoom = 0.9;
				curStage = 'witch';
				var bg:FlxSprite = new FlxSprite(-600, -360).loadGraphic(Paths.image('back/main/witch/forest-night','bushmann'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var fire = new FlxSprite(-600, -360);
				fire.frames = Paths.getSparrowAtlas('back/main/witch/fire','bushmann');
				fire.animation.addByPrefix('fire', 'fire', 2, true);
				fire.antialiasing = true;
				fire.updateHitbox();
				fire.animation.play("fire");
				if (FlxG.save.data.distractions)
				{
					add(fire);
				}

				var forestcutground:FlxSprite = new FlxSprite(-600, -360).loadGraphic(Paths.image('back/main/witch/forest-night-ground','bushmann'));
				forestcutground.setGraphicSize(Std.int(forestcutground.width * 1.1));
				forestcutground.updateHitbox();
				forestcutground.antialiasing = true;
				forestcutground.scrollFactor.set(0.9, 0.9);
				forestcutground.active = false;
				add(forestcutground);
			}	

			case 'philly': 
			{
				curStage = 'philly';

				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				if(FlxG.save.data.distractions){
					add(phillyCityLights);
				}

				for (i in 0...5)
				{
					var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain','week3'));
				add(streetBehind);

				phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train','week3'));
				if(FlxG.save.data.distractions){
					add(phillyTrain);
				}

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes','week3'));
				FlxG.sound.list.add(trainSound);

				// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street','week3'));
				add(street);
			}
			case 'limo':
			{
				curStage = 'limo';
				defaultCamZoom = 0.90;

				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset','week4'));
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);

				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo','week4');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);
				if(FlxG.save.data.distractions){
					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);

					for (i in 0...5)
					{
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
					}
				}

				var limoTex = Paths.getSparrowAtlas('limo/limoDrive','week4');

				limo = new FlxSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol','week4'));
				// add(limo);
			}
			case 'mall':
			{
				curStage = 'mall';

				defaultCamZoom = 0.80;

				var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls','week5'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				upperBoppers = new FlxSprite(-240, -90);
				upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop','week5');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				if(FlxG.save.data.distractions){
					add(upperBoppers);
				}


				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator','week5'));
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);

				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree','week5'));
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);

				bottomBoppers = new FlxSprite(-300, 140);
				bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop','week5');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				if(FlxG.save.data.distractions){
					add(bottomBoppers);
				}


				var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow','week5'));
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				add(fgSnow);

				santa = new FlxSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('christmas/santa','week5');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				if(FlxG.save.data.distractions){
					add(santa);
				}
			}
			case 'mallEvil':
			{
				curStage = 'mallEvil';
				var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG','week5'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree','week5'));
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);

				var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow",'week5'));
				evilSnow.antialiasing = true;
				add(evilSnow);
			}
			case 'school':
			{
				curStage = 'school';

				// defaultCamZoom = 0.9;

				var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky','week6'));
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				var repositionShit = -200;

				var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool','week6'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet','week6'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack','week6'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('weeb/weebTrees','week6');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals','week6');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();

				bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);

				if (curSong == 'roses')
				{
					if(FlxG.save.data.distractions){
						bgGirls.getScared();
					}
				}

				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				if(FlxG.save.data.distractions){
					add(bgGirls);
				}
			}
			case 'schoolEvil':
			{
				curStage = 'schoolEvil';

				var posX = 400;
				var posY = 200;

				var bg:FlxSprite = new FlxSprite(posX, posY);
				bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool','week6');
				bg.animation.addByPrefix('idle', 'background 2', 24);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 0.9);
				bg.scale.set(6, 6);
				add(bg);
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

		switch (SONG.gfVersion)
		{
			case 'gf-car':
				gfVersion = 'gf-car';
			case 'gf-christmas':
				gfVersion = 'gf-christmas';
			case 'gf-pixel':
				gfVersion = 'gf-pixel';
			default:
				gfVersion = 'gf';
		}

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

			case 'bushmann':
				camPos.y += 600;
				camPos.x += -50;
			case 'bushmann-angry':
				camPos.y += 600;
			case 'bush':
				camPos.x += 450;
				camPos.y += 450;
			case 'nikusa':
				camPos.x += 450;
				camPos.y += 450;

			case 'micspammer':
				camPos.x += 450;
			case 'pixel-bush':
				camPos.x += 450;
				case 'bf':
					camPos.y += 450;
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				if(FlxG.save.data.distractions){
					resetFastCar();
					add(fastCar);
				}

				case 'mall':
					boyfriend.x += 200;
	
				case 'mallEvil':
					boyfriend.x += 320;
					dad.y -= 80;
				case 'forest':
					dad.y -= 480;
					dad.x -= 500;
				case 'simp':
					dad.x -= 500;
					boyfriend.y += -500;
					
				case 'forest-night':
					dad.y -= 500;
					dad.x -= 500;
				case 'witch':
					dad.y -= 480;
					dad.x -= 500;
				case 'forest-withpeople':
					dad.y -= 480;
					dad.x -= 500;
				case 'forest-cutscene':
					dad.y -= 480;
					dad.x -= 500;
				case 'school':
					boyfriend.x += 200;
					boyfriend.y += 220;
					gf.x += 180;
					gf.y += 300;
				case 'schoolEvil':
					boyfriend.x += 200;
					boyfriend.y += 220;
					gf.x += 180;
					gf.y += 300;
		}

		bush = new Character(100, 100, "bush");

		add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);


		add(dad);
		add(boyfriend);
		if (loadRep)
		{
			botPlay = true;
			//FlxG.save.data.scrollSpeed = rep.replay.noteSpeed;
			downscroll = rep.replay.isDownscroll;
			// FlxG.watch.addQuick('Queued',inputsQueued);
		}

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong();

		trace('generated');

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
			if (downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);
			
			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, 90000);
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			songPosName = new FlxFixedText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (downscroll)
				songPosName.y -= 3;
			songPosName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songPosName.scrollFactor.set();
			add(songPosName);
			songPosName.cameras = [camHUD];
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxFixedText(4,healthBarBG.y + 50,0,SONG.song + " " + (storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy") + (Main.watermarks ? " - KE " + MainMenuState.kadeEngineVer : ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

        scoreTxt = new FlxFixedText(0, healthBarBG.y + 50, FlxG.width, "", 16);
        scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
        scoreTxt.scrollFactor.set();
        add(scoreTxt);

		replayTxt = new FlxFixedText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			replayTxt.cameras = [camHUD];
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxFixedText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (downscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		
		if(botPlay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		kadeEngineWatermark.cameras = [camHUD];

		currentTimingShown = new FlxFixedText(0, 0, 0, "0ms");
		currentTimingShown.borderStyle = OUTLINE;
		currentTimingShown.borderSize = 1;
		currentTimingShown.borderColor = FlxColor.BLACK;
		currentTimingShown.size = 20;
		currentTimingShown.cameras = [camHUD];

		startingSong = true;
		
		trace('starting');

		if (isStoryMode)
		{
			var dialogueFile = Paths.txt(curSong + '/dialogue');

			var dialogue:Array<String> = [];
			if(!showedDialogue && Paths.exists(dialogueFile)) {
				dialogue = CoolUtil.coolTextFile(dialogueFile);
			}

			var doof:DialogueSystem = new DialogueSystem(dialogue);
			doof.scrollFactor.set();
			doof.finishThing = startCountdown;
			doof.cameras = [camHUD];
			showedDialogue = true;

			if(dialogue.length != 0) {
				simpleDialogueIntro(doof);
			} else {
				startCountdown();
			}
		}
		else
		{
			startCountdown();
		}

		if (!loadRep)
			rep = new Replay("na");

		super.create();
	}

	function simpleDialogueIntro(?dialogueBox:DialogueSystem):Void
	{
		if (dialogueBox != null)
		{
			inCutscene = true;
			add(dialogueBox);
		}
		else
		{
			startCountdown();
		}
	}

	var startTimer:FlxTimer;

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		#if windows
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[PlayState.SONG.song]);
		}
		#end

		var introStuff:Array<Array<String>> = [
			['', 'intro3'],
			['ready', 'intro2'],
			['set', 'intro1'],
			['go', 'introGo']
		];
		var loops = introStuff.length + 1;

		startedCountdown = true;
		Conductor.songPosition = 0 - Conductor.crochet * loops;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			if(introStuff.length > swagCounter) {
				var item = introStuff[swagCounter];
				var sprite = item[0];
				var sound = item[1];

				if(sprite != "") {
					var spr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(sprite));
					spr.scrollFactor.set();
					spr.antialiasing = true;
					spr.updateHitbox();
					spr.screenCenter();
					add(spr);
					FlxTween.tween(spr, {alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							spr.destroy();
						}
					});
				}

				if(sound != "") {
					FlxG.sound.play(Paths.sound(sound), 0.6);
				}
			}

			swagCounter += 1;
		}, loops);
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
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			songPosBar.setRange(0, songLength - 1000);
			songPosBar.numDivisions = 1000;
		}

		// Song check real quick
		switch(curSong)
		{
			case 'bopeebo' | 'philly' | 'blammed' | 'cocoa' | 'eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}

		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + songDiscordText + " " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private function generateSong():Void
	{
		Conductor.changeBPM(SONG.bpm);

		vocals = new FlxSound();

		if (SONG.needsVoices)
			vocals = vocals.loadEmbedded(Paths.voices(curSong));

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		// pre lowercasing the song name (generateSong)
		// Per song offset check
		#if windows
		var songPath = 'assets/data/' + curSong + '/';
		var foundOffsetFile = false;
		for(file in sys.FileSystem.readDirectory(songPath))
		{
			var path = haxe.io.Path.join([songPath, file]);
			if(!sys.FileSystem.isDirectory(path))
			{
				if(path.endsWith('.offset'))
				{
					trace('Found offset file: ' + path);
					foundOffsetFile = true;
					songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
					break;
				}
			}
		}

		if(!foundOffsetFile) {
			songOffset = 0;
			trace('Offset file not found. Creating one @: ' + songPath);
			sys.io.File.saveContent(songPath + songOffset + '.offset', '');
		}
		#end

		#if debug
		var t0 = haxe.Timer.stamp();
		#end

		var dadNoteAsset = "NOTE_assets";
		var bfNoteAsset = "NOTE_assets";

		if (dad.curCharacter == "bushmann") dadNoteAsset = "BUSHYNOTE_assets";
		if (boyfriend.curCharacter == "pico") bfNoteAsset = "PICONOTE_assets";

		var noteData:Array<SwagSection> = SONG.notes;
		var offset:Float = FlxG.save.data.offset + songOffset;
		var halfWidth:Float = FlxG.width / 2;

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + offset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);
				var daNoteStyle:String = songNotes[3];
				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var asset = dadNoteAsset;
				if(gottaHitNote) asset = bfNoteAsset;

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[unspawnNotes.length - 1];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, asset);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set();

				unspawnNotes.push(swagNote);

				var susLength:Float = swagNote.sustainLength / Conductor.stepCrochet;
				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[unspawnNotes.length - 1];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, asset);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += halfWidth; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += halfWidth; // general offset
				}
			}
		}

		#if debug
		trace("Generate Notes: " + (haxe.Timer.stamp() - t0) + "s");
		#end

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
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
			babyArrow.antialiasing = true;
			babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

			babyArrow.x += Note.swagWidth * i;
			switch (i)
			{
				case 0:
					babyArrow.animation.addByPrefix('static', 'arrowLEFT');
					babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
				case 1:
					babyArrow.animation.addByPrefix('static', 'arrowDOWN');
					babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
				case 2:
					babyArrow.animation.addByPrefix('static', 'arrowUP');
					babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
				case 3:
					babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
					babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
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

			cpuStrums.forEach(function(spr:FlxSprite)
			{
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

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
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + songDiscordText + " " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
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
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + songDiscordText + " " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, songDiscordText + " " + Ratings.GenerateLetterRank(accuracy), iconRPC);
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
		DiscordClient.changePresence(detailsText + " " + songDiscordText + " " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	override public function update(elapsed:Float)
	{
		if (FlxG.save.data.botplay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;

		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
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

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (timeShown >= 19) {
			remove(currentTimingShown);
		} else {
			timeShown++;
			if (currentTimingShown.alpha != 0)
				currentTimingShown.alpha -= 0.02;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage) //MARKED FOR EVENTS MARKED FOR EVENTS MARKED FOR EVENTS MARKED FOR EVENTS MARKED FOR EVENTS MARKED FOR EVENTS MARKED FOR EVENTS MARKED FOR EVENTS MARKED FOR EVENTS MARKED FOR EVENTS MARKED FOR EVENTS MARKED FOR EVENTS MARKED FOR EVENTS 
		{
			
		}

		super.update(elapsed);

		if (!accuracyDisplay)
			scoreTxt.text = "Score: " + songScore;
		else
			scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState());
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		final iconOffset:Int = 26;

		var remappedHealth:Float = healthBar.x + (healthBar.width * ((100 - healthBar.percent) * 0.01));

		iconP1.x = remappedHealth - (iconOffset);
		iconP2.x = remappedHealth - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(new AnimationDebug(SONG.player2));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
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
			Conductor.songPosition += elapsed * 1000;
			songPositionBar = Conductor.songPosition;
		}


		if(curSong == "exasperate") {
			if(eventNum == 0 && Conductor.songPosition >= 48000) {
				eventNum++;
				defaultCamZoom = 1;
			}
		
			if(eventNum == 1 && Conductor.songPosition >= 66460) {
				eventNum++;
				defaultCamZoom = 0.7;
			}
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
						case 'philly':
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
						case 'bopeebo':
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
						case 'blammed':
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
						case 'cocoa':
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
						case 'eggnog':
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
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			var midpoint = dad.getMidpoint();

			if (camFollow.x != midpoint.x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					luaModchart.executeState('playerTwoTurn', []);
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(midpoint.x + 150 + offsetX, midpoint.y - 100 + offsetY);

				switch (dad.curCharacter)
				{
					case 'mom' | 'mom-car':
						camFollow.y = midpoint.y;
					case 'senpai' | 'senpai-angry':
						camFollow.y = midpoint.y - 430;
						camFollow.x = midpoint.x - 100;
						case 'bushmann':
							camFollow.y = midpoint.y - 800;
							case 'nikusa':
								camFollow.y = midpoint.y - 800;
							case 'bushmann-angry':
								camFollow.y = midpoint.y - 550;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;
			}

			midpoint = boyfriend.getMidpoint(midpoint);

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != midpoint.x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					luaModchart.executeState('playerOneTurn', []);
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(midpoint.x - 100 + offsetX, midpoint.y - 100 + offsetY);

				switch (curStage)
				{
					case 'limo':
						camFollow.x = midpoint.x - 300;
					case 'mall':
						camFollow.y = midpoint.y - 200;
					case 'school':
						camFollow.x = midpoint.x - 200;
						camFollow.y = midpoint.y - 200;
					case 'schoolEvil':
						camFollow.x = midpoint.x - 200;
						camFollow.y = midpoint.y - 200;
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

		if (curSong == 'fresh')
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
			}
		}

		else if (curSong == 'bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
			}
		}

		if (health <= 0 || (FlxG.save.data.resetButton && FlxG.keys.justPressed.R))
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();
			if(alternativeMusic != null) alternativeMusic.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + songDiscordText + " " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
		}

		while (unspawnNotes[0] != null && unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
		{
			var dunceNote:Note = unspawnNotes.shift();
			notes.add(dunceNote);
		}

		if (generatedMusic)
		{
			var speed = FlxMath.roundDecimal(SONG.speed, 2);
			var crochet = (60000 / SONG.bpm);
			var stepCrochet = crochet / 4;
			var diffY = 0.45 * speed * stepCrochet;
			notes.forEachAlive(function(daNote:Note)
			{	
				// instead of doing stupid y > FlxG.height
				// we be men and actually calculate the time :)
				if (daNote.tooLate)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				var noteData:Int = Math.floor(Math.abs(daNote.noteData));

				if (!daNote.modifiedByLua)
				{
					var noteY = if (daNote.mustPress)
						playerStrums.members[noteData].y;
					else
						strumLineNotes.members[noteData].y;

					var noteOffsetY = 0.45 * (Conductor.songPosition - daNote.strumTime) * speed;

					if (downscroll)
					{
						noteY += noteOffsetY;

						if(daNote.isSustainNote)
						{
							// Remember = minus makes notes go up, plus makes them go down
							if(daNote.prevNote != null && daNote.animation.curAnim.name.endsWith('end')) {
								if(daNote.prevNote.isSustainNote)
									noteY += daNote.prevNote.height * 1.5;
								else
									noteY += diffY + daNote.prevNote.height / 2;
								noteY -= daNote.height;
							}
							else
								noteY += daNote.height / 2;

							var shouldClip = botPlay;
							if(!shouldClip) shouldClip = (!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && noteY - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.halfSwagWidth);

							// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
							if(shouldClip)
							{
								// Clip to strumline
								var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
								swagRect.height = (strumLineNotes.members[noteData].y + Note.halfSwagWidth - noteY) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;

								daNote.clipRect = swagRect;
							}
						}
					}
					else
					{
						noteY -= noteOffsetY;

						if(daNote.isSustainNote)
						{
							// Remember = minus makes notes go up, plus makes them go down
							if(daNote.prevNote != null && daNote.animation.curAnim.name.endsWith('end')) {
								var noteOffset = daNote.prevNote.height / 2;
								if(daNote.prevNote.isSustainNote)
									noteY -= noteOffset;
								else
									noteY -= diffY - noteOffset;
							}
							else
								noteY -= daNote.height / 2;

							var shouldClip = botPlay;
							if(!shouldClip) shouldClip = (!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && noteY + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.halfSwagWidth);

							if(shouldClip)
							{
								// Clip to strumline
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (strumLineNotes.members[noteData].y + Note.halfSwagWidth - noteY) / daNote.scale.y;
								swagRect.height -= swagRect.y;

								daNote.clipRect = swagRect;
							}
						}
					}

					daNote.y = noteY;
				}
	

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (curSong != 'tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					switch (noteData)
					{
						case 0:
							dad.playAnim('singLEFT' + altAnim, true);
						case 1:
							dad.playAnim('singDOWN' + altAnim, true);
						case 2:
							dad.playAnim('singUP' + altAnim, true);
						case 3:
							dad.playAnim('singRIGHT' + altAnim, true);
					}
					
					if (lightCpuStrums)
					{
						cpuStrums.forEach(function(spr:FlxSprite)
						{
							if (noteData == spr.ID)
							{
								spr.animation.play('confirm', true);
							}

							spr.centerOffsets();

							if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
							{
								spr.offset.x -= 13;
								spr.offset.y -= 13;
							}
						});
					}

					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerTwoSing', [noteData, Conductor.songPosition]);
					#end

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.active = false;


					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				if(!daNote.modifiedByLua) {
					if(daNote.mustPress)
					{
						var strum = playerStrums.members[noteData];

						daNote.visible = strum.visible;
						daNote.x = strum.x;
						if (!daNote.isSustainNote)
							daNote.angle = strum.angle;
						else
							daNote.x += daNote.sustainXOff;
						daNote.alpha = strum.alpha;
					}
					else if(!daNote.wasGoodHit)
					{
						var strum = strumLineNotes.members[noteData];

						daNote.visible = strum.visible;
						daNote.x = strum.x;
						if (!daNote.isSustainNote)
							daNote.angle = strum.angle;
						else
							daNote.x += daNote.sustainXOff;
						daNote.alpha = strum.alpha;
					}
				}

				if (daNote.mustPress && daNote.tooLate)
				{
					if (!(daNote.isSustainNote && daNote.wasGoodHit))
					{
						health -= 0.075;
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

		if (lightCpuStrums)
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

		if (botPlay || loadRep)
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					//spr.centerOffsets();
				}
			});
		}

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function endSong():Void
	{
		if (!loadRep)
			rep.SaveReplay(saveNotes);

		if(PlayState.dad.curCharacter == "bushmann") {
			FlxG.sound.play(Paths.soundRandom("win", 1, 7));
		
		}
		if(PlayState.dad.curCharacter == "bushmann-angry") {
			FlxG.sound.play(Paths.soundRandom("win", 1, 7));
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if(alternativeMusic != null) alternativeMusic.volume = 0;
		#if !switch
		if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			Highscore.saveScore(curSong, songScore, storyDifficulty);
		}
		#end

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				FlxG.switchState(new StoryMenuState());

				if (SONG.validScore)
				{
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}
			}
			else
			{
				var difficulty:String = Highscore.formatSong("", storyDifficulty);

				trace('LOADING NEXT SONG');
				// pre lowercasing the next story song name
				var nextSongLowercase = PlayState.storyPlaylist[0].toLowerCase();
				trace(nextSongLowercase + difficulty);

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				PlayState.SONG = Song.loadFromJson(nextSongLowercase + difficulty, nextSongLowercase);
				FlxG.sound.music.stop();

				PlayState.showedDialogue = false;

				LoadingState.loadAndSwitchState(new PlayState());
			}
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
			FlxG.switchState(new FreeplayState());
		}
	}

	var endingSong:Bool = false;

	var timeShown:Int = 0;

	private function popUpScore(daNote:Note):Void
	{
		vocals.volume = 1;

		var noteDiff:Float = Conductor.songPosition - daNote.strumTime;

		if (accuracyMod == 1) {
			var wife:Float = EtternaFunctions.wife3(Math.abs(noteDiff), Conductor.timeScale);

			totalNotesHit += wife;
		}

		var daRating = daNote.rating;
		var score:Int = 350;

		switch(daRating)
		{
			case 'shit':
				score = -300;
				combo = 0;
				misses++;
				health -= 0.2;
				shits++;
				if (accuracyMod == 0)
					totalNotesHit += 0.25;
			case 'bad':
				score = 0;
				health -= 0.06;
				bads++;
				if (accuracyMod == 0)
					totalNotesHit += 0.50;
			case 'good':
				score = 200;
				goods++;
				if (health < 2)
					health += 0.04;
				if (accuracyMod == 0)
					totalNotesHit += 0.75;
			case 'sick':
				sicks++;
				if (health < 2)
					health += 0.1;
				if (accuracyMod == 0)
					totalNotesHit += 1;
		}

		songScore += score;
		songScoreDef += ConvertScore.convertScore(noteDiff);

		var rating:FlxSprite = new FlxSprite();
		rating.loadGraphic(ratingImages[daRating]);

		if (FlxG.save.data.changedHit)
		{
			rating.x = FlxG.save.data.changedHitX;
			rating.y = FlxG.save.data.changedHitY;
		}
		else
		{
			rating.screenCenter(Y);
			rating.y -= 50;
			rating.x = (FlxG.width * 0.55) - 125;
		}
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var msTiming:Float = 0;

		//if(!botPlay)
			msTiming = HelperFunctions.truncateFloat(noteDiff, 3);

		remove(currentTimingShown);

		timeShown = 0;
		currentTimingShown.color = switch(daRating)
		{
			case 'shit' | 'bad': FlxColor.RED;
			case 'good': FlxColor.GREEN;
			case 'sick': FlxColor.CYAN;
			default: FlxColor.WHITE;
		}
		currentTimingShown.text = msTiming + "ms";

		if (currentTimingShown.alpha != 1)
			currentTimingShown.alpha = 1;

		/*if(!botPlay) */add(currentTimingShown);

		currentTimingShown.x = rating.x + 100;
		currentTimingShown.y = rating.y + 100;
		currentTimingShown.acceleration.y = 600;
		// Maybe need to make this 0 first
		currentTimingShown.velocity.y -= 150;

		currentTimingShown.velocity.x += FlxG.random.int(1, 10);
		if(!botPlay) add(rating);

		rating.setGraphicSize(Std.int(rating.width * 0.7));
		rating.antialiasing = true;

		currentTimingShown.updateHitbox();
		rating.updateHitbox();

		rating.cameras = [camHUD];
		currentTimingShown.cameras = [camHUD];

		var seperatedScore:Array<Int> = [];

		var comboSplit:Array<String> = (combo + "").split('');

		// make sure we have 3 digits to display (looks weird otherwise lol)
		if (comboSplit.length == 1)
		{
			seperatedScore.push(0);
			seperatedScore.push(0);
		}
		else if (comboSplit.length == 2)
			seperatedScore.push(0);

		for(i in 0...comboSplit.length)
		{
			var str:String = comboSplit[i];
			seperatedScore.push(Std.parseInt(str));
		}

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(comboImages[i]);
			numScore.x = rating.x + (43 * daLoop) - 50;
			numScore.y = rating.y + 100;
			numScore.cameras = [camHUD];

			numScore.antialiasing = true;
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

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

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001,
			onComplete: function(tween:FlxTween)
			{
				rating.destroy();
			}
		});
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	private function keyShit():Void // I've invested in emma stocks
	{
		// control arrays, order L D R U
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var pressArray:Array<Bool> = [
			controls.LEFT_P,
			controls.DOWN_P,
			controls.UP_P,
			controls.RIGHT_P
		];
		var releaseArray:Array<Bool> = [
			controls.LEFT_R,
			controls.DOWN_R,
			controls.UP_R,
			controls.RIGHT_R
		];
		#if windows
		if (luaModchart != null){
		if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
		if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
		if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
		if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
		};
		#end

		// Prevent player input if botplay is on
		if(botPlay)
		{
			holdArray = [false, false, false, false];
			pressArray = [false, false, false, false];
			releaseArray = [false, false, false, false];
		}
		// HOLDS, check for sustain notes
		if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
					goodNoteHit(daNote);
			});
		}

		// PRESSES, check for note hits
		if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = []; // notes that can be hit
			var dumbNotes:Array<Note> = []; // notes to kill later
			var directionList:Array<Bool> = [false,false,false,false]; // directions that can be hit
			var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					if (!directionsAccounted[daNote.noteData])
					{
						if (directionList[daNote.noteData])
						{
							directionsAccounted[daNote.noteData] = true;
							for (coolNote in possibleNotes)
							{
								if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
								{ // if it's the same note twice at < 10ms distance, just delete it
									// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
									dumbNotes.push(daNote);
									break;
								}
								else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
								{ // if daNote is earlier than existing note (coolNote), replace
									possibleNotes.remove(coolNote);
									possibleNotes.push(daNote);
									break;
								}
							}
						}
						else
						{
							possibleNotes.push(daNote);
							directionList[daNote.noteData] = true;
						}
					}
				}
			});

			for (note in dumbNotes)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}

			var dontCheck = false;

			for (i in 0...pressArray.length)
			{
				if (pressArray[i] && !directionList[i]) {
					dontCheck = true;
					break;
				}
			}

			if (!dontCheck && possibleNotes.length > 0)
			{
				if (!ghostTapping)
				{
					for (shit in 0...pressArray.length)
					{ // if a direction is hit that shouldn't be
						if (pressArray[shit] && !directionList[shit])
							noteMiss(shit, null);
					}
				}
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
				for (coolNote in possibleNotes)
				{
					if (pressArray[coolNote.noteData])
					{
						if (mashViolations != 0)
							mashViolations--;
						scoreTxt.color = FlxColor.WHITE;
						goodNoteHit(coolNote);
					}
				}
			}
			else if (!ghostTapping)
			{
				for (shit in 0...pressArray.length)
					if (pressArray[shit])
						noteMiss(shit, null);
			}

			if(dontCheck && possibleNotes.length > 0 && ghostTapping && !botPlay)
			{
				if (mashViolations > 8)
				{
					trace('mash violations ' + mashViolations);
					scoreTxt.color = FlxColor.RED;
					noteMiss(0, null);
				}
				else
					mashViolations++;
			}
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (botPlay || loadRep || !holdArray.contains(true)))
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				boyfriend.playAnim('idle');
		}

		botplayCode();

		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
				spr.animation.play('pressed');
			if (!(botPlay || loadRep) && !holdArray[spr.ID])
				spr.animation.play('static');

			spr.centerOffsets();

			if (spr.animation.curAnim.name == 'confirm')
			{
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
		});
	}
	
	function botplayCode() {
		if(botPlay || loadRep) {
			notes.forEachAlive(function(daNote:Note)
			{
				if(Conductor.songPosition - daNote.strumTime > -8.3333) // -8.3333 since 1000 / UpdateFPS
				{
					// Force good note hit regardless if it's too late to hit it or not as a fail safe
					if(daNote.mustPress && (daNote.canBeHit || daNote.tooLate))
					{
						var didHit = false;
						if(loadRep)
						{
							if(rep.replay.songNotes.contains(HelperFunctions.truncateFloat(daNote.strumTime, 2))) {
								didHit = true;
							}
						} else {
							didHit = true;
						}

						if(didHit) {
							goodNoteHit(daNote);
							boyfriend.holdTimer = 0;
						}
					}
				}
			});
		}
	}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			if (accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			var sound = missSounds[FlxG.random.int(0, missSounds.length - 1)];

			FlxG.sound.play(sound, FlxG.random.float(0.1, 0.2));

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

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end

			updateAccuracy();
		}
	}

	function updateAccuracy() 
	{
		totalPlayed += 1;
		accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
		accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
	}

	var mashViolations:Int = 0;

	function goodNoteHit(note:Note, resetMashViolation = true):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

		note.rating = Ratings.CalculateRating(noteDiff);

		if(note.rating == "miss")
			return;

		// add newest note to front of notesHitArray
		// the oldest notes are at the end and are removed first
		if (!note.isSustainNote)
			notesHitArray.unshift(Date.now());

		if (!resetMashViolation && mashViolations >= 1)
			mashViolations--;

		if (mashViolations < 0)
			mashViolations = 0;

		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				combo += 1;
				popUpScore(note);
			}
			else
				totalNotesHit += 1;

			switch (note.noteData)
			{
				case 0:
					boyfriend.playAnim('singLEFT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
			#end

			if(!loadRep && note.mustPress)
				saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();

			updateAccuracy();
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if(FlxG.save.data.distractions){
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if(FlxG.save.data.distractions){
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

	}

	function trainReset():Void
	{
		if(FlxG.save.data.distractions){
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
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

	var danced:Bool = false;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + songDiscordText + " " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
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
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.curCharacter != 'gf')
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
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
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && curSong == 'tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		switch (curStage)
		{
			case 'school':
				if(FlxG.save.data.distractions){
					bgGirls.dance();
				}

			case 'mall':
				if(FlxG.save.data.distractions){
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case 'limo':
				if(FlxG.save.data.distractions){
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});
		
						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
				}
			case "philly":
				if(FlxG.save.data.distractions){
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
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}
	}

	var curLight:Int = 0;
}
