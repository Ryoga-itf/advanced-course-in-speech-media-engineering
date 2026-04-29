#import "../template.typ": *
#import "@preview/tenv:0.1.2": parse_dotenv
#import "@preview/physica:0.9.2": *
#import "@preview/cetz:0.5.0"

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: "第2回 レポート課題",
  authors: (
    (name: env.STUDENT_NAME, email: "学籍番号：" + env.STUDENT_ID, affiliation: "所属：情報科学類"),
  ),
  date: "2026 年 4 月 30 日",
)

#set footnote(numbering: sym.dagger + "1")

#set math.mat(delim: "[", gap: 0.5em)

== ①

方形窓 (p.9) のフーリエ変換 (p.3) を求めよ

=== 解答

方形窓は以下で定義される。(p.9)

$
w(t) = cases(
  1\, space |t| <= T \/ 2,
  0\, space "otherwise"
)
$

フーリエ変換の定義 (p.3) により、

$
W(f) = integral^(infinity)_(-infinity) w(t) e^(-j 2 pi f t) d t
$

である。
方形窓は $-T\/2 <= t <= T\/2$ の範囲でのみ $1$ なので、

$
W(f) = integral^(T\/2)_(-T\/2) e^(-j 2 pi f t) d t
$

となる。

$f != 0$ のとき、

$
W(f) &= [ e^(-j 2 pi f t) / (-j 2 pi f) ]^(T\/2)_(-T\/2) \
    &= (e^(-j pi f T) - e^(j pi f T)) / (-j 2 pi f)
$

ここでオイラーの公式により、

$
e^(j theta) - e^(-j theta) = 2 j sin theta
$

であるから、

$
W(f) = sin(pi f T) / (pi f)
$

である。

なお、$f = 0$ のときは

$
W(0) = integral^(T\/2)_(-T\/2) 1 d t = T
$

よって以上をまとめると、求めるべきものは

$
W(f) = cases(
  T\,                    space &f = 0,
  sin(pi f T) / (pi f)\, space &"otherwise"
)
$

== ②

高域強調は 1 次差分フィルタ $H(z) = 1 - a z^(-1)$ により実現される。
サンプリング周波数が 10kHz の信号に対して、直流成分と 5kHz 成分に対するフィルタ出力のパワー比が

$
20 log_10 (|H(e^(j 2 pi (5000 \/ 10000)))|) / (|H(e^(j 2 pi (0 \/ 10000)))|) = 40 "[dB]"
$

となるように $a (<1)$ を定めよ。ただし、導出過程を記すこと

=== 解答

与えられた式の左辺について、

$
20 log_10 (|H(e^(j 2 pi (5000 \/ 10000)))|) / (|H(e^(j 2 pi (0 \/ 10000)))|)
&= 20 log_10 (|H(e^(j pi))|) / (|H(e^(0))|)
&= 20 log_10 (|H(-1)|) / (|H(1)|)
$

よって、与式は以下のように変形できる。

$
20 log_10 (|H(-1)|) / (|H(1)|) &= 40 \
=> log_10 (|H(-1)|) / (|H(1)|) &= 2 \
therefore (|H(-1)|) / (|H(1)|) &= 100 \
$

$H(z) = 1 - a z^(-1)$ を代入すると、

$
(|1 + a|) / (|1 - a|) = 100
$

$a > 0$ より $|1 + a| = 1 + a$、$a < 1$ より $|1 - a| = 1 - a$

故に、

$
(1 + a) / (1 - a) &= 100 \
therefore       a &= 99 / 101 approx #(99 / 101)
$

== ③

次の信号の自己相関関数を求めよ。また、そのグラフを描きなさい

$
x(n) = 1, -1, 3, 1, -1, 3, space n = 0, 1, dots.c, 5
$

=== 解答

与えられた信号のサンプル数は $N = 6$ である。

授業資料の定義に従い、自己相関関数を求めると、

