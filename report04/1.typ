#import "@preview/cetz:0.5.0"

== ①

入力パターン「aba」に対する確率をフォワードアルゴリズムとバックワードアルゴリズムにより求めよ

#figure(
  image("fig01.jpg", width: 50%),
)

=== 解答

#import "prob-graph.typ": N, draw-prob-graph

#let data-forward = (
  states: ([$q_1$], [$q_2$]),
  heads: (none, [$a$], [$b$], [$a$]),
  nodes: (
    (
      N([$1.0$], right: [$0.5 dot 0.2$], down: [$0.5 dot 0.8$]),
      N(none),
    ),
    (
      N([$0.1$], right: [$0.5 dot 0.8$], down: [$0.5 dot 0.2$]),
      N([$0.4$], right: [$1.0 dot 0.2$]),
    ),
    (
      N([$0.04$], down: [$0.5 dot 0.8$]),
      N([$0.09$], right: [$1.0 dot 0.8$]),
    ),
    (
      N(none),
      N([$0.088$]),
    ),
  ),
)

#let data-backward = (
  states: ([$q_1$], [$q_2$]),
  heads: (none, [$a$], [$b$], [$a$]),
  nodes: (
    (
      N([$0.088$], right: [$0.5 dot 0.2$], down: [$0.5 dot 0.8$]),
      N(none),
    ),
    (
      N([$0.24$], right: [$0.5 dot 0.8$], down: [$0.5 dot 0.2$]),
      N([$0.16$], right: [$1.0 dot 0.2$]),
    ),
    (
      N([$0.4$], down: [$0.5 dot 0.8$]),
      N([$0.8$], right: [$1.0 dot 0.8$]),
    ),
    (
      N([$0$]),
      N([$1.0$]),
    ),
  ),
)

#figure(
  draw-prob-graph(data-forward),
  caption: [フォワードアルゴリズムによる導出],
)

#figure(
  draw-prob-graph(data-backward),
  caption: [バックワードアルゴリズムによる導出],
)

以上より、求める確率は $0.088$
