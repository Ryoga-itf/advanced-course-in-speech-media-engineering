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

フーリエ変換の定義により、

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

== ④

③ の信号の線形予測係数を求めよ。ただし、分析次数は2とする

=== 解答
