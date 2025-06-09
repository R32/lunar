package lunar;

import lunar.Data.*;

class Label {
	public var year(default, null) : String;
	public var month(default, null) : String;
	public var date(default, null) : String;
	public var leap(default, null) :String;
	public var ysx(default, null) : String;

	public function new( lunar : Lunar ) {
		var year = lunar.year;
		this.year = CN_NUMS[Std.int(year / 1000) % 10] + CN_NUMS[Std.int(year / 100) % 10] +
			CN_NUMS[Std.int(year / 10) % 10] + CN_NUMS[Std.int(year % 10)];

		this.ysx = CN_XIAO[yearIndex(lunar.year)];

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
		return '${year}年 ${month}${leap} ${date} ${ysx}';
	}
}