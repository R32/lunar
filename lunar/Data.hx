package lunar;

#if js @:native("LData") #end
 class Data {
	#if js @:native("m") #end
	public static var CN_MONTHS = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "腊月"];

	#if js @:native("n") #end
	public static var CN_NUMS = ["〇", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十"];

	#if js @:native("x") #end
	public static var CN_XIAO = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"];

	#if js @:native("p") #end
	public static var PY_XIAO = ["shu", "niu", "hu", "tu", "long", "she", "ma", "yang", "hou", "ji", "gou", "zhu"];

	/*
	 * year index for lunar.
	 * @param y: full year, year should be >= 1900
	 * @return [0-11]
	 */
	public static inline function yearIndex( y : Int ) : Int {
		return (y - 4) % 12;
	}
}
