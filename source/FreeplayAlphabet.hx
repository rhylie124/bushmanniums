package;

import flixel.FlxG;
import flixel.math.FlxMath;

class FreeplayAlphabet extends Alphabet {
    public var index:Int;
    public var yMult:Float = 120;
    public var yAdd:Float = 0;
    public var instant:Bool = true;

    public function new(x:Float, y:Float, text:String = "", ?bold:Bool = false, typed:Bool = false)
    {
        super(x, y, text, bold, typed);
    }

    override function update(elapsed:Float)
    {
        var scaledY = targetY * 1.3;

        var lerpVal:Float = 0.16;//CoolUtil.boundTo(elapsed * 0.16 * 60, 0, 1);

        var wantedY = (scaledY * yMult) + (FlxG.height * 0.5) - height/2 + yAdd;

        y = FlxMath.lerp(y, wantedY, lerpVal);
        if(instant) {
            y = wantedY;
        }

        //var d = y - FlxG.height/2 + height/2;
        //var wantedX = -d * d * 0.003 + 130 + xAdd;
        var wantedX = 30 + (targetY == 0 ? 30 : 0);
        x = FlxMath.lerp(x, wantedX, lerpVal);
        if(instant) {
            x = wantedX;
        }

        isMenuItem = false;
        instant = false;
        super.update(elapsed);
    }
}