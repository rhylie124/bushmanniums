class ConvertScore
{
	public inline static function convertScore(noteDiff:Float):Int
	{
		var daRating:String = Ratings.CalculateRating(noteDiff, 166);

		return switch(daRating)
		{
			case 'shit': -300;
			//case 'bad': 0;
			case 'good': 200;
			case 'sick': 350;
			default: 0;
		}
	}

}