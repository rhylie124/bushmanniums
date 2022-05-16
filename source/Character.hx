package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Float>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Float>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('characters/gfChristmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-car':
				tex = Paths.getSparrowAtlas('characters/gfCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
				case 'nikusa':
					//sugar ratio if you have the nikusa fla give me it so i can remove boba jiggles
					tex = Paths.getSparrowAtlas('characters/otherchar/AAAA_NIKUSAA', 'shared');
					frames = tex;
					animation.addByPrefix('idle', 'NikusaIdle', 24);
					animation.addByPrefix('singUP', 'NikusaUp', 24);
					animation.addByPrefix('singRIGHT', 'NikusaRight', 24);
					animation.addByPrefix('singDOWN', 'NikusaDown', 24);
					animation.addByPrefix('singLEFT', 'NikusaLeft', 24);
	
					addOffset('idle', 181, 474);
					addOffset("singUP", 171, 528);
					addOffset("singRIGHT", 178, 499);
					addOffset("singLEFT", 181, 474);
					addOffset("singDOWN", 195, 477);
	
					playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('characters/spooky_kids_assets');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				playAnim('danceRight');
			case 'mom':
				tex = Paths.getSparrowAtlas('characters/Mom_Assets');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('characters/momCar');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');
				case 'jojo-nikku':
					tex = Paths.getSparrowAtlas('characters/otherchar/Nikku_Updated');
					frames = tex;
	
					animation.addByPrefix('idle', "Idle", 24, false);
					animation.addByPrefix('singUP', "Up", 24, false);
					animation.addByPrefix('singDOWN', "Down", 24, false);
					animation.addByPrefix('singLEFT', 'Left', 24, false);
					animation.addByPrefix('singRIGHT', 'Right', 24, false);
	
					addOffset('idle', -3, 0);
					addOffset("singUP", 57, 80);
					addOffset("singRIGHT", -36, -60);
					addOffset("singLEFT", 150, -110);
					addOffset("singDOWN", -45, -89);
	
					playAnim('idle');
					case 'dynamic':
					tex = Paths.getSparrowAtlas('characters/otherchar/dynamic');
					frames = tex;
	
					animation.addByPrefix('idle', "Dynamic Idle", 24, false);
					animation.addByPrefix('singUP', "Dynamic Up", 24, false);
					animation.addByPrefix('singDOWN', "Dynamic Down", 24, false);
					animation.addByPrefix('singLEFT', 'Dynamic Left', 24, false);
					animation.addByPrefix('singRIGHT', 'Dynamic Right', 24, false);
	
					addOffset('idle', 31, 69);
					addOffset("singUP", 30, 80);
					addOffset("singRIGHT", 27, 52);
					addOffset("singLEFT", 38, 54);
					addOffset("singDOWN", 30, 46);
	
					playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('characters/Monster_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('characters/monsterChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);

				playAnim('idle');

				flipX = true;

			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('characters/bfChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('characters/bfCar');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				playAnim('idle');

				flipX = true;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				playAnim('idle');

			case 'bushmann': // CAN I PUT MY BALLS IN YO JAWS, BALLS IN YO JAWS, CAN I (CAN I), CAN I (CAN I)
				// bushy ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/bush/bushmann', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'bushmann idle lol', 24);
				animation.addByPrefix('singUP', 'bushmann up', 24);
				animation.addByPrefix('singRIGHT', 'bushmann right', 24);
				animation.addByPrefix('singDOWN', 'bushmann down', 24);
				animation.addByPrefix('singLEFT', 'bushmann left', 24);

				addOffset("idle", 0, 0);
				addOffset("singUP", 60, 90);
				addOffset("singRIGHT", 27, -117);
				addOffset("singLEFT", 160, -268);
				addOffset("singDOWN", 180, -420);

				playAnim('idle');
				case 'bushmann-really-angry': // CAN I PUT MY BALLS IN YO JAWS, BALLS IN YO JAWS, CAN I (CAN I), CAN I (CAN I)
				// bushy ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/bush/pissed-offb', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24);
				animation.addByPrefix('singUP', 'up', 24);
				animation.addByPrefix('singRIGHT', 'right', 24);
				animation.addByPrefix('singDOWN', 'down', 24);
				animation.addByPrefix('singLEFT', 'left', 24);

				addOffset("idle", 0, 0);
				addOffset("singUP", 60, 90);
				addOffset("singRIGHT", 27, -117);
				addOffset("singLEFT", 160, -268);
				addOffset("singDOWN", 180, -420);
				setGraphicSize(Std.int(width * 1.5));
				updateHitbox();
				playAnim('idle');

				case 'sniper': // CAN I PUT MY BALLS IN YO JAWS, BALLS IN YO JAWS, CAN I (CAN I), CAN I (CAN I)
				// bushy ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/otherchar/sniper', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24);
				animation.addByPrefix('singUP', 'up', 24);
				animation.addByPrefix('singRIGHT', 'right', 24);
				animation.addByPrefix('singDOWN', 'down', 24);
				animation.addByPrefix('singDOWN-alt', 'laugh', 24);
				animation.addByPrefix('singLEFT', 'left', 24);

				addOffset("idle", 0, 0);
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);
				addOffset("singDOWN-alt", 0, 0);
				playAnim('idle');
			
				case 'shaggy': // CAN I PUT MY BALLS IN YO JAWS, BALLS IN YO JAWS, CAN I (CAN I), CAN I (CAN I)
				// bushy ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/otherchar/shaggy', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'shaggy_idle', 24);
				animation.addByPrefix('singUP', 'shaggy_up', 24);
				animation.addByPrefix('singRIGHT', 'shaggy_right', 24);
				animation.addByPrefix('singDOWN', 'shaggy_down', 24);
				animation.addByPrefix('singLEFT', 'shaggy_left', 24);

				addOffset("idle", 0, 0);
				addOffset("singUP", -16, 27);
				addOffset("singRIGHT", -1, -38);
				addOffset("singLEFT", 165, -114);
				addOffset("singDOWN", -10, -160);
				playAnim('idle');


				case 'bushmann-short': // CAN I PUT MY BALLS IN YO JAWS, BALLS IN YO JAWS, CAN I (CAN I), CAN I (CAN I)
				// bushy ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/bush/smaller-bushmann', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'bushmann idle lol', 24);
				animation.addByPrefix('singUP', 'bushmann up', 24);
				animation.addByPrefix('singRIGHT', 'bushmann right', 24);
				animation.addByPrefix('singDOWN', 'bushmann down', 24);
				animation.addByPrefix('singLEFT', 'bushmann left', 24);

				addOffset("idle", 0, 0);
				addOffset("singUP", 60, 90);
				addOffset("singRIGHT", 27, -117);
				addOffset("singLEFT", 160, -268);
				addOffset("singDOWN", 180, -420);

				playAnim('idle');


			case 'bush':
				// bush ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/bush/alivebush', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'bushin', 24);
				animation.addByPrefix('singUP', 'bushy up', 24);
				animation.addByPrefix('singRIGHT', 'bushy right', 24);
				animation.addByPrefix('singDOWN', 'bushy down', 24);
				animation.addByPrefix('singLEFT', 'bushy left', 24);
				
				addOffset("idle", -1, 20);
				addOffset("singUP", -93, 76);
				addOffset("singRIGHT", -71, 21);
				addOffset("singLEFT", -80, 16);
				addOffset("singDOWN", -54, 1);
				setGraphicSize(Std.int(width * 1));
				updateHitbox();
				playAnim('idle');

			case 'micspammer':
				// M I C S P A M
				tex = Paths.getSparrowAtlas('characters/bush/micspammer', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'pain', 24);
				animation.addByPrefix('singUP', 'god', 24);
				animation.addByPrefix('singRIGHT', 'fucking', 24);
				animation.addByPrefix('singDOWN', 'oh', 24);
				animation.addByPrefix('singLEFT', 'my', 24);
				
				addOffset("idle", -1, 20);
				addOffset("singUP", -1, 20);
				addOffset("singRIGHT", -1, 20);
				addOffset("singLEFT", -1, 20);
				addOffset("singDOWN", -1, 20);
				playAnim('idle');

			case 'pixel-bush':
				// pixelated
				tex = Paths.getSparrowAtlas('characters/bush/bushmann-pixel', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'pixelated idle', 24);
				animation.addByPrefix('singUP', 'pixelated up', 24);
				animation.addByPrefix('singRIGHT', 'pixelated right', 24);
				animation.addByPrefix('singDOWN', 'pixelated down', 24);
				animation.addByPrefix('singLEFT', 'pixelated left', 24);
				
				addOffset("idle", -1, 20);
				addOffset("singUP", -93, 76);
				addOffset("singRIGHT", -71, 21);
				addOffset("singLEFT", -80, 16);
				addOffset("singDOWN", -54, 1);
				antialiasing = false;

				setGraphicSize(Std.int(width * 4));
				updateHitbox();

				playAnim('idle');

			case 'bushmann-angry':
				// abush ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/bush/bushisfuckingmad', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'bushmann fucking mad', 24);
				animation.addByPrefix('singUP', 'bushmann angry up', 24);
				animation.addByPrefix('singRIGHT', 'bushmann angry right', 24);
				animation.addByPrefix('singDOWN', 'bushmann angry down', 24);
				animation.addByPrefix('singLEFT', 'bushmann angry left', 24);
				setGraphicSize(Std.int(width * 1.3));
				updateHitbox();
			//	addOffset("idle", -1, 20);
			//	addOffset("singUP", -93, 76);
			//	addOffset("singRIGHT", -71, 21);
			//	addOffset("singLEFT", -80, 16);
			//	addOffset("singDOWN", -54, 1);
			//	addOffset("singUP-alt", -93, 76);
			//	addOffset("singRIGHT-alt", -71, 21);
			//	addOffset("singLEFT-alt", -80, 16);
			//	addOffset("singDOWN-alt", -54, 1);
				addOffset("idle", 0, 50);
				addOffset("singUP", 0, 50);
				addOffset("singRIGHT", 0, 50);
				addOffset("singLEFT", 0, 50);
				addOffset("singDOWN", 0, 50);

				//setGraphicSize(Std.int(width * 1.4));
				//updateHitbox();

				playAnim('idle');
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				var oldRightOffsets = animOffsets['singRIGHT'];
				animOffsets['singRIGHT'] = animOffsets['singLEFT'];
				animOffsets['singLEFT'] = oldRightOffsets;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;

					var oldRightOffsets = animOffsets['singRIGHTmiss'];
					animOffsets['singRIGHTmiss'] = animOffsets['singLEFTmiss'];
					animOffsets['singLEFTmiss'] = oldRightOffsets;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-christmas' | 'gf-car' | 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(animName:String, force:Bool = false, reversed:Bool = false, frame:Int = 0):Void
		{
			animation.play(animName, force, reversed, frame);
	
			var daOffset = animOffsets.get(animName);
			if (daOffset != null)
				offset.set(daOffset[0] * (flipX?-1:1), daOffset[1]);
			else
				offset.set(0, 0);
	
			if (curCharacter == 'gf')
			{
				if (animName == 'singLEFT')
				{
					danced = true;
				}
				else if (animName == 'singRIGHT')
				{
					danced = false;
				}
	
				else if (animName == 'singUP' || animName == 'singDOWN')
				{
					danced = !danced;
				}
			}
		}

	public inline function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
