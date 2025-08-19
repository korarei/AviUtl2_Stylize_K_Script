# @Stylize_K

![GitHub License](https://img.shields.io/github/license/korarei/AviUtl2_Stylize_K_Script)
![GitHub Last commit](https://img.shields.io/github/last-commit/korarei/AviUtl2_Stylize_K_Script)
![GitHub Downloads](https://img.shields.io/github/downloads/korarei/AviUtl2_Stylize_K_Script/total)
![GitHub Release](https://img.shields.io/github/v/release/korarei/AviUtl2_Stylize_K_Script)

AviUtl ExEdit2で画像の見た目を変えるスクリプト群．

現在使用可能なスクリプト

- Saturate

- Mosaic

- Threshold

- Threshold(RGBA)

- Posterize

- Posterize(RGBA)

- ASCII

- MotionTile

- Tile

- Repeat

- GradientMap

- Unpremultiply

[ダウンロードはこちらから．](https://github.com/korarei/AviUtl2_Stylize_K_Script/releases)

## 動作確認

- [AviUtl ExEdit2 beta7](https://spring-fragrance.mints.ne.jp/aviutl/)


## 導入・削除・更新

初期配置場所は`Stylize`である．

`オブジェクト追加メニューの設定`から`ラベル`を変更することで任意の場所へ移動可能．

### 導入

1.  同梱の`*.anm2`を`%ProgramData%`内の`aviutl2\\Script`フォルダまたはその子フォルダに入れる．

`beta4`以降では`aviutl2.exe`と同じ階層内の`data\\Script`フォルダ内でも可．

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

- PI

  パラメータインジェクション．上記項目を上書きする．

  ```lua
  {
    r_gain = 100.0,
    g_gain = 100.0,
    b_gain = 100.0,
    a_gain = 100.0.
    col_space = 1,
    mix = 100.0
  }
  ```

  `{}`は挿入済みであるため，省略して記入する．

### Mosaic

![mosaic_sample](/assets/mosaic_sample.jpg)

ブロック数を指定するタイプのモザイク．

- Blocks

  X，Y方向に関してブロック数を指定する．

- Sharp Colors

  モザイク処理を切り替える．有効時ブロック中心付近の色をそのまま使用し，無効時ブロック内の平均をとる．

- PI

  パラメータインジェクション．上記項目を上書きする．

  ```lua
  {
    bx = 32，
    by - 32,
    sharp_col = 0 -- booleanでも可．
  }
  ```

  `{}`は挿入済みであるため，省略して記入する．

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

- Light Alpha

  明部の不透明度．

- Dark Color

  暗部の色．`Channel`で`Alpha`を選択したとき，黒となる (仕様上)．

- Dark Alpha

  暗部の不透明度．

- Color Space

  入力画像がsRGB画像かLinear画像を選択する．大体の画像はsRGBだと思う．

- Mix

  元画像と線形ブレンドする．

- PI

  パラメータインジェクション．上記項目を上書きする．

  ```lua
  {
    threshold = 128.0,
    channel = 1,
    inv = 0, -- booleanでも可．
    light_col = 0xffffff,
    light_a = 100.0,
    dark_col = 0x000000,
    dark_a = 100.0,
    col_space = 1,
    mix = 100.0
  }
  ```

  `{}`は挿入済みであるため，省略して記入する．

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

- PI

  パラメータインジェクション．上記項目を上書きする．

  ```lua
  {
    r_threshold = 128.0,
    g_threshold = 128.0,
    b_threshold = 128.0,
    a_threshold = 128.0,
    inv_r = 0, -- booleanでも可．
    inv_g = 0, -- booleanでも可．
    inv_b = 0, -- booleanでも可．
    inv_a = 0, -- booleanでも可．
    disable_a = 0, -- booleanでも可．
    col_space = 1,
    mix = 100.0
  }
  ```

  `{}`は挿入済みであるため，省略して記入する．

### Posterize

![posterize_sample](/assets/posterize_sample.jpg)

ポスタリゼーションを行う．

- Level

  階調．色を256段階に分けたとき何段階使用するかを決める．

- Channel

  ポスタリゼーション対象を選択する．

  - RGB: RGBのみポスタリゼーションを行う．

  - RGBA: 上記に加え，Alphaもポスタリゼーションを行う．

  - Value: 明度のみポスタリゼーションを行う．

  - Value A: 上記に加え，Alphaもポスタリゼーションを行う．

- Size

  モザイク．

- Sharp Color

  モザイク方法を変化させる．有効時およそブロック中心の色をそのまま使用し，無効時ブロック内の平均色を使用する．

- Color Space

  入力画像がsRGB画像かLinear画像を選択する．大体の画像はsRGBだと思う．

- Mix

  元画像と線形ブレンドする．

- PI

  パラメータインジェクション．上記項目を上書きする．

  ```lua
  {
    level = 8,
    channel = 0,
    size = 1,
    sharp_col = 0, -- booleanでも可．
    col_space = 1,
    mix = 100.0
  }
  ```

  `{}`は挿入済みであるため，省略して記入する．

### Posterize(RGBA)

![posterize_rgba_sample](/assets/posterize_rgba_sample.jpg)

RGBA個別にレベルを設定してポスタリゼーションを行う．

- Level

  RGBAそれぞれに関する階調．色を256段階に分けたとき何段階使用するかを決める．

- Disable A Level

  Alphaに関するポスタリゼーションを無効化する．

- Size

  モザイク．

- Sharp Color

  モザイク方法を変化させる．有効時およそブロック中心の色をそのまま使用し，無効時ブロック内の平均色を使用する．

- Color Space

  入力画像がsRGB画像かLinear画像を選択する．大体の画像はsRGBだと思う．

- Mix

  元画像と線形ブレンドする．

- PI

  パラメータインジェクション．上記項目を上書きする．

  ```lua
  {
    r_level = 8,
    g_level = 8,
    b_level = 8,
    a_level = 8,
    disable_a = 0, -- booleanでも可．
    size = 1,
    sharp_col = 0, -- booleanでも可．
    col_space = 1,
    mix = 100.0
  }
  ```

  `{}`は挿入済みであるため，省略して記入する．

### ASCII

![ascii_sample](/assets/ascii_sample.jpg)

アスキーアート作成スクリプト．アスキーと言いながらUTF-8に対応． (絵文字は無理)

- Glyphs

  アスキーで使用する文字を区切りなしで入力する．空白も1文字扱い．

  左端が暗部，右端が明部である．

  例
  
  - `@#%*+=-:. `

  - `█▓▒░ `

  - `█▉▊▋▌▍▎▏ `

  - `█▇▆▅▄▃▂▁ `

- Font

  使用するフォントを選択する．

- Padding

  フォントの余白を設定する．フォントによっては見切れる場合があるので調整用．

- Blocks

  縦横どれだけ文字を設置するかを決める．

- Sharp Colors

  計算で使う色を決める．`Mosaic`と同じ．

- Luma Gain

  輝度調整．

- Min Luma

  使用する輝度の最小割合．

- Max Luma

  使用する輝度の最大割合．

- Luma Mode

  輝度計算方法を指定する．

  - BT.601: SD画質など

  - BT.709: HD画質など

  - BT.2020: 4K画質など

- Invert Luma

  輝度を反転する．`Min Luma`と`Max Luma`で設定した範囲は反転されない．

- Glyph Type

  表示する文字のタイプを指定する．

  - Solid: 下で設定した色を使用する．

  - Original: 元画像の色を使用する．

  - Mosaic: モザイク処理した元画像の色を使用する．

- Glyph Color

  文字の色を設定する．

- Canvas Type

  背景の種類を指定する．

  - Transparent: 透明．

  - Solid: 下で設定した色を使用する．

  - Original: 元画像の色を使用する．

  - Mosaic: モザイク処理した元画像の色を使用する．

- Canvas Color

  背景色を設定する．

- Color Space

  入力画像がsRGB画像かLinear画像を選択する．大体の画像はsRGBだと思う．

- Alpha

  入力画像のアルファ要素についての扱いを決める．

  - None: アルファなしとみなす．(透明部は黒)

  - Premultiplied: 乗算済みアルファとみなす．

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

- Shuffle Glyphs

  有効にすると`Glyphs`で設定した文字をシャッフルする．

- Excluded Glyphs

  シャッフル時除外する文字を区切りなしで入力する．

- Interval

  シャッフル間隔をフレーム数で入力する．

- Seed

  シャッフルの乱数発生の種．

- PI

  パラメータインジェクション．上記項目を上書きする．

  ```lua
  {
    glyphs = "@#%*+=-:. ",
    font = "Yu Gothic UI",
    padding = 0,
    bx = 80,
    by = 45,
    sharp_col = 0, -- booleanでも可．
    luma_gain = 100.0,
    min_luma = 0.0,
    max_luma = 100.0,
    luma_mode = 1,
    inv_luma = 0, -- booleanでも可．
    glyph_type = 0,
    glyph_col = 0xffffff,
    canvas_type = 0,
    canvas_col = 0x000000,
    col_space = 1,
    alpha = 0,
    blend_mode = 0,
    mix = 100.0,
    shuf_glyphs = 0, -- booleanでも可．
    excluded_glyphs = "",
    interval = 0,
    seed = -1
  }
  ```

  `{}`は挿入済みであるため，省略して記入する．

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

- PI

  パラメータインジェクション．上記項目を上書きする．

  ```lua
  {
    cx = 0.0,
    cy = 0.0,
    out_w = 100.0,
    out_h = 100.0,
    tile_w = 100.0,
    tile_h = 1000.0,
    mirror_h = 0, -- booleanでも可．
    mirror_v = 0, -- booleanでも可．
    phase = 0.0,
    h_shift = 0 -- booleanでも可．
  }
  ```

  `{}`は挿入済みであるため，省略して記入する．

### Tile

![tile_sample](/assets/tile_sample.jpg)

フレームバッファ基準のタイリング (画像ループ2)．

- Count

  複製回数．

- Gap

  画像間隔．100.0増えるごとに一枚分隙間が開く．

- Offset

  階段状にずらす．100.0で合計ズレ幅が1枚分になる．

- Center Align

  有効にすることで中央ぞろえにする．無効にすることで一方向にタイル状に並べる．`Gap`を負の数にすることで逆方向に並べることが可能．

- Use Group Pivot

  描画部での回転や拡大などをタイル (元画像) ごとに行う (`false`) か全体で行う (`true`) か決める．

  やや`true`のほうが軽い． 

- Z Size

  画像にZ方向のサイズがないのでここで設定する．

  初期値は画像の横幅と縦幅の最大値．

- PI

  パラメータインジェクション．上記項目を上書きする．

  ```lua
  {
    x_count = 3,
    y_count = 3,
    z_count = 1,
    x_gap = 100.0,
    y_gap = 100.0,
    z_gap = 100.0,
    x_offset = 0.0,
    y_offset = 0.0,
    center_align = 1, -- booleanでも可．
    use_group_pivot = 1, -- booleanでも可．
    z_size = math.max(obj.getpixel()) -- number
  }
  ```

  `{}`は挿入済みであるため，省略して記入する．

### Repeat

![repeat_sample](/assets/repeat_sample.jpg)

オブジェクトを指定した方法でフレームバッファに並べて描画する．

一方向に並べると円形配置を足して2で割ったようなスクリプト．

- Count

  複製回数．この値は`PI`項目で`count`という変数名で使用可能．

- Offset

  スタート位置．

- Composite

  合成順序

  - Below: 下に合成

  - Above: 上に合成

- Sync with Output Effect

  以下の`X`，`Y`，`Z`の値を描画エフェクトの`拡大率`および`縦横比`に応じて調整するかどうかを決める．

- X，Y，Z

  オブジェクト間隔をそれぞれの軸について設定する．

- Rotation

  それぞれの軸についてオブジェクト間回転角度を設定する．

- Zoom

  オブジェクト間拡大率を設定する．

- Start Alpha

  開始時の不透明度を決める．

- End Alpha

  終了時の不透明度を決める．

- PI

  パラメータインジェクション．上記項目を上書きする．

  ```lua
  {
    count = 3,
    offset = 0,
    composite = 0,
    sync = 1, -- booleanでも可．
    x = 100.0,
    y = 0.0,
    z = 0.0,
    rx = 0.0,
    ry = 0.0,
    rz = 0.0,
    zoom = 100.0,
    st_a = 100.0,
    ed_a = 100.0
  }
  ```

  `{}`は挿入済みであるため，省略して記入する．

> [!TIP]
> 円形配置のやり方．
> 
> `中心X，Y`で半径を設定する．その後，`PI`項目に`rz = 360.0 / count`と入力する．

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
> ファイル指定する場合は0または自分自身のレイヤー番号にする．

- Use Relative Layer

  `Map Layer`を相対値で設定．

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

- PI

  パラメータインジェクション．上記項目を上書きする．

  ```lua
  {
    map_path = "",
    map_layer = 0,
    use_rel_layer = 0, -- booleanでも可．
    view_map = 0, -- booleanでも可．
    map_hue = 0.0,
    map_slice = 50.0,
    map_scale = 100.0,
    map_shift = 0.0,
    map_edges = 0,
    inv_luma = 0, -- booleanでも可．
    luma_mode = 1,
    col_space = 1,
    blend_mode = 0,
    mix = 100.0
  }
  ```

  `{}`は挿入済みであるため，省略して記入する．

### Unpremultiply

![unpremult_sample](/assets/unpremult_sample.jpg)

黒色背景を透過する．

- Gain

  調整用．0ですべて透明，100を超えると一部黒色を透過しない．

- PI

  パラメータインジェクション．上記項目を上書きする．

  ```lua
  {
    gain = 100.0
  }
  ```

  `{}`は挿入済みであるため，省略して記入する．

## 既知の問題

### 特定スクリプトが動作しない

以下のスクリプトが動作しない場合，`system.conf`の`TemporaryImageCacheSize`が小さいことが原因であると考えられる．

- `Mosaic` (`Sharp Colors`が無効時) : 1キャッシュ

- `Posterize` (`Sharp Colors`が無効時) : 1キャッシュ

- `Posterize(RGBA)` (`Sharp Colors`が無効時) : 1キャッシュ

- `ASCII`: 3キャッシュ

- `MotionTile`: 1キャッシュ

- `GradientMap`: 2キャッシュ

AviUtl ExEdit2の能力を最大限引き出すためには1キャッシュあたり`268,435,456 (16384 x 16384)`必要である．したがって，`MotionTile`では`268,435,456`，`GradientMap`では`536,870,912`必要である．

`TemporaryImageCacheSize`は`int`最大値`2,147,483,647`まで設定可能である．

### Tileで拡大率パラメータが使用できない

AviUtl ExEdit2 beta7まででは発生しない現象である．今後のバージョンで`obj.drawpoly()`の仕様がExEdit 0.92に戻った場合，`Use Group Pivot`有効時に発生する．

## 謝辞

本スクリプトはティム様が公開されている[色調補正セットver6](https://www.nicovideo.jp/watch/sm35722623)，[モーションタイルT](https://www.nicovideo.jp/watch/sm20729858)，さつき様が公開されている[画像ループ2](https://bowlroll.net/file/3777)，[一方向に並べる](https://bowlroll.net/file/3777)，Auls様が公開されている[マス目指定モザイク](https://auls.client.jp/)，Aodaruma様が公開されている[グラデーションマップ(Re)](https://github.com/Aodaruma/GradationMap-Re)の出力結果を参考に作成いたしました．このような場をお借りして恐縮ではございますが，革新的かつ非常に有用なスクリプトを公開いただき，心より御礼申し上げます．

同梱のグラデーションマップにつきましては，ゼットデジタ様よりご提供いただいたものです．独自の審美眼と丁寧な作り込みにより多様な表現が可能となり，本スクリプトの表現幅を格段に広げることができました．このような高品質な素材をご提供いただけましたこと，心より御礼申し上げます．

## License

LICENSEファイルに記載．

## Change Log

- **v1.2.0**
  - `Mosaic`，`Posterize(RGBA)`，`ASCII`，`Repeat`スクリプトを追加．
  - 全スクリプトに`PI` (パラメータインジェクション) 項目を追加．
  - `Posterize`スクリプトの刷新．
    - アルゴリズムミスを修正．
    - `Value Only`，`Multi Channel Mode`，`R, G, B Level`の廃止． (破壊的変更)
    - `Channel`項目を追加． (`Value Only`を統合)
    - Alphaチャンネルもポスタリゼーションできる機能を追加．
    - `Size`項目で`Mosaic@Stylize_K`を呼び出すように変更．
    - `Sharp Colors`項目の追加． (`Mosaic`スクリプトの機能)
    - `Multi Channel Mode`を`Posterize(RGBA)`に分離．
  - `Threshold`スクリプトの色指定にてAlphaを設定できる機能を追加．
  - `Tile`スクリプトの機能追加．
    - `Offset`でX，Y方向のズレを設定できる機能を追加．
    - `Center Align`チェックボックスを追加．
    - `Gap`で負の数を認めるように変更．
  - `GradientMap`で相対レイヤーを指定できる機能を追加．
  - `MotionTile`，`GradientMap`の偶奇計算でビット演算を使用するように変更．

- **v1.1.0**
  - リニア空間からsRGB空間に変換した際，Alphaを飽和していなかった問題を解決．
  - `Unpremultiply`スクリプトを追加．

- **v1.0.0**
  - Release
