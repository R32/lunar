package lunar;

import lunar.Data.*;

class Label {
	public var year(default, null):String;
	public var yearsx(default, null):String;
	public var month(default, null):String;
	public var date(default, null):String;
	public var leap(default, null):String;

	public function new(lunar: Lunar) {
		var buff = new StringBuf();
		var a = [];
		var len = itoa(lunar.year, a);
		while (len > 0) {
			-- len;
			buff.add(CN_NUMS[a[len]]);
		}
		this.year = buff.toString();

		this.yearsx = CN_EXT[y2i(lunar.year)];

		this.month = CN_MONTHS[lunar.month - 1];

		var day = lunar.date;
		if (day < 11) {
			this.date = "初" + CN_NUMS[day];
		} else if (day < 20) {
			this.date = "十" + CN_NUMS[day - 10];
		} else {
			if (day == 20) day = 30;
			this.date = "廿" + CN_NUMS[day - 20];
		}
		this.leap = lunar.leap ? "闰" : "";
	}

	public function toString() {
		return '${year}年 ${month}${leap} ${date} ${yearsx}';
	}

	// need to reverse
	static function itoa(i:Int, a:Array<Int>):Int {
		var ct = 0;
		while (i > 0) {
			a.push( i % 10);
			i = Std.int(i / 10);
			++ ct;
		}
		return ct;
	}
}