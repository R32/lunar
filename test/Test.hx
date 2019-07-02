package test;

import lunar.Lunar;
import lunar.Label;
import lunar.Data;

@:access(lunar) class Test {

	static function main() {
		lunarmake();
		lunarspec();
		testlabel();
		trace("done!");
	}

	static function testlabel() {
	#if !(neko || eval || macro)
		for(ld in data) {
			var lunar = Lunar.spec(ld[1], ld[2], ld[3], ld[4]);
			var label = new Label(lunar);
			var time = lunar.time;
			trace("农历: " + label.toString() + ', :[${ld.join(",")}]');
		}
	#end
	}

	static var data:Array<Dynamic> = [
		// date,      lyear, lm, ld, isLeap
		["1970-02-07", 1970, 1, 2, false],
		["2017-02-09", 2017, 1, 13, false],
		["2017-07-25", 2017, 6, 3, true],
		["2017-06-26", 2017, 6, 3, false],
		["1986-11-11", 1986, 10, 10, false],
		["2010-11-25", 2010, 10, 20, false],
#if !(hl || neko || macro || eval)
		["1970-02-06", 1970, 1, 1, false],
		["1970-01-01", 1969, 11, 24, false],
		["1970-01-02", 1969, 11, 25, false],
		["1900-01-31", 1900, 1, 1, false],
		["1901-02-20", 1901, 1, 2, false],
		["2099-01-08", 2098, 12,18, false],
		["2100-01-29", 2099, 12,20, false],
#end
		["2000-05-25", 2000, 4, 22, false],
		["1998-06-19", 1998, 5, 25, false],
		["1998-07-18", 1998, 5, 25, true],
		["2017-01-01", 2016, 12, 4, false],
		["2023-06-13", 2023, 4, 26, false],
	];

	static function lunarspec() {
		for (o in data) {
			var ly = o[1], lm = o[2], ld = o[3], onleap = o[4];
			var lunar = Lunar.spec(ly, lm, ld, onleap);
			var a = (o[0]:String).split("-").map(s->Std.parseInt(s));
			var date = new Date(a[0], a[1] - 1, a[2], 0, 0, 0);
			var time = lunar.time;
			if (!(time.getFullYear() == date.getFullYear()
			&& time.getMonth() == date.getMonth()
			&& time.getDate() == date.getDate()
			)) {
				throw ("spec FAIL > " + "[" + o.join(",") + '], calc: ${simpledate(time)}]');
			}
		}
	}

	static function lunarmake() {
		for (o in data) {
			var ly = o[1], lm = o[2], ld = o[3], onleap = o[4];
			var a = (o[0]: String).split("-").map(s->Std.parseInt(s));
			var date = new Date(a[0], a[1] - 1, a[2], 0, 0, 0);
			var lunar = Lunar.make(date);
			if(!(lunar.year == ly && lunar.month == lm && lunar.date == ld && lunar.leap == onleap)) {
				throw ('make FAIL > ' + lunar.toString() + ' {${o[0]} == [$ly, $lm, $ld, $onleap]}');
			}
		}
	}

	static public function eqa<T>(a:Array<T>, b:Array<T>):Bool {
		if (a.length != b.length) return false;
		for (i in 0...a.length)
			if (a[i] != b[i]) return false;
		return true;
	}

	static public function simpledate(d: Date) {
		return '${d.getFullYear()}-${d.getMonth() + 1}-${d.getDate()}';
	}

	static public function eq(b, ?pos: haxe.PosInfos) {
		if (!b) throw "Error LineNumber: " + pos.lineNumber;
	}
}