$
r(0) &= 1/6 { 1^2 + (-1)^2 + 3^2 + 1^2 + (-1)^2 + 3^2 } = 1/6 (1 + 1 + 9 + 1 + 1 + 9) = 11/3 \
r(1) &= 1/6 { 1 (-1) + (-1) 3 + 3 dot 1 + 1 (-1) + (-1) 3 } = 1/6 (-1 - 3 + 3 - 1 - 3) = -5/6 \
r(2) &= 1/6 { 1 dot 3 + (-1) 1 + 3 (-1) + 1 dot 3 } = 1/6 (3 - 1 - 3 + 3) = 1/3 \
r(3) &= 1/6 { 1 dot 1 + (-1)(-1) + 3 dot 3 } = 1/6 (1 + 1 + 9) = 11/6 \
r(4) &= 1/6 { 1 (-1) + (-1)3 } = 1/6 (-1 - 3) = -2/3 \
r(5) &= 1/6 { 1 dot 3 } = 1/2 \
$

グラフは @fig1 のようになる。

#figure(
  cetz.canvas({
    import cetz.draw: *

    let pts-data = (
      (0.0, 11.0 / 3.0),
      (1.0, -5.0 / 6.0),
      (2.0,  1.0 / 3.0),
      (3.0, 11.0 / 6.0),
      (4.0, -2.0 / 3.0),
      (5.0,  1.0 / 2.0),
    )

    let xmin = -0.5
    let xmax = 5.5
    let ymin = -1.2
    let ymax = 4.2

    let W = 12.0
    let H = 7.0

    let p = (x, y) => (
      (x - xmin) / (xmax - xmin) * W,
      (y - ymin) / (ymax - ymin) * H,
    )

    let pts = pts-data.map(pt => p(pt.at(0), pt.at(1)))

    // 外枠
    rect((0, 0), (W, H), stroke: black + 0.5pt)

    // グリッド
    for x in (0, 1, 2, 3, 4, 5) {
      line(p(x, ymin), p(x, ymax), stroke: gray + 0.2pt)
    }

    for y in (-1, 0, 1, 2, 3, 4) {
      line(p(xmin, y), p(xmax, y), stroke: gray + 0.2pt)
    }

    // 軸
    line(p(xmin, 0), p(xmax, 0), stroke: black + 0.6pt)
    line(p(0, ymin), p(0, ymax), stroke: black + 0.6pt)

    // 折れ線
    line(..pts, stroke: (paint: blue, thickness: 1.2pt))

    // 各点
    for pt in pts {
      circle(pt, radius: 1.8pt, fill: blue)
    }

    // x軸ラベル
    for k in (0, 1, 2, 3, 4, 5) {
      content((p(k, ymin).at(0), -0.35), [$#k$])
    }

    // y軸ラベル
    content((-0.45, p(xmin, -1).at(1)), [$-1$])
    content((-0.35, p(xmin, 0).at(1)), [$0$])
    content((-0.35, p(xmin, 1).at(1)), [$1$])
    content((-0.35, p(xmin, 2).at(1)), [$2$])
    content((-0.35, p(xmin, 3).at(1)), [$3$])
    content((-0.35, p(xmin, 4).at(1)), [$4$])

    content((0.8, p(0, -0.2).at(1)), [$O$])

    // 軸名
    content((W / 2, -0.75), [$k$])
    content((-0.7, H + 0.2), [$r(k)$])
  }),
  caption: [信号 $x(n)=1,-1,3,1,-1,3$ の自己相関関数],
) <fig1>

== ④

③ の信号の線形予測係数を求めよ。ただし、分析次数は2とする

=== 解答

ユール・ウォーカー（Yule-Walker）方程式

$
mat(
  r(0), r(1);
  r(1), r(0),
)
mat(
  a_1; a_2
) = 
- mat(
  r(1); r(2)
)
$

に③より、

$
r(0) = 11/3, space r(1) = -5/6, space r(2) = 1/3
$

であるから、これを方程式に代入することで

$
mat(
  11/3, -5/6;
  -5/6, 11/3,
)
mat(
  a_1; a_2
) = 
- mat(
  -5/6; 1/3
)
$

両辺に 6 を掛けると、

$
mat(
  22, -5;
  -5, 22,
)
mat(
  a_1; a_2
) = 
mat(
  5; -2
)
$

したがって、

$
22 a_1 - 5 a_2  &= 5 \
-5 a_1 + 22 a_2 &= -2
$

この連立方程式を解くことにより

$
a_1 = 100/459, space a_2 = -19/459
$

を得る。
