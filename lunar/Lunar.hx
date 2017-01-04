package lunar;

class Lunar {

	public var time(default, null):Date; // 公历时间
	public var info(default, null):Info;

	public var year(default, null): Int; // 农历年
	public var month(default, null):Int; // 农历月 1 ~ 12
	public var date(default, null): Int; // 农历号
	public var leap(default, null):Bool; // 当前日期是否处于"闰月"
	public var days(default, null): Int; // 从农历 1 月 1 号到现在已经有多少天了

	private function new(ly:Int, lm:Int, ld:Int, le:Bool, ds:Int, t: Date, i:Info) {
		year = ly;
		month = lm;
		date = ld;
		leap = le;
		days = ds;
		time = t;
		info = i;
	}

	public function toString():String {
		return '[lunar: ${this.year}, ${this.month}, ${this.date}, ${this.leap}, ${days}]';
	}

	public static inline function now():Lunar {
		return Lunar.make(Date.now());
	}

	public static function make(time: Date) {
		var diff:Int;
		var start:Date;

		var cur = time.getTime();
		if (cur < -2206425600000) throw "Less than 1900-01-31";

		var tyear = time.getFullYear();
		do {
			if (tyear < Info.DAT_START || tyear >= (Info.DAT_START + Info.DAT_LENGTH) )
				throw "out of range!";
			var index = Info.index(tyear);
			start = CACHES.length > index ? CACHES[index] : CACHES[CACHES.length - 1];
			diff = Std.int((cur - start.getTime()) / MICROSECONDS_IN_DAY);
			--tyear;
		} while (diff < 0);

		// 从农历的 1 月初 1 开始累加, （为了降低复杂性不再像旧版本那样反向查找）
		tyear = start.getFullYear();
		var tinfo = new Info(tyear);
		var t = 0;
		// 年
		for (i in Info.index(tyear)...Info.DAT_LENGTH) {
			t = tinfo.daysofYear();
			if (diff > t) {
				push2Caches(i + 1, t);
				++tyear;
				tinfo.reset(tyear);
				diff -= t;
			} else {
				break;
			}
		}

		var ds = diff;
		// 月
		var tmonth = 1;
		var tdate = 1;
		var tleap = false;
		for (i in 0...12) {
			t = tinfo.isBigMonth(tmonth) ? 30 : 29;
			if (diff > t) {
				++tmonth;
				diff -= t;
			} else {
				break;
			}
			if (tinfo.leap == tmonth - 1) {
				t = tinfo.leapbig ? 30 : 29;
				if (diff > t) {
					diff -= t;
					tleap = false;
				} else {
					--tmonth;
					tleap = true;
					break;
				}
			}
		}
		tdate += diff;
		return new Lunar(tyear, tmonth, tdate, tleap, ds, time, tinfo);
	}

	/**
	*
	* @param ly [1900 ~ 2010]
	* @param lm [1 ~ 12]
	* @param ld [1 ~ 30]
	* @param onleap 指定的月份是否为闰月?
	* @return
	*/
	public static function spec(ly:Int, lm:Int, ld:Int, onleap:Bool):Lunar {

		var index = Info.index(ly);

		if (CACHES.length <= index) { // make caches
			var last = CACHES.length - 1;
			while (last < index) {
				var tinfo = new Info(last + Info.DAT_START);
				++ last;
				push2Caches(last, tinfo.daysofYear());
			}
		}
		var start = CACHES[index];
		var info = new Info(ly);
		var ds = 0;
		// 月
		var leap = info.leap;
		for (m in 1...lm) {
			ds += info.isBigMonth(m) ? 30 : 29;
			if (leap == m) ds += info.leapbig ? 30 : 29;
		}
		if (info.leap == lm && onleap == true) {
			ds += info.isBigMonth(lm) ? 30 : 29;
		}
		// 日
		ds += ld - 1;
		var time = Date.fromTime(start.getTime() + ds *  MICROSECONDS_IN_DAY);
		return new Lunar(ly, lm, ld, onleap && info.leap == lm, ds, time, info);
	}

	static function push2Caches(i:Int, diff:Int):Void { // 如果 diff
		if (CACHES.length == i) {
			var c = CACHES[i - 1];
			CACHES.push(Date.fromTime(c.getTime() + diff * MICROSECONDS_IN_DAY));
		}
	}

	public static inline var MICROSECONDS_IN_DAY = 24 * 60 * 60 * 1000 * 1.0;

	/**
	* 缓存农历每一年 1 月 1 号所对应的公历 Date
	*/
#if !(hl || neko)
	static var CACHES:Array<Date> = [new Date(1900, 0, 31, 0, 0, 0)];
#else
	static var CACHES:Array<Date> = [new Date(1970, 1,  6, 0, 0, 0)];
#end
}

