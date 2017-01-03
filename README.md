Lunar
-----

一个简单的农历/公历的转换

### Features

* 只提供简单的转换, 目前暂时不提供节气, 节日方面的计算, 因为目前暂时没有这方面的需求.

* 和其它农历库不一样的是, 这个库使用了缓存避免了每次都从 1900 年开始累加计算

### Usage

通过公历得到农历

```haxe
// 提供一个公历的 Date 值为参数
var lunar = Lunar.make(Date.now());
trace(lunar.toString());
```

通过农历获得公历

```haxe
// 最后的参数, 表示提供的月份是否为闰月, 如果你不清楚设 false 就好了
var lunar = Lunar.spec(2017, 1, 1, false);
// 返回 2017年大年初一 所对应公历 Date 值
trace(lunar.time);
```

 ### Issues

 * 目前由于 hl 与 neko 平台的 Date 被限制在 1970~2038 之间, 因此这个范围之外的时间将出错