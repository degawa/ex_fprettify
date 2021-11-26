# Examples of fprettify

Fortran用のコード整形ツール[fprettify](https://github.com/pseewald/fprettify)の使用例．

## 要求ソフトウェア
- fprettify

## ビルド
このプロジェクトはコード整形の例を提供するため，ビルドは不要である．
`fpm build`で問題なくビルドできるが，実行内容に意味は無い．

## fprettifyの使用例
### プロジェクトの構造
fpmのプロジェクト構造に沿っている．以降の作業は全てカレントディレクトリ（`.`）で行う．

```
.
├── app
│   └── main.f90
├── src
│   ├── mod1.f90
│   ├── mod2.f08
│   └── type_vector2.f90
├── .gitignore
├── fpm.toml
└── README.md
```

### ソースの整形
オプションとして指定したファイルを整形し，ファイルを上書きする．

```console
fprettify app\main.f90
```

複数のファイルを同時に整形するには，オプションとして複数のファイルを指定する．

```console
fprettify app\main.f90 src\mod1.f90
```

文末に`!&`を付けた行は整形されない．複数行の整形を行わない場合は，`!&<`から`!&>`で囲む．

```Fortran
!&<
do k = 1, Nz
do j = 1, Ny
do i = 1, Nx
    print *, i, &
             j, &
             k
end do
end do
end do
!&>
```

`--stdout`オプションを付与すると，ファイルを上書きせずに標準出力に整形結果を出力する．

```console
fprettify --stdout src\mod1.f90
```

`--diff`オプションを付与すると，ファイルを上書きせずに標準出力に整形結果を出力する．その際，整形前の状態も重ねて表示され，整形前後にそれぞれ`-`,`+`が表示される．

### インデントの制御
`--indent 数字`でインデントの幅を制御する．

#### インデント幅の無効化
`--disable-indent`でインデント幅の制御を無効化する．インデント幅を変更せずに，空白などを整形する場合に利用する．

#### program, module内のインデント
`--disable-indent-mod`を付与すると，`program`や`module`に対するインデントを抑制する．

```
fprettify --disable-indent-mod src\mod1.f90
```

```Fortran
module mod1
use, intrinsic :: iso_fortran_env
implicit none

contains
subroutine test()
    use, intrinsic :: iso_fortran_env
    implicit none

end subroutine test
end module mod1
```

#### 多重ループのインデント
fprettifyは多重ループをインデントしないが，`--strict-indent`を付与すると必ずインデントするようになる．

```
fprettify --strict-indent app\main.f90
```

```Fortran
do k = 1, Nz
    do j = 1, Ny
        do i = 1, Nx
            print *, .not. .true.
        end do
    end do
end do
```

#### fyppのディレクティブブロック内のインデント
Fortran用のメタプログラミングツールfyppでは，`#:if`や`#:for`などのブロックを記述する．fprettifyはこのブロック内のインデントにも対応しており，インデントを行う．
`--disable-fypp`オプションを付与すると，fyppのブロックに対するインデントは行われなくなる．

### 空白の制御
#### プリセット
`--whitespace プリセット番号`で空白をまとめて制御する．

- 0
    - 文に続く`()`の後（`write() ""`, `if() then`など）
    - セミコロン`;`の後ろ
    - 行継続記号`&`の前
- 1
    - プリセット0
    - カンマ`,`の後
    - 代入演算子，関係演算子，論理演算子の前後
    - 文に続く`()`の前（`write ()`, `if ()`）
    - 書式を`*`で指定したときの`print`, `read`と`*`の間
    - `end`と構文名の間（`end do`, `end block`など）
- 2
    - プリセット1
    - `+`, `-`の前後
- 3
    - プリセット2
    - `*`, `/`の前後
- 4
    - プリセット3
    - `%`の前後

#### 空白の整形の無効化
`--disable-whitespace`を指定すると，空白の整形を無効化する．空白は変えずにインデント幅のみを変えるような用途に利用できる．

#### 個別の空白の制御
空白を個別に制御するオプションは，追加のパラメータ`true`, `false`を与えることで，空白を入れるか空白を削除するかを選択する．

- `--whitespace-comma `<br>カンマの後の空白．
- `--whitespace-assignment`<br>代入演算子前後の空白．
- `--whitespace-relational`<br>関係演算子前後の空白．
- `--whitespace-logical`<br>論理演算子前後の空白．
- `--whitespace-plusminus`<br>`+`, `-`前後の空白．
- `--whitespace-multdiv`<br>`*`, `/`前後の空白．
- `--whitespace-print`<br>`print`, `read`と`*`の間の空白．
- `--whitespace-type`<br>`%`前後の空白．
- `--whitespace-intrinsics`<br>文の名前とそれに続く`()`の間．
- `--whitespace-decl`<br> `::`の前後．同時に`--enable-decl`を指定する．

#### コメント前のスペース
`--strip-comments`を付与すると，行の末尾に書かれたコメント記号の前に空白が入る．

### 関係演算子のスタイルの制御
#### 90スタイルから77スタイルへの変換
`--enable-replacements`を付与すると，90の関係演算子が77の関係演算子に置き換えられる．

#### 77スタイルから90スタイルへの変換
`--enable-replacements`に加えて`--c-relations`を付与すると，77の関係演算子が90の関係演算子に置き換えられる．

### キャピタリゼーションの制御
`--case パラメータ1 パラメータ2 パラメータ3 パラメータ4`で大文字/小文字を変換する．

パラメータの値は`0`, `1`, `2`のいずれかを取る．
- 0<br>入力ファイルの状態から何も変換しない．
- 1<br>小文字に変換する．
- 2<br>大文字に変換する．

パラメータの順番によって制御対象が決められている．
- パラメータ1
    - キーワード（文の名前）
- パラメータ2
    - 組込のモジュール名
    - 組込の手続名
- パラメータ3
    - 関係演算子
    - 論理演算子
    - 論理値
- パラメータ4
    - 組込の定数
    - 指数記号

### fprettifyの実行制御
- `--line-length`<br>fprettifyが実行する1行の文字数を指定する．その文字数を超えた行は整形されない．
- `--silent`,`--no-report-errors`<br>エラー出力を抑制する．
- `--recursive フォルダパス`<br>指定したフォルダとサブフォルダ内のファイルをを一括して整形する．整形対象は，`f`/`F`, `for`/`FOR`, `ftn`/`FTN`, `f90`/`F90`, `f95`/`F95`,`f03`/`F03`, `fpp`/`FPP`．<br>`fprettify --recursive .`<br>拡張子を追加するには`--fortran`オプション，ファイルを除外するには`--exclude`オプションを利用する．
- `--fortran 拡張子`<br>fprettifyで整形の対象とするファイル拡張子を指定する．追加ではなく，このオプションで指定した拡張子だけが整形対象となる．パラメータは一つしか取れないので，複数の拡張子を整形対象にする場合は，複数回付与する．<br>`fprettify --recursive . --fortran f90 --fortran f08`
- `--exclude ファイルもしくはフォルダ名`<br>`--recursive`オプションを付与して一括で整形する際に，整形から除外するファイルやフォルダを指定する．パラメータは一つしか取れないので，複数のファイルやフォルダを整形対象から除外にする場合は，複数回付与するかワイルドカードなどを使う．<br>`fprettify --recursive . --fortran f90 --fortran f08 --exclude src\mod1.f90 --exclude src\mod2.f08`
- `--config-file`<br>オプションが記述された設定ファイルを読み込む．標準の名前は`.fprettify.rc`であり，作業ディレクトリに設定ファイルが存在すると，自動的に参照する．

## 参考
[モダンFortran向けソースファイル自動整形ツールfprettifyの使い方](https://qiita.com/implicit_none/items/73431eb73d5ec88802e3)