abstract Info(Int) {

	public var leap(get, never): Int;
	public var bmonths(get, never): Int;
	public var leapbig(get, never): Bool;

	inline function get_leap() return this & 0xF;
	inline function get_bmonths() return (this >> 4) & 0xFFF;
	inline function get_leapbig() return (this & 0x10000) != 0;

	/**
	lyear: 表示农历年
	*/
	inline public function new(lyear: Int) reset(lyear);

	inline public function reset(lyear: Int) this = DAT[index(lyear)];

	inline function leapDays() return leap > 0 ? (leapbig ? 30 : 29) : 0;

	/**
	* 返回整个一年的天数
	*/
	public function daysofYear() {
		var sum = 348;
		for (i in 4...12 + 4) {
			sum += (this >> i) & 1;
		}
		return sum + leapDays();
	}

	/**
	* m in 1~12
	*/
	inline public function isBigMonth(m:Int): Bool {
		return this & (1 << (16 - m)) != 0;
	}

	public function toString() {
		return '[dat: 0x${StringTools.hex(this, 5)}, leap: ${leap}, leapbig: ${leapbig}, bmonths: ${binString(bmonths, 12)}]';
	}

	// binString(0xF, 8) => "00001111"
	static function binString(x:Int, w:Int) {
		var ret = [];
		ret[w - 1] = 0;
		for (i in 0...w)
			ret[i] = (x >> (w - i - 1)) & 1;
		return ret.join("");
	}

	public static inline function index(ly:Int) return ly - DAT_START;

#if !(hl || neko)
	public static inline var DAT_START = 1900;  // 只能计算 1900~2100
	public static inline var DAT_LENGTH = 2100 - 1900 + 1;
#else
	public static inline var DAT_START = 1970;  // hashlink 只能计算 1970 之后的年份
	public static inline var DAT_LENGTH = 2100 - 1970 + 1;
#end


	/**
	*	   FEDC BA98 7654 3210
	* 0000 0000 0000 0000 0000
	*                    |3210|		- 如果不是闰年值为 0, 是闰年则值表示为 闰月月份 1~12
	*     |1234 5678 9ABC| 			- 1 为大月 30天, 0为小月29天. 注意: 1月~12月对应的是 F(15)~4
	*   |1|  						- 第 16 位, 当值为 1 则为闰大月, 否则闰小月, 当 leap 大于 0时有效.
	 数据复制来自 https://github.com/QingYolan/Calendar/blob/gh-pages/js/data.js , 2050 年以后的数据正确性未知
	*/
	static var DAT = [
	#if !(hl || neko)
		0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260,
		0x0d950, 0x16554, 0x056a0, 0x09ad0, 0x055d2,
		0x04ae0, 0x0a5b6, 0x0a4d0, 0x0d250, 0x1d255,
		0x0b540, 0x0d6a0, 0x0ada2, 0x095b0, 0x14977,
		0x04970, 0x0a4b0, 0x0b4b5, 0x06a50, 0x06d40,
		0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970,
		0x06566, 0x0d4a0, 0x0ea50, 0x06e95, 0x05ad0,
		0x02b60, 0x186e3, 0x092e0, 0x1c8d7, 0x0c950,
		0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4,
		0x025d0, 0x092d0, 0x0d2b2, 0x0a950, 0x0b557, /* 1949 */

		0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5d0,
		0x14573, 0x052d0, 0x0a9a8, 0x0e950, 0x06aa0,
		0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570,
		0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0, /* 1969 */
	#end
		0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4,
		0x0d250, 0x0d558, 0x0b540, 0x0b5a0, 0x195a6,
		0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a,
		0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570,
		0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50,
		0x06b58, 0x055c0, 0x0ab60, 0x096d5, 0x092e0, /* 1999 */

		0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552,
		0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5,
		0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9,
		0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930,
		0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60,
		0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530,
		0x05aa0, 0x076a3, 0x096d0, 0x04bd7, 0x04ad0,
		0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45,
		0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577,
		0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0, /* 2049 */

		0x14b63, /* 2050 */

		0x09370, 0x049f8, 0x04970, 0x064b0, 0x168a6,
		0x0ea50, 0x06b20, 0x1a6c4, 0x0aae0, 0x0a2e0,
		0x0d2e3, 0x0c960, 0x0d557, 0x0d4a0, 0x0da50,
		0x05d55, 0x056a0, 0x0a6d0, 0x055d4, 0x052d0,
		0x0a9b8, 0x0a950, 0x0b4a0, 0x0b6a6, 0x0ad50,
		0x055a0, 0x0aba4, 0x0a5b0, 0x052b0, 0x0b273,
		0x06930, 0x07337, 0x06aa0, 0x0ad50, 0x14b55,
		0x04b60, 0x0a570, 0x054e4, 0x0d160, 0x0e968,
		0x0d520, 0x0daa0, 0x16aa6, 0x056d0, 0x04ae0,
		0x0a9d4, 0x0a2d0, 0x0d150, 0x0f252, 0x0d520 /* 2100 */
	];
}