#import "../template.typ": *
#import "@preview/tenv:0.1.2": parse_dotenv
#import "@preview/physica:0.9.2": *
#import "@preview/cetz:0.5.0"

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: "第3回 レポート課題",
  authors: (
    (name: env.STUDENT_NAME, email: "学籍番号：" + env.STUDENT_ID, affiliation: "所属：情報科学類"),
  ),
  date: "2026 年 5 月 14 日",
)

#set footnote(numbering: sym.dagger + "1")

#set math.mat(delim: "[", gap: 0.5em)

== ①

入力パターンと標準パターンの対応、累積距離、正規化累積距離を求めよ

#figure(
  image("fig01.jpg", width: 80%),
)

=== 解答

制約条件により、各点 $(x_i, y_i)$ へは左または下から進むものとする。
したがって累積距離 $G(i, j)$ は、

$
  G(i, j) = d(i, j) + min{ G(i - 1, j), G(i, j - 1) }
$

で計算する。ただし始点は $(x_1, y_1)$ である。

与えられた距離表から DP を行うと、累積距離表は @fig:dp1 のようになる。

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // 局所距離 d(x_i, y_j)
    // 下から y1, y2, ..., y6 の順
    let d = (
      (2, 1, 5, 1),
      (3, 4, 8, 2),
      (5, 2, 4, 3),
      (4, 7, 2, 4),
      (1, 5, 1, 6),
      (2, 1, 7, 5),
    )

    // 累積距離 G(i,j)
    let g = (
      (2, 3, 8, 9),
      (5, 7, 15, 11),
      (10, 9, 13, 14),
      (14, 16, 15, 18),
      (15, 20, 16, 22),
      (17, 18, 23, 27),
    )

    let xs = (1.2, 2.5, 3.8, 5.1)
    let ys = (1.0, 2.0, 3.0, 4.0, 5.0, 6.0)

    // 最適経路
    let path = (
      (1.2, 1.0),
      (2.5, 1.0),
      (2.5, 2.0),
      (2.5, 3.0),
      (3.8, 3.0),
      (3.8, 4.0),
      (3.8, 5.0),
      (5.1, 5.0),
      (5.1, 6.0),
    )

    // 軸
    line((0.55, 0.55), (5.65, 0.55), stroke: 0.8pt)
    line((0.55, 0.55), (0.55, 6.45), stroke: 0.8pt)

    // 軸ラベル
    content((5.85, 0.42), text(size: 16pt)[$X$])
    content((0.45, 6.68), text(size: 16pt)[$Y$])

    // x_i ラベル
    for i in range(4) {
      content((xs.at(i), 0.18), text(size: 13pt)[$x_#(i + 1)$])
    }

    // y_j ラベル
    for j in range(6) {
      content((0.2, ys.at(j)), text(size: 13pt)[$y_#(j + 1)$])
    }

    // 最適経路を先に描く
    for k in range(path.len() - 1) {
      line(
        path.at(k),
        path.at(k + 1),
        stroke: 2pt + red,
      )
    }

    // ノード
    for j in range(6) {
      for i in range(4) {
        let x = xs.at(i)
        let y = ys.at(j)

        // 円
        circle(
          (x, y),
          radius: 0.34,
          stroke: 0.8pt,
          fill: white,
        )

        // 中央：局所距離
        content(
          (x, y),
          text(size: 16pt)[#d.at(j).at(i)],
        )

        // 右上：累積距離
        content(
          (x + 0.32, y + 0.32),
          text(size: 7pt, fill: red)[#g.at(j).at(i)],
        )
      }
    }

    // 凡例
    content(
      (3.6, 6.65),
      text(size: 9pt)[赤線：最適経路，赤小数字：累積距離],
    )
  }),
  caption: [課題①の DP 格子図],
) <fig:dp1>

最小経路、すなわち入力パターンと標準パターンの対応は次の通り。

$
  (x_1, y_1) -> (x_2, y_1) -> (x_2, y_2) -> (x_2, y_3) -> (x_3, y_3) -> (x_3, y_4) -> (x_3, y_5) -> (x_4, y_5)
$

この経路上の距離は

$
  2+1+4+2+4+2+1+6+5=27
$

である。
したがって累積距離は $27$ である。

また、この制約条件では始点から終点までの通過点数は

$
  4 + 6 - 1 = 9
$

なので、正規化累積距離は

$
  27 / 9 = 3
$

である。

== ②

単語列、入力パターンと標準パターンの対応、累積距離、正規化累積距離を求めよ

=== 解答
