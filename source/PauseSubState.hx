package;

import openfl.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Restart With Dialogue', 'Exit to menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	#if sys
	var perSongOffset:FlxText;

	var offsetChanged:Bool = false;
	var lastOffset:Float = 0;
	var oldOffset:Float = 0;
	#end

	public function new()
	{
		super();

		if(!PlayState.isStoryMode) {
			menuItems = ['Resume', 'Restart Song', 'Exit to menu'];
		}

		#if sys
		oldOffset = lastOffset = PlayState.songOffset;
		#end
		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += Difficulty.fromInt(PlayState.storyDifficulty);
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		#if sys
		perSongOffset = new FlxText(5, FlxG.height - 18, 0, "Additive Offset (Left, Right): " + PlayState.songOffset + " - Description - " + 'Adds value to global offset, per song.', 12);
		perSongOffset.scrollFactor.set();
		perSongOffset.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(perSongOffset);
		#end

		remakeItems();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var accepted = controls.ACCEPT;

		if (controls.UP_P)
			changeSelection(-1);
		else if (controls.DOWN_P)
			changeSelection(1);

		#if sys
		else if (controls.LEFT_P)
		{
			PlayState.songOffset -= 1;
		}
		else if (controls.RIGHT_P)
		{
			PlayState.songOffset += 1;
		}

		// Prevent loop from happening every single time the offset changes
		if(accepted && oldOffset != PlayState.songOffset) {
			var songPath = 'assets/data/' + PlayState.instance.curSong + '/';
			trace('Changing Offset from $oldOffset to ${PlayState.songOffset}');
			sys.FileSystem.rename(songPath + oldOffset + '.offset', songPath + PlayState.songOffset + '.offset');
		}

		if(lastOffset != PlayState.songOffset) {
			perSongOffset.text = "Additive Offset (Left, Right): " + PlayState.songOffset + " - Description - Adds the value to offset on the song.";
			lastOffset = PlayState.songOffset;

			if(!offsetChanged)
			{
				if(PlayState.isStoryMode) {
					menuItems = ['Restart Song', 'Restart With Dialogue', 'Exit to menu'];
				} else {
					menuItems = ['Restart Song', 'Exit to menu'];
				}
				remakeItems();

				offsetChanged = true;
			}
			else if(PlayState.songOffset == oldOffset)
			{
				if(PlayState.isStoryMode) {
					menuItems = ['Resume', 'Restart Song', 'Restart With Dialogue', 'Exit to menu'];
				} else {
					menuItems = ['Resume', 'Restart Song', 'Exit to menu'];
				}
				remakeItems();

				offsetChanged = false;
			}
			cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		}
		#end

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					close();
				case "Restart Song":
					FlxG.resetState();
				case "Exit to menu":
					PlayState.loadRep = false;
					#if windows
					if (PlayState.luaModchart != null)
					{
						PlayState.luaModchart.die();
						PlayState.luaModchart = null;
					}
					#end
					if (FlxG.save.data.fpsCap > 290)
						(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

					FlxG.switchState(new MainMenuState());
			}
		}
	}

	function remakeItems() {
		grpMenuShit.clear();

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected = HelperFunctions.mod(curSelected + change, menuItems.length);

		var i = 0;
		for (item in grpMenuShit.members)
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
