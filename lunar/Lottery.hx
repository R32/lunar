package lunar;

/**
 TODO
*/
class Lottery {}

/**
 R, G, B 这三个数组的值是固定的不会因年份而改变, 但 生肖 将会跟随农历年做变化
*/
@:native("LtBalls") abstract Balls(haxe.ds.Vector<Int>) {

	public inline function get(i: Int): Attr return cast this.get(i);
	public inline function set(i: Int, attr: Attr) this.set(i, attr);

	// 农历年, 4位格式
	public function new(ly: Int) {
		this = new haxe.ds.Vector<Int>(MAX50);
		this[0] = 0;
		// R
		initColor(1, 11, Red);
		initColor(2, 11, Red);
		initColor(7, 11, Red);
		set(8 +  0, Attr.from(Red, cast 0));
		set(8 + 11, Attr.from(Red, cast 0));
		set(8 + 22, Attr.from(Red, cast 0));
		// G
		initColor(5, 11, Green);
		initColor(6, 11, Green);
		initColor(11, 11, Green);
		initColor(21, 11, Green);
		// B
		initColor(3, 11, Blue);
		initColor(4, 11, Blue);
		initColor(9, 11, Blue);
		set(10, Attr.from(Blue, cast 0));
		set(41, Attr.from(Blue, cast 0));

		// xiao
		var offset = Utils.indexSx(ly);
		var x = 0;
		var pivot = offset + 1;
		while (x <= offset) { // left
			padXiao(pivot - x, 12, cast x);
		++ x;
		}
		pivot = offset + 1 + 12;
		while ( x < 12) {     // right
			padXiao(pivot - x, 12, cast x);
		++ x;
		}
	}

	public function filter(func: Int->Attr->Bool): Array<Int> {
		var ret = [];
		for (i in 1...MAX50) { // Note: begin from 1
			if (func(i, get(i))) ret.push(i);
		}
		return ret;
	}

	// [i, MAX50)
	function initColor(i: Int, step: Int, c: Color): Void {
		while (i < MAX50) {
			set(i, Attr.from(c, cast 0));
			i += step;
		}
	}

	function padXiao(i: Int, step: Int, x: Xiao): Void {
		var t: Attr;
		while (i < MAX50) {
			t = get(i);
			t.xiao = x;
			this.set(i, t);
			i += step;
		}
	}

	public static inline var MAX50 = 50;
	public static inline function isBig(i) return i > 24;
	public static inline function isOdd(i) return (i & 1) == 1;

	// 小数 与 十位数相加, 合Dan,shuang
	public static inline function hsum(i:Int):Int return Std.int(i / 10) + (i % 10);
	public static inline function hhead(i:Int, n:Int):Bool return Std.int(i / 10) == n;
	public static inline function htail(i:Int, n:Int):Bool return (i % 10) == n;
}

/**
Xiao 占低 4 位, Color 占高位
*/
extern abstract Attr(Int) to Int {

	public var xiao(get, set): Xiao;
	public var color(get, set): Color;

	inline function get_xiao(): Xiao return cast this & 0xF;
	inline function get_color(): Color return cast (this >> 4) & 3;

	inline function set_xiao(x: Xiao): Xiao {
		this = (this & 0xF0) | x;
		return x;
	}

	inline function set_color(c: Color): Color {
		this = (this & 0xF) | (c << 4);
		return c;
	}

	inline public static function from(c: Color, x: Xiao): Attr {
		return cast ((c << 4) | x);
	}
}

// 生肖, 数值刚好与 Data.SX_CN 相对应
@:enum abstract Xiao(Int) to Int {
	var Shu = 0;
	var Niu = 1;
	var Hu  = 2;
	var Tu  = 3;
	var Long = 4;
	var She = 5;
	var Ma  = 6;
	var Yang = 7;
	var Hou = 8;
	var Ji  = 9;
	var Gou = 10;
	var Zhu = 11;
}

@:enum abstract Color(Int) to Int {
	var Red = 1;
	var Green = 2;
	var Blue = 3;
}
