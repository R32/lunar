package test;

import haxe.PosInfos;
import lunar.Lunar;
import lunar.Label;
import lunar.Utils;

class Test {

	static function main() {
		lunarmake();
		@:privateAccess Lunar.CACHES.splice(1, Lunar.CACHES.length - 1);
		//trace("----------------");
		//lunarspec();

		//for (d in @:privateAccess Lunar.CACHES) {
		//	var info = new Info(d.getFullYear());
			//trace(simpledate(d) + "\t" + info);
		//}
#if !(hl || neko)
		testlabel();
#end
	}

	static function testlabel() {
		//trace("indexSx: 2016 == 8, 2000 == 4; " + (Utils.indexSx(2016) == 8 && Utils.indexSx(2000) == 4));
		var len = data.length;
		data.push(["", 1986, 10, 10, false]);
		data.push(["", 2010, 10, 20, false]);
		for(ld in data) {
			var lunar = Lunar.spec(ld[1], ld[2], ld[3], ld[4]);
			var label = new Label(lunar);
			var time = lunar.time;
			trace("农历: " + label.toString() + ', 公历: "${time.getFullYear()}-${time.getMonth() + 1}-${time.getDate()}"');
		}
		// restore
		data.splice(len, 2);
	}

	static var data:Array<Dynamic> = [
		["2017-07-25", 2017, 6, 3, true],
		["2017-06-26", 2017, 6, 3, false],
#if !(hl || neko)
		["1900-01-31", 1900, 1, 1, false],
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
			var lunar = Lunar.spec(o[1], o[2], o[3], o[4]);
		#if !(hl || neko)
			var date = Date.fromString(o[0]);
		#else
			var a = (o[0]:String).split("-");
			var date = new Date(Std.parseInt(a[0]), Std.parseInt(a[1]) - 1, Std.parseInt(a[2]), 8, 0, 0);
		#end
			var time = lunar.time;
			if (time.getFullYear() == date.getFullYear()
			&& time.getMonth() == date.getMonth()
			&& time.getDate() == date.getDate()
			) {
				trace("DONE > " + lunar.toString() + ", [" + o.join(",") + "]");
			} else {
				trace("FAIL > " + lunar.toString() + ", [" + o.join(",") + ' ${simpledate(time)}]');
			}
		}
	}

	static function lunarmake() {
		for (o in data) {
			lunareq(o[0], o[1], o[2], o[3], o[4]);
		}
	}

	static function lunareq(sd:String, ly:Int, lm:Int, ld:Int, onleap:Bool) {
	#if !(hl || neko)
		var date = Date.fromString(sd);
	#else
		// Date.fromString error on hashlink
		var a = sd.split("-");
		var date = new Date(Std.parseInt(a[0]), Std.parseInt(a[1]) - 1, Std.parseInt(a[2]), 8, 0, 0);
	#end
		var lunar = Lunar.make(date);
		if(lunar.year == ly && lunar.month == lm && lunar.date == ld && lunar.leap == onleap) {
			trace("DONE > " + lunar.toString() + ' {$sd} ${simpledate(lunar.time)}');
		} else {
			trace("FAIL > " + lunar.toString() + ' {$sd == [$ly, $lm, $ld, $onleap]}');
		}
	}

	static public function simpledate(d: Date) {
		return '${d.getFullYear()}-${d.getMonth() + 1}-${d.getDate()}';
	}
}