package;

import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
#if sys
import sys.io.File;
#end

class LoadReplayState extends MusicBeatState
{
	var curSelected:Int = 0;

	var songs:Array<FreeplayState.SongMetadata> = [];

	var controlsStrings:Array<String> = [];
	var actualNames:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxFixedText;
	var poggerDetails:FlxFixedText;
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		#if sys
		controlsStrings = sys.FileSystem.readDirectory(Sys.getCwd() + "/assets/replays/");
		#end
		trace(controlsStrings);

		controlsStrings.sort(Reflect.compare);

		for(i in 0...controlsStrings.length)
		{
			var string:String = controlsStrings[i];
			actualNames[i] = string;
			var rep:Replay = Replay.LoadReplay(string);
			controlsStrings[i] = string.split("time")[0] + " " + Difficulty.fromInt(rep.replay.songDiff).toUpperCase();
		}

		if (controlsStrings.length == 0)
			controlsStrings.push("No Replays...");

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		versionShit = new FlxFixedText(5, FlxG.height - 34, 0, "Replay Loader (ESCAPE TO GO BACK)\nNOTICE!!!! Replays are in a beta stage, and they are probably not 100% correct. expect misses and other stuff that isn't there!", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		poggerDetails = new FlxFixedText(5, 34, 0, "Replay Details - \nnone", 12);
		poggerDetails.scrollFactor.set();
		poggerDetails.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(poggerDetails);

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
			FlxG.switchState(new OptionsMenu());
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);


		if (controls.ACCEPT && grpControls.members[curSelected].text != "No Replays...")
		{
			trace('loading ' + actualNames[curSelected]);
			PlayState.rep = Replay.LoadReplay(actualNames[curSelected]);

			PlayState.loadRep = true;

			var poop:String = Highscore.formatSong(PlayState.rep.replay.songName.toLowerCase(), PlayState.rep.replay.songDiff);

			PlayState.SONG = Song.loadFromJson(poop, PlayState.rep.replay.songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = PlayState.rep.replay.songDiff;
			PlayState.storyWeek = PlayState.rep.replay.weekNum;
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected = HelperFunctions.mod(curSelected + change, grpControls.length);

		var rep:Replay = Replay.LoadReplay(actualNames[curSelected]);

		poggerDetails.text = "Replay Details - \nDate Created: " + rep.replay.timestamp + "\nSong: " + rep.replay.songName + "\nReplay Version: " + (rep.replay.replayGameVer != Replay.version ? "OUTDATED" : "Latest");

		var i:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = i - curSelected;
			i++;

			if (item.targetY == 0)
				item.alpha = 1;
			else
				item.alpha = 0.6;
		}
	}
}
