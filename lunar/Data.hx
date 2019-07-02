package lunar;

#if js @:native("LData") #end
 class Data {
	#if js @:native("a") #end
	public static var CN_MONTHS = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "腊月"];

	#if js @:native("b") #end
	public static var CN_NUMS = ["〇", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十"];

	#if js @:native("c") #end
	public static var CN_XIAO = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"];

	#if js @:native("d") #end
	public static var PY_XIAO = ["shu", "niu", "hu", "tu", "long", "she", "ma", "yang", "hou", "ji", "gou", "zhu"];

	/**
	* e.g: yearIndex(2016) => 8, then CN_XIAO[8] => "猴"
	* @param y: full year. Note: Do not accept `0` as parameter
	* @return [0-11]
	*/
	#if js @:native("f") #end
	public static function yearIndex(y:Int):Int {
		var n = (y > 0 ? y - 4 : y - 3) % 12;
		return n < 0 ? n + 12 : n;
	}
}
