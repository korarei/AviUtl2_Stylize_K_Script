# @Stylize_K

![GitHub License](https://img.shields.io/github/license/korarei/AviUtl2_Stylize_K_Script)
![GitHub Last commit](https://img.shields.io/github/last-commit/korarei/AviUtl2_Stylize_K_Script)
![GitHub Downloads](https://img.shields.io/github/downloads/korarei/AviUtl2_Stylize_K_Script/total)
![GitHub Release](https://img.shields.io/github/v/release/korarei/AviUtl2_Stylize_K_Script)

AviUtl ExEdit2で画像の見た目を変えるスクリプト群．

現在使用可能なスクリプト

- Saturate

- Threshold

- Threshold(RGBA)

- Posterize

- MotionTile

- Tile

- GradientMap

- Unpremultiply

[ダウンロードはこちらから．](https://github.com/korarei/AviUtl2_Stylize_K_Script/releases)

## 動作確認

- [AviUtl ExEdit2 beta3](https://spring-fragrance.mints.ne.jp/aviutl/)


## 導入・削除・更新

初期配置場所は`Stylize`である．

`オブジェクト追加メニューの設定`から`ラベル`を変更することで任意の場所へ移動可能．

### 導入

1.  同梱の`*.anm2`を`C:\\ProgramData\\aviutl2\\Script`フォルダまたはその子フォルダに入れる．

`map_data`にはゼットデジタ様よりご提供いただいたグラデーションマップが入っている．

### 削除

1.  導入したものを削除する．

### 更新

1.  導入したものを上書きする．

## 使い方
サンプル画像として数年前に名古屋で撮影したものを使用する．

![sample](/assets/sample.jpg)

本画像は，各スクリプトが画像に与える効果の違いを視覚的に把握するための参考資料である．

描画時間をプレビュー画面右下に表示しているので参考にしてほしい．(Ryzen9 7900X, RTX 4070s)

### Saturate

![saturate_sample](/assets/saturate_sample.jpg)

RGBAそれぞれに対して個別に飽和処理を行う．

- Gain

  それぞれのチャンネルの倍率．最大値を超えた場合，最大値に丸め込まれる (飽和状態)

- Color Space

  入力画像がsRGB画像かLinear画像を選択する．大体の画像はsRGBだと思う．

- Mix

  元画像と線形ブレンドする．

### Threshold

![threshold_sample](/assets/threshold_sample.jpg)

2値化処理を行う．

- Threshold

  閾値．これ以上が明部，未満が暗部となる．

- Channel

  2値化対象を選択する．普通の2値化は輝度基準．

  - Luminance (BT.601) : 輝度．SD画質など

  - Luminance (BT.709) : 輝度．HD画質など

  - Luminance (BT.2020) : 輝度．4K画質など

  - Value: 明度．

  - Saturation: 彩度．AviUtl2のカラーパレットに従い，円柱モデルを採用した．

  - Hue: 色相．

  - Alpha: 不透明度．

- Invert

  Channelのレベルを反転する．輝度反転，明度反転 etc.

- Light Color

  明部の色．`Channel`で`Alpha`を選択したとき，元画像の色が使用される．

- Dark Color

  暗部の色．`Channel`で`Alpha`を選択したとき，黒となる (仕様上)．

- Color Space

  入力画像がsRGB画像かLinear画像を選択する．大体の画像はsRGBだと思う．

- Mix

  元画像と線形ブレンドする．

### Threshold(RGBA)

![threshold_rgba_sample](/assets/threshold_rgba_sample.jpg)

RGBAそれぞれに対して個別に2値化処理を行う．

- Threshold

  それぞれのチャンネルの閾値．これ以上が明部，未満が暗部となる．

- Invert

  それぞれのチャンネルのレベルを反転させる．

- Disable A Threshold

  Alphaに関して2値化処理をしない．

- Color Space

  入力画像がsRGB画像かLinear画像を選択する．大体の画像はsRGBだと思う．

- Mix

  元画像と線形ブレンドする．

### Posterize

![posterize_sample](/assets/posterize_sample.jpg)

ポスタリゼーションを行う．

- Level

  階調．色を256段階に分けたとき何段階使用するかを決める．

- Value Only

  明度のみポスタライズする．イラスト風になるかも．

- Size

  モザイク．

- Multi Channel Mode

  RGBそれぞれ個別にレベルを設定するようにする．RGBなので`Value Only`は使用不可．

  直後の各チャンネルのトラックバーで指定する．

- Color Space

  入力画像がsRGB画像かLinear画像を選択する．大体の画像はsRGBだと思う．

- Mix

  元画像と線形ブレンドする．

### MotionTile

![motion_tile_sample](/assets/motion_tile_sample.jpg)

オブジェクト基準のタイリング (画像ループ)．

- Center

  XとYに関して中心座標を設定する．アンカーでも指定可能．

- Output W / H

  出力される画像サイズ倍率を指定する．大きいほど動作が重くなる．

- Tile W / H

  タイル (元画像領域) のサイズ倍率を指定する．

- Mirror Edge

  縁をミラー反転させるかどうかを水平，垂直個別に設定する．

- Phase

  垂直方向にズラす．

- Horizontal Shift

  `Phase`でズレる方向を水平にする．

### Tile

![tile_sample](/assets/tile_sample.jpg)

フレームバッファ基準のタイリング (画像ループ2)．

- Count

  複製回数．

- Gap

  画像間隔．100増えるごとに一枚分隙間が開く．

- Z Size

  画像にZ方向のサイズがないのでここで設定する．

  初期値は画像の横幅と縦幅の最大値．

- Use Group Pivot

  描画部での回転や拡大などをタイル (元画像) ごとに行う (`false`) か全体で行う (`true`) か決める．

  やや`true`のほうが軽い． 

### GradientMap

![gradient_map_sample](/assets/gradient_map_sample.jpg)

画像をグラデーションマップの色に置き換える．

> [!NOTE]
> このスクリプトで使用できるマップサイズに制限はない．

- Map File

  グラデーションマップを指定する．

- Map Layer

  グラデーションマップのレイヤー上の場所を指定する．描画部は透明度100や拡大率0でよい．

> [!TIP]
> 画像以外に動画も指定可能．

> [!CAUTION]
> ファイル指定する場合は0にする．

- View Map

  マップを表示する．この後のパラメータでマップを調整するときに役立ちそう．

- Map Hue

  マップの色相を変える．

- Map Slice

  マップの読み取る高さを指定する．0がマップ上端，100がマップ下端である．

- Map Scale

  マップを拡大縮小する．元画像の輝度倍率とも言える．

- Map Shift

  マップを横方向にズラす．

- Map Edges

  Mapの領域外の扱いを決める．

  - Clamp: マップ端の色を使用する．

  - Repeat: マップを繰り返す．

  - Mirror: マップを折り返す．

- Invert Luma

  元画像の輝度を反転する．

- Luma Mode

  輝度計算方法を指定する．

  - BT.601: SD画質など

  - BT.709: HD画質など

  - BT.2020: 4K画質など

- Color Space

  入力画像がsRGB画像かLinear画像を選択する．大体の画像はsRGBだと思う．

- Blend Mode

  元画像に対して加工画像をどのように合成するか指定する．

  - Normal: 通常

  - Add: 加算

  - Subtract: 減算

  - Multiply: 乗算

  - Screen: スクリーン

  - Overlay: オーバーレイ

  - Lighten: 比較 (明)

  - Darken: 比較 (暗)

  - Luminosity: 輝度

  - Chroma: 色差

  - Linear Burn: 陰影

  - Linear Light: 明暗

  - Difference: 差分

- Mix

  合成時の不透明度．

### Unpremultiply

![unpremult_sample](/assets/unpremult_sample.jpg)

黒色背景を透過する．

- Gain

  調整用．0ですべて透明，100を超えると一部黒色を透過しない．

## 既知の問題

### MotionTileとGradientMapが動作しない

`system.conf`の`TemporaryImageCacheSize`を増やす必要がある．デフォルト設定値`16,000,000`で扱える画像サイズは`MotionTile`は4K，`GradientMap`はFHDまでである．AviUtl ExEdit2の能力を最大限引き出すためには最低`MotionTile`では`268,435,456`，`GradientMap`では`536,870,912`必要である．

`TemporaryImageCacheSize`は`int`最大値`2,147,483,647`まで設定可能である．

### Tileで拡大率パラメータが使用できない

AviUtl ExEdit2 beta3まででは発生しない現象である．今後のバージョンで`obj.drawpoly()`の仕様がExEdit 0.92に戻った場合，`Use Group Pivot`有効時に発生する．

## 謝辞

本スクリプトはティム様が公開されている[色調補正セットver6](https://www.nicovideo.jp/watch/sm35722623)，[モーションタイルT](https://www.nicovideo.jp/watch/sm20729858)，さつき様が公開されている[画像ループ2](https://bowlroll.net/file/3777)，Aodaruma様が公開されている[グラデーションマップ(Re)](https://github.com/Aodaruma/GradationMap-Re)の出力結果を参考に作成いたしました．このような場をお借りして恐縮ではございますが，革新的かつ非常に有用なスクリプトを公開いただき，心より御礼申し上げます．

同梱のグラデーションマップにつきましては，ゼットデジタ様よりご提供いただいたものです．独自の審美眼と丁寧な作り込みにより多様な表現が可能となり，本スクリプトの表現幅を格段に広げることができました．このような高品質な素材をご提供いただけましたこと，心より御礼申し上げます．

## License

LICENSEファイルに記載．

## Change Log
- **v1.1.0**
  - リニア空間からsRGB空間に変換した際，Alphaを飽和していなかった問題を解決．
  - Unpremultiplyスクリプトを追加．

- **v1.0.0**
  - Release
