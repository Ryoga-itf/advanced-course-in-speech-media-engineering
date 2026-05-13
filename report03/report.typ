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

与えられた距離表から DP を行うと、累積距離表は @tbl:dp1 のようになる。

#set table(inset: (x: 0.6em, y: 0.6em), stroke: none)
#set table.hline(stroke: 0.6pt)
#set table.vline(stroke: 0.6pt)

#figure(
  table(
    columns: 5,
    // align: (left + horizon, left + horizon, left + horizon, left + horizon),
    align: horizon,
    table.hline(),
    table.header([], [$x_1$], [$x_2$], [$x_3$], [$x_4$]),
    table.hline(),
    [$y_6$], [$17$], [$18$], [$23$], [$27$],
    [$y_5$], [$15$], [$20$], [$16$], [$22$],
    [$y_4$], [$14$], [$16$], [$15$], [$18$],
    [$y_3$], [$10$], [ $9$], [$13$], [$14$],
    [$y_2$], [ $5$], [ $7$], [$15$], [$11$],
    [$y_1$], [ $2$], [ $3$], [ $8$], [ $9$],
    table.hline(),
  ),
  caption: [累積距離表],
) <tbl:dp1>

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

