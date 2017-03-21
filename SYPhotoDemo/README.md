[![Download](https://api.bintray.com/packages/woxingxiao/maven/XEditText/images/download.svg)](https://bintray.com/woxingxiao/maven/XEditText/_latestVersion)

[**中文说明**](https://github.com/woxingxiao/XEditText/blob/master/README_zh.md)

##What can I do ?
- Deleting function is available. Click the `drawableRight` icon to clear all contents.
- Insert **separator** automatically during inputting. You can customize the **separator** whatever you want (`""`,  `-`, etc.). But you have to set **pattern**, which is kind of a rule you are going to separate the contents.
- Can disable **Emoji** input easily. You don't need to exclude the **Emoji** by yourself in codes anymore. 
- `drawableRight` icon, which be called **Marker**, can also be customized. When you do that, for example, you can turn it as an input tips option with a `PopUpWindow` by listening to the **Marker**'s `onMarkerClickListener`.
- iOS style is available. `drawableLeft` and `hint` are both at the center of `EditText` when it has not be focused.

***

##How to use ?

###Gradle
```groovy
dependencies{
    compile 'com.xw.repo:xedittext:1.0.6@aar'
}
```

![demo3](https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1489751223810&di=08179337a6ea398665afe78db9a6e47c&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01b2a856f1ef166ac7257d207d8a1a.jpg%40900w_1l_2o_100sh.jpg) ![demo4](https://github.com/woxingxiao/XEditText/blob/master/screenshots/demo4.gif)

![demo5](https://github.com/woxingxiao/XEditText/blob/master/screenshots/demo5.gif) ![demo6](https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3378388765,4196638105&fm=21&gp=0.jpg)
***
###Attributes
attr | format | describe
-------- | ---|---
x_separator|String|**separator**, insert automatically during inputting. `""` by default.
x_disableEmoji|boolean|disable **Emoji** or not, `false` by default.
x_customizeMarkerEnable|boolean|customize **Marker** or not, `false` by default.
x_showMarkerTime|enum|set when **Marker** shows, 3 options: `after_input`(by default), `before_input`, `always`
x_iOSStyleEnable|boolean|enable **iOS style** or not, `false` by default.
***
###Methods：
name     | describe
-------- | ---
setSeparator(String separator)| what **separator** you want to set.
setHasNoSeparator(boolean hasNoSeparator)| set none **separator** or not, if set `true`, **separator** equals `""`.
setPattern(int[] pattern) |**pattern** is a kind of rules that you want to separate the contents, for example, credit card input: **separator** = `"-"`, **pattern** = `int[]{4,4,4,4}`, result = xxxx-xxxx-xxxx-xxxx.
setRightMarkerDrawable(Drawable drawable)|set `drawable` to replace the default clear icon.When `drawable == null`, **Marker** is invisible.
setRightMarkerDrawableRes(int resId)|set `drawableResId` to replace the default clear icon.
setTextToSeparate(CharSequence c)|set normal strings to `EditText`, then show separated strings according to  **separator** and **pattern** you've set already.
getNonSeparatorText()|get none **separator**s contents, no matter you've set **separator** or not.
setOnTextChangeListener(OnTextChangeListener listener)|the same as `EditText`'s addOnTextChangeListener() method.
setDisableEmoji(boolean disableEmoji)|disable **Emoji** or not.
setCustomizeMarkerEnable(boolean customizeMarkerEnable)|customize **Marker** or not.
setOnMarkerClickListener(OnMarkerClickListener markerClickListener)|listen to **Marker**'s `onTouch` event.
setShowMarkerTime(ShowMarkerTime showMarkerTime)|set when the **Marker** shows.
setiOSStyleEnable(boolean iOSStyleEnable)|enable **iOS style** or not.
setMaxLength(int maxLength)|set max length of contents.

###License
```
The MIT License (MIT)

Copyright (c) 2016 woxingxiao

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
