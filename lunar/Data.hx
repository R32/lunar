package lunar;

@:native("LData") class Data {
	@:native("a") public static var CN_MONTHS = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "腊月"];

	@:native("b") public static var CN_NUMS = ["〇", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十"];

	@:native("c") public static var CN_XIAO = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"];

	@:native("d") public static var PY_XIAO = ["shu", "niu", "hu", "tu", "long", "she", "ma", "yang", "hou", "ji", "gou", "zhu"];

	/**
	* e.g: yearIndex(2016) => 8, then CN_XIAO[8] => "猴"
	* @param y: full year. Note: Do not accept `0` as parameter
	* @return [0-11]
	*/
	public static function yearIndex(y:Int):Int {
		var n = (y > 0 ? y - 4 : y - 3) % 12;
		return n < 0 ? n + 12 : n;
	}
}
