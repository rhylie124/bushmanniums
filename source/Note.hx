package;

import flixel.FlxG;
import flixel.FlxSprite;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;
	public var sustainXOff:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var rawNoteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var modifiedByLua:Bool = false;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteStyle:String = 'normal';

	public static var swagWidth:Float = 160 * 0.7;
	public static var halfSwagWidth:Float = swagWidth / 2;

	public var rating:String = "shit";

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, noteAsset:String = "NOTE_assets", noteStyle:String = 'normal')
	{
		super();
		this.noteStyle = noteStyle;
		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;

		if (strumTime < 0)
			this.strumTime = 0;
		else
			this.strumTime = strumTime;

		this.noteData = noteData;

		switch (PlayState.SONG.noteStyle)
		{
			default:
				var daPath:String = noteAsset;
				switch(noteStyle) {
					case 'warning':
						daPath = "WARNINGWARNINGBROWARNING";
					case 'death':
						daPath = "KILLARROWSBROKILLARROWS";

				}
				frames = Paths.getSparrowAtlas(daPath);

				if(isSustainNote) {
					animation.addByPrefix('purpleholdend', 'pruple end hold');
					animation.addByPrefix('greenholdend', 'green hold end');
					animation.addByPrefix('redholdend', 'red hold end');
					animation.addByPrefix('blueholdend', 'blue hold end');

					animation.addByPrefix('purplehold', 'purple hold piece');
					animation.addByPrefix('greenhold', 'green hold piece');
					animation.addByPrefix('redhold', 'red hold piece');
					animation.addByPrefix('bluehold', 'blue hold piece');
				} else {
					animation.addByPrefix('greenScroll', 'green0');
					animation.addByPrefix('redScroll', 'red0');
					animation.addByPrefix('blueScroll', 'blue0');
					animation.addByPrefix('purpleScroll', 'purple0');
				}

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;
		}

		x += swagWidth * noteData;

		if(!isSustainNote) {
			switch (noteData)
			{
				case 0: animation.play('purpleScroll');
				case 1: animation.play('blueScroll');
				case 2: animation.play('greenScroll');
				case 3: animation.play('redScroll');
			}
		}

		// trace(prevNote);

		// we make sure its downscroll and its a SUSTAIN NOTE (aka a trail, not a note)
		// and flip it so it doesn't look weird.
		// THIS DOESN'T FUCKING FLIP THE NOTE, CONTRIBUTERS DON'T JUST COMMENT THIS OUT JESUS
		if (sustainNote && PlayState.instance.downscroll)
			flipY = true;

		if (isSustainNote && prevNote != null)
		{
			canHitTimingEarly = Conductor.safeZoneOffset * 1.5;
			canHitTimingLate = Conductor.safeZoneOffset * 0.5;

			var oldX = x;
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 0: animation.play('purpleholdend');
				case 1: animation.play('blueholdend');
				case 2: animation.play('greenholdend');
				case 3: animation.play('redholdend');
			}

			updateHitbox();

			x -= width / 2;

			sustainXOff = x - oldX;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0: prevNote.animation.play('purplehold');
					case 1: prevNote.animation.play('bluehold');
					case 2: prevNote.animation.play('greenhold');
					case 3: prevNote.animation.play('redhold');
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	var missOff = Conductor.safeZoneOffset * Conductor.timeScale;
	var canHitTimingEarly = Conductor.safeZoneOffset;
	var canHitTimingLate = Conductor.safeZoneOffset;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			canBeHit = (strumTime > Conductor.songPosition - canHitTimingEarly && strumTime < Conductor.songPosition + canHitTimingLate);

			if (strumTime < Conductor.songPosition - missOff && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}