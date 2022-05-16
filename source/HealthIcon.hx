package;

import flixel.FlxG;
import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		antialiasing = true;

		loadGraphic(Paths.image('iconGrid'), true, 150, 150);
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bf-car', [0, 1], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
		animation.add('spooky', [2, 3], 0, false, isPlayer);
		animation.add('pico', [4, 5], 0, false, isPlayer);
		animation.add('mom', [6, 7], 0, false, isPlayer);
		animation.add('mom-car', [6, 7], 0, false, isPlayer);
		animation.add('tankman', [8, 9], 0, false, isPlayer);
		animation.add('face', [10, 11], 0, false, isPlayer);
		animation.add('dad', [12, 13], 0, false, isPlayer);
		animation.add('senpai', [22, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
		animation.add('spirit', [23, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('gf-christmas', [16], 0, false, isPlayer);
		animation.add('gf-pixel', [16], 0, false, isPlayer);
		animation.add('parents-christmas', [17, 18], 0, false, isPlayer);
		animation.add('monster', [19, 20], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
		animation.add('bush', [28, 29], 0, false, isPlayer);
		animation.add('bushmann', [24, 25], 0, false, isPlayer);
		animation.add('bushmann-angry', [26, 27], 0, false, isPlayer);
		animation.add('bushmann-expurgation', [26, 27], 0, false, isPlayer);
		animation.add('pixel-bush', [24, 24], 0, false, isPlayer);
		animation.add('micspammer', [24, 24], 0, false, isPlayer);
		animation.add('nikusa', [30, 31], 0, false, isPlayer);
		animation.add('koki', [32, 33], 0, false, isPlayer);
		animation.add('3d-boshmann', [34, 35], 0, false, isPlayer);
		animation.add('3d-bushmann', [36, 37], 0, false, isPlayer);
		animation.add('old-bushmann', [38, 39], 0, false, isPlayer);
		animation.add('jojo-nikku', [40, 41], 0, false, isPlayer);
		animation.add('nikku', [40, 41], 0, false, isPlayer);
		animation.add('dynamic', [42, 43], 0, false, isPlayer);
		animation.add('scottmann', [44, 45], 0, false, isPlayer);
		animation.add('boshmann', [46, 47], 0, false, isPlayer);
		animation.add('shaggy', [48, 49], 0, false, isPlayer);
		animation.add('sniper', [50, 51], 0, false, isPlayer);
		animation.add('snipergamer', [52, 53], 0, false, isPlayer);
		animation.add('bushmann-short', [24, 25], 0, false, isPlayer);
		animation.add('bushmann-really-angry', [26, 27], 0, false, isPlayer);
		animation.add('koki-bot-duo', [54, 55], 0, false, isPlayer);
		animation.play(char);

		switch(char)
		{
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel' | 'pixel-bush':
				antialiasing = false;
		}

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
