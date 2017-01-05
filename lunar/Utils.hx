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

/**
当想要检索某一个小范围的正整数是否属于某一集合时（未测试和使用）
*/
abstract IntColl(haxe.io.Bytes) {

	public inline function new(max: Int) this = haxe.io.Bytes.alloc(max);
	public inline function set(i: Int) this.set(i, 1);
	public inline function unset(i: Int) this.set(i, 0);
	public inline function get(i: Int) return haxe.io.Bytes.fastGet(this.getData(), i);
	public inline function has(i: Int) return get(i) == 1;

	public var length(get, never):Int;
	public function get_length() {
		var b = this.getData();
		var c = 0;
		for (i in 0...this.length) {
			if (haxe.io.Bytes.fastGet(b, i) == 1) ++c;
		}
		return c;
	}

	public function toArray():Array<Int> {
		var a = [];
		var b = this.getData();
		for (i in 0...this.length) {
			if (haxe.io.Bytes.fastGet(b, i) == 1) a.push(i);
		}
		return a;
	}
}