package lunar;


class Utils {
	/**
	* 生肖年, 例 sxYear(2016) => 8, 对应第 9 个生肖“猴”
	* @param fullyear 不接受 0 为参数, 虽然不会出错
	* @return
	*/
	public static function indexSx(fullyear:Int):Int {
		var n = (fullyear > 0 ? fullyear - 4 : fullyear - 3) % 12;
		return n < 0 ? n + 12 : n;
	}

	/**
	 存储这个整数最低需要几位二进制(bit), 注: 即使是 0 也需要占一位
	*/
	public static function bitCt(n) {
		var bits = 1;
		while (n >= 1 << bits) ++bits;
		return bits;
	}
}
