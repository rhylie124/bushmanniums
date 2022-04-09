package;

import lime.utils.Assets;

using StringTools;

class Difficulty
{
	public static inline final EASY = 0;
	public static inline final NORMAL = 1;
	public static inline final HARD = 2;

	public static var difficultyArray:Array<String> = ["Easy", "Normal", "Hard"];
	public static var difficultyEnding:Array<String> = ["-easy", "", "-hard"];

	public inline static function fromInt(difficulty:Int):String
	{
		return difficultyArray[difficulty];
	}
}
