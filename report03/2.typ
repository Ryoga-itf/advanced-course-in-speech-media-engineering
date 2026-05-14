#import "@preview/cetz:0.5.0"

== ②

単語列、入力パターンと標準パターンの対応、累積距離、正規化累積距離を求めよ

=== 解答

標準パターンを

$
  A = { a, b, a }, space B = { b, c }
$

入力パターンを

$
  X = { a, b, b, c, b, c }
$

とする。候補となる単語列は、

$
  "AA", "AB", "BA", "BB"
$

である。

距離尺度は問題文より、

$
  d(a, b) = d(b, a) = 2 \
  d(a, c) = d(c, a) = 3 \
  d(b, c) = d(c, b) = 1 \
  d(a, a) = d(b, b) = d(c, c) = 0
$

である。

また、本課題の制約条件では、入力フレームが $1$ つ進むごとに、標準パターン側では同じ状態にとどまるか、次の状態へ進む。
したがって、累積距離 $G(i,j)$ は

$
  G(i, j) = d(x_i, y_i) + min{ G(i - 1, j), G(i - 1, j - 1) }
$

によって計算する。
ただし、$x_i$ は入力パターン、$y_j$ は標準パターンを表す。

#set enum(numbering: "a.")

+ 2段 DP 法

#let dx = 1.45
#let dy = 1.20
#let rad = 0.28

#let pos(origin, col, row) = (
  origin.at(0) + col * dx,
  origin.at(1) + row * dy,
)

#let draw-panel(origin, title, patname, rowlabels, costs, cums, highlight) = {
  import cetz.draw: *

  let rows = rowlabels.len()
  let ox = origin.at(0)
  let oy = origin.at(1)

  // タイトル
  content(
    (ox + 2.0 * dx, oy + rows * dy),
    text(size: 9pt)[#title],
  )

  // 軸
  line(
    (ox - 0.45, oy - 0.45),
    (ox + 5 * dx + 0.55, oy - 0.45),
    stroke: 0.8pt,
    mark: (end: "stealth", fill: black),
  )
  line(
    (ox - 0.45, oy - 0.45),
    (ox - 0.45, oy + (rows - 1) * dy + 0.55),
    stroke: 0.8pt,
    mark: (end: "stealth", fill: black),
  )

  content((ox + 5 * dx + 0.80, oy - 0.35), text(size: 12pt)[$X$])
  content((ox - 0.10, oy + (rows - 1) * dy + 0.82), text(size: 12pt)[#patname])

  // x ラベル
  let xlabels = ($x_1$, $x_2$, $x_3$, $x_4$, $x_5$, $x_6$)
  for c in range(6) {
    content((ox + c * dx, oy - 0.80), text(size: 9pt)[#xlabels.at(c)])
  }

  // 行ラベル
  for r in range(rows) {
    content((ox - 0.95, oy + r * dy), text(size: 9pt)[#rowlabels.at(r)])
  }

  // 許される遷移を薄く描く
  // 横: 同じ状態にとどまる
  // 斜め右上: 次の状態へ進む
  for c in range(5) {
    for r in range(rows) {
      // 横遷移
      line(
        pos(origin, c, r),
        pos(origin, c + 1, r),
        stroke: 0.35pt + gray,
      )

      // 斜め右上遷移
      if r + 1 < rows {
        line(
          pos(origin, c, r),
          pos(origin, c + 1, r + 1),
          stroke: 0.35pt + gray,
        )
      }
    }
  }

  // 強調したい最適経路
  if highlight.len() > 1 {
    for k in range(highlight.len() - 1) {
      let a = highlight.at(k)
      let b = highlight.at(k + 1)
      line(
        pos(origin, a.at(0), a.at(1)),
        pos(origin, b.at(0), b.at(1)),
        stroke: 1.3pt + red,
      )
    }
  }

  // 局所距離のノード
  for r in range(rows) {
    for c in range(6) {
      let p = pos(origin, c, r)
      circle(p, radius: rad, fill: white, stroke: 0.7pt)
      content(p, text(size: 9pt)[#costs.at(r).at(c)])
    }
  }

  // 累積距離
  for item in cums {
    let c = item.at(0)
    let r = item.at(1)
    let v = item.at(2)
    let p = pos(origin, c, r)
    content(
      (p.at(0) + 0.30, p.at(1) + 0.34),
      text(size: 8pt, fill: red)[#v],
    )
  }
}

// 入力 X = a b b c b c
// A = a b a
// B = b c

#let costs-a = (
  (0, 2, 2, 3, 2, 3), // a₁
  (2, 0, 0, 1, 0, 1), // a₂
  (0, 2, 2, 3, 2, 3), // a₃
)

#let costs-b = (
  (2, 0, 0, 1, 0, 1), // b₁
  (3, 1, 1, 0, 1, 0), // b₂
)

// -----------------------------
// A = aba
// -----------------------------

#figure(
  cetz.canvas(length: 8mm, {
    import cetz.draw: *

    draw-panel(
      (1.2, 8.4),
      [始点: 第1フレーム],
      $A$,
      ($a_1$, $a_2$, $a_3$),
      costs-a,
      (
        (0, 0, 0),
        (1, 0, 2),
        (2, 0, 4),
        (3, 0, 7),
        (4, 0, 9),
        (5, 0, 12),
        (1, 1, 0),
        (2, 1, 0),
        (3, 1, 1),
        (4, 1, 1),
        (5, 1, 2),
        (2, 2, 2),
        (3, 2, 3),
        (4, 2, 3),
        (5, 2, 4),
      ),
      (),
    )

    draw-panel(
      (11.0, 8.4),
      [始点: 第2フレーム],
      $A$,
      ($a_1$, $a_2$, $a_3$),
      costs-a,
      (
        (1, 0, 2),
        (2, 0, 4),
        (3, 0, 7),
        (4, 0, 9),
        (5, 0, 12),
        (2, 1, 2),
        (3, 1, 3),
        (4, 1, 3),
        (5, 1, 4),
        (3, 2, 5),
        (4, 2, 5),
        (5, 2, 6),
      ),
      (),
    )

    draw-panel(
      (1.2, 3.0),
      [始点: 第3フレーム],
      $A$,
      ($a_1$, $a_2$, $a_3$),
      costs-a,
      (
        (2, 0, 2),
        (3, 0, 5),
        (4, 0, 7),
        (5, 0, 10),
        (3, 1, 3),
        (4, 1, 3),
        (5, 1, 4),
        (4, 2, 5),
        (5, 2, 6),
      ),
      (),
    )

    draw-panel(
      (11.0, 3.0),
      [始点: 第4フレーム],
      "A",
      ("a₁", "a₂", "a₃"),
      costs-a,
      (
        (3, 0, 3),
        (4, 0, 5),
        (5, 0, 8),
        (4, 1, 3),
        (5, 1, 4),
        (5, 2, 6),
      ),
      (),
    )
  }),
  caption: [2段DP法 第1段：単語 $A=\{a,b,a\}$ の単語内DP],
)

// -----------------------------
// B = bc
// -----------------------------

#figure(
  cetz.canvas(length: 8mm, {
    import cetz.draw: *

    draw-panel(
      (1.2, 8.6),
      [始点: 第1フレーム],
      $B$,
      ($b_1$, $b_2$),
      costs-b,
      (
        (0, 0, 2),
        (1, 0, 2),
        (2, 0, 2),
        (3, 0, 3),
        (4, 0, 3),
        (5, 0, 4),
        (1, 1, 3),
        (2, 1, 3),
        (3, 1, 2),
        (4, 1, 3),
        (5, 1, 3),
      ),
      ((0, 0), (1, 0), (2, 0), (3, 1)),
    )

    draw-panel(
      (11.0, 8.6),
      [始点: 第2フレーム],
      $B$,
      ($b_1$, $b_2$),
      costs-b,
      (
        (1, 0, 0),
        (2, 0, 0),
        (3, 0, 1),
        (4, 0, 1),
        (5, 0, 2),
        (2, 1, 1),
        (3, 1, 0),
        (4, 1, 1),
        (5, 1, 1),
      ),
      (),
    )

    draw-panel(
      (1.2, 4.2),
      [始点: 第3フレーム],
      $B$,
      ($b_1$, $b_2$),
      costs-b,
      (
        (2, 0, 0),
        (3, 0, 1),
        (4, 0, 1),
        (5, 0, 2),
        (3, 1, 0),
        (4, 1, 1),
        (5, 1, 1),
      ),
      (),
    )

    draw-panel(
      (11.0, 4.2),
      [始点: 第4フレーム],
      $B$,
      ($b_1$, $b_2$),
      costs-b,
      (
        (3, 0, 1),
        (4, 0, 1),
        (5, 0, 2),
        (4, 1, 2),
        (5, 1, 1),
      ),
      (),
    )

    draw-panel(
      (6.1, 0),
      [始点: 第5フレーム],
      $B$,
      ($b_1$, $b_2$),
      costs-b,
      (
        (4, 0, 0),
        (5, 0, 1),
        (5, 1, 0),
      ),
      ((4, 0), (5, 1)),
    )
  }),
  caption: [2段DP法 第1段：単語 $B=\{b,c\}$ の単語内DP],
)

#figure(
  table(
    columns: 6,
    align: center + horizon,
    inset: 6pt,
    stroke: 0.8pt,

    // header row
    [], [1], [2], [3], [4], [5],

    // row 1
    [1], [], [$min(2, 4)=2$], [$min(4, 6)=4$], [$min(7, 6)=6$], [$min(9, 11)=9$],

    // row 2
    [2], [], [], [$min(4, 4)=4$], [$min(7, 4)=4$], [$min(9, 9)=9$],

    // row 3
    [3], [], [], [], [$min(6, 3)=3$], [$min(7, 8)=7$],

    // row 4
    [4], [], [], [], [], [$min(4, 8)=4$],

    // row 5
    [5], [], [], [], [], [],
  ),
  caption: [始点 $s$・終点 $e$ に対する1単語最小距離（$min$ の左が A，右が B）],
)

#figure(
  table(
    columns: 3,
    align: center + horizon,
    inset: 6pt,
    stroke: 0.8pt,

    // header row
    [$e$], [1単語], [2単語],
    [1], [], [],
    [2], [], [],
    [3], [], [],
    [4], [], [],
    [5], [], [],
    [6], [3], [$min(3+1, 2+1, 2+0) = 2$],
  ),
)

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    content((2, 2), text(size: 13pt)[$b$])
    content((3, 2), text(size: 13pt)[$c$])
    content((4, 2), text(size: 13pt)[$b$])
    content((5, 2), text(size: 13pt)[$c$])

    content((1, 0), text(size: 13pt)[$a$])
    content((2, 0), text(size: 13pt)[$b$])
    content((3, 0), text(size: 13pt)[$b$])
    content((4, 0), text(size: 13pt)[$c$])
    content((5, 0), text(size: 13pt)[$b$])
    content((6, 0), text(size: 13pt)[$c$])

    line((2, 2 - 0.3), (1 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))
    line((2, 2 - 0.3), (2 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))
    line((2, 2 - 0.3), (3 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))

    line((3, 2 - 0.3), (4 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))

    line((4, 2 - 0.3), (5 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))

    line((5, 2 - 0.3), (6 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))
  }),
)

よって、

- 単語列：$"BB"$
- 累積距離：$2$
- 正規化累積距離：$2 / 6 = 1 / 3$


+ レベルベルディング法

#let dx = 1.45
#let dy = 1.15
#let rad = 0.28

#let p(origin, c, r) = (
  origin.at(0) + c * dx,
  origin.at(1) + r * dy,
)

#let draw-dashed-line(x1, y, x2) = {
  import cetz.draw: *
  let seg = 0.22
  let gap = 0.14
  let n = calc.floor((x2 - x1) / (seg + gap))
  for k in range(n) {
    let a = x1 + k * (seg + gap)
    line((a, y), (a + seg, y), stroke: 0.6pt)
  }
}

#let draw-arrow(origin, from, to, color: black, width: 0.8pt) = {
  import cetz.draw: *
  line(
    p(origin, from.at(0), from.at(1)),
    p(origin, to.at(0), to.at(1)),
    stroke: width + color,
    mark: (end: ">", fill: black),
  )
}

#let draw-word-panel(
  origin,
  title,
  word-name,
  rowlabels,
  costs,
  cums,
  arrows,
  base: (),
) = {
  import cetz.draw: *

  let ox = origin.at(0)
  let oy = origin.at(1)
  let rows = rowlabels.len()
  let has-base = base.len() > 0

  let axis-y = if has-base { oy - dy - 0.45 } else { oy - 0.45 }
  let xlabels-y = axis-y - 0.42
  let top-y = oy + (rows - 1) * dy + 0.55

  // タイトル
  content(
    (ox + 2.5 * dx, top-y + 0.55),
    text(size: 10pt)[#title],
  )

  // 軸
  line((ox - 0.45, axis-y), (ox + 5 * dx + 0.45, axis-y), stroke: 0.8pt)
  line((ox - 0.45, axis-y), (ox - 0.45, top-y), stroke: 0.8pt)

  content((ox + 5 * dx + 0.70, axis-y), text(size: 13pt)[$X$])
  content((ox - 0.40, top-y + 0.23), text(size: 13pt)[#word-name])

  // x ラベル
  let xlabels = ($x_1$, $x_2$, $x_3$, $x_4$, $x_5$, $x_6$)
  for c in range(6) {
    content((ox + c * dx, xlabels-y), text(size: 9pt)[#xlabels.at(c)])
  }

  // 行ラベル
  for r in range(rows) {
    content((ox - 0.95, oy + r * dy), text(size: 10pt)[#rowlabels.at(r)])
  }

  // レベル境界の破線
  if has-base {
    draw-dashed-line(ox - 0.35, oy - dy / 2, ox + 5 * dx + 0.35)
  }

  // 下段：前レベルのスコア
  // base item = (col, label, value)
  if has-base {
    for item in base {
      let c = item.at(0)
      let lab = item.at(1)
      let val = item.at(2)
      let q = p(origin, c, -1)

      circle(q, radius: rad, fill: white, stroke: 0.7pt)

      if lab != "" {
        content((q.at(0) - 0.45, q.at(1)), text(size: 10pt)[#lab])
      }

      if val != "" {
        content(q, text(size: 10pt)[#val])
      }
    }
  }

  // 局所距離ノード
  for r in range(rows) {
    for c in range(6) {
      let q = p(origin, c, r)
      circle(q, radius: rad, fill: white, stroke: 0.7pt)
      content(q, text(size: 10pt)[#costs.at(r).at(c)])
    }
  }

  let vadd(a, b) = a.zip(b, exact: true).map(((x, y)) => x + y)

  // 矢印
  for edge in arrows {
    if (edge.at(0).at(1) == edge.at(1).at(1)) {
      draw-arrow(origin, vadd(edge.at(0), (0.2, 0)), vadd(edge.at(1), (-0.2, 0)))
    } else {
      draw-arrow(origin, vadd(edge.at(0), (0.2, 0.2)), vadd(edge.at(1), (-0.15, -0.15)))
    }
  }

  // 累積距離
  // cums item = (col, row, value)
  for item in cums {
    let c = item.at(0)
    let r = item.at(1)
    let val = item.at(2)
    let q = p(origin, c, r)

    content(
      (q.at(0) + 0.30, q.at(1) + 0.34),
      text(size: 9pt)[#val],
    )
  }
}

// 入力 X = a b b c b c
// A = a b a
// B = b c

#let costs-a = (
  (0, 2, 2, 3, 2, 3), // a₁
  (2, 0, 0, 1, 0, 1), // a₂
  (0, 2, 2, 3, 2, 3), // a₃
)

#let costs-b = (
  (2, 0, 0, 1, 0, 1), // b₁
  (3, 1, 1, 0, 1, 0), // b₂
)

// ------------------------------------------------------------
// 第1レベル：入力の先頭から 1 単語を対応させる
// ------------------------------------------------------------

#figure(
  cetz.canvas(length: 8mm, {
    import cetz.draw: *

    draw-word-panel(
      (1.2, 5.8),
      [第1レベル：単語 A],
      $A$,
      ($a_1$, $a_2$, $a_3$),
      costs-a,
      (
        (0, 0, 0),
        (1, 0, 2),
        (2, 0, 4),
        (3, 0, 7),
        (4, 0, 9),
        (5, 0, 12),
        (1, 1, 0),
        (2, 1, 0),
        (3, 1, 1),
        (4, 1, 1),
        (5, 1, 2),
        (2, 2, 2),
        (3, 2, 3),
        (4, 2, 3),
        (5, 2, 4),
      ),
      (
        ((0, 0), (1, 0)),
        ((1, 0), (2, 0)),
        ((2, 0), (3, 0)),
        ((3, 0), (4, 0)),
        ((4, 0), (5, 0)),
        ((0, 0), (1, 1)),
        ((1, 1), (2, 1)),
        ((2, 1), (3, 1)),
        ((3, 1), (4, 1)),
        ((4, 1), (5, 1)),
        ((1, 1), (2, 2)),
        ((2, 1), (3, 2)),
        ((3, 1), (4, 2)),
        ((4, 1), (5, 2)),
      ),
    )

    draw-word-panel(
      (1.2, 1.5),
      [第1レベル：単語 B],
      $B$,
      ($b_1$, $b_2$),
      costs-b,
      (
        (0, 0, 2),
        (1, 0, 2),
        (2, 0, 2),
        (3, 0, 3),
        (4, 0, 3),
        (5, 0, 4),
        (1, 1, 3),
        (2, 1, 3),
        (3, 1, 2),
        (4, 1, 3),
        (5, 1, 3),
      ),
      (
        ((0, 0), (1, 0)),
        ((1, 0), (2, 0)),
        ((2, 0), (3, 0)),
        ((3, 0), (4, 0)),
        ((4, 0), (5, 0)),
        ((0, 0), (1, 1)),
        ((1, 0), (2, 1)),
        ((2, 0), (3, 1)),
        ((3, 1), (4, 1)),
        ((4, 1), (5, 1)),
      ),
    )
  }),
  caption: [レベルビルディング法：第1レベルの DP],
)

// ------------------------------------------------------------
// 第2レベル：第1レベルの結果から 2 単語目を接続する
// ------------------------------------------------------------

#let base-level-1 = (
  (0, "", ""),
  (1, "B", "3"),
  (2, "A", "2"),
  (3, "B", "2"),
  (4, "A/B", "3"),
  (5, "B", "3"),
)

#figure(
  cetz.canvas(length: 8mm, {
    import cetz.draw: *

    draw-word-panel(
      (1.2, 6.5),
      [第2レベル：単語 A を接続],
      $A$,
      ($a_1$, $a_2$, $a_3$),
      costs-a,
      (
        (2, 0, 5),
        (3, 0, 5),
        (4, 0, 4),
        (5, 0, 6),
        (3, 1, 6),
        (4, 1, 5),
        (5, 1, 5),
        (4, 2, 8),
        (5, 2, 8),
      ),
      (
        ((1, -1), (2, 0)),
        ((2, -1), (3, 0)),
        ((3, -1), (4, 0)),
        ((4, -1), (5, 0)),
        ((2, 0), (3, 1)),
        ((3, 0), (4, 1)),
        ((4, 0), (5, 1)),
        ((3, 1), (4, 2)),
        ((4, 1), (5, 2)),
      ),
      base: base-level-1,
    )

    draw-word-panel(
      (1.2, 1.5),
      [第2レベル：単語 B を接続],
      $B$,
      ($b_1$, $b_2$),
      costs-b,
      (
        (2, 0, 3),
        (3, 0, 3),
        (4, 0, 2),
        (5, 0, 3),
        (3, 1, 3),
        (4, 1, 4),
        (5, 1, 2),
      ),
      (
        ((1, -1), (2, 0)),
        ((2, -1), (3, 0)),
        ((3, -1), (4, 0)),
        ((4, 0), (5, 0)),
        ((2, 0), (3, 1)),
        ((3, 1), (4, 1)),
        ((4, 0), (5, 1)),
      ),
      base: base-level-1,
    )
  }),
  caption: [レベルビルディング法：第2レベルの DP],
)

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    content((2, 2), text(size: 13pt)[$b$])
    content((3, 2), text(size: 13pt)[$c$])
    content((4, 2), text(size: 13pt)[$b$])
    content((5, 2), text(size: 13pt)[$c$])

    content((1, 0), text(size: 13pt)[$a$])
    content((2, 0), text(size: 13pt)[$b$])
    content((3, 0), text(size: 13pt)[$b$])
    content((4, 0), text(size: 13pt)[$c$])
    content((5, 0), text(size: 13pt)[$b$])
    content((6, 0), text(size: 13pt)[$c$])

    line((2, 2 - 0.3), (1 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))
    line((2, 2 - 0.3), (2 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))
    line((2, 2 - 0.3), (3 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))

    line((3, 2 - 0.3), (4 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))

    line((4, 2 - 0.3), (5 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))

    line((5, 2 - 0.3), (6 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))
  }),
)

よって、

- 単語列：$"BB"$
- 累積距離：$2$
- 正規化累積距離：$2 / 6 = 1 / 3$

+ ワンパス DP 法

#let dx = 1.45
#let dy = 1.15
#let rad = 0.28

#let draw-onepass-panel(
  origin,
  title,
  word-name,
  rowlabels,
  costs,
  cums,
  arrows,
  base,
) = {
  import cetz.draw: *

  let ox = origin.at(0)
  let oy = origin.at(1)
  let rows = rowlabels.len()

  let axis-y = oy - dy - 0.45
  let xlabels-y = axis-y - 0.42
  let top-y = oy + (rows - 1) * dy + 0.55

  // タイトル
  content(
    (ox + 2.6 * dx, top-y + 0.55),
    text(size: 10pt)[#title],
  )

  // 軸
  line((ox - 0.45, axis-y), (ox + 5 * dx + 0.45, axis-y), stroke: 0.8pt)
  line((ox - 0.45, axis-y), (ox - 0.45, top-y), stroke: 0.8pt)

  content((ox + 5 * dx + 0.70, axis-y), text(size: 13pt)[$X$])
  content((ox - 0.40, top-y + 0.23), text(size: 13pt)[#word-name])

  // x ラベル
  let xlabels = ($x_1$, $x_2$, $x_3$, $x_4$, $x_5$, $x_6$)
  for c in range(6) {
    content((ox + c * dx, xlabels-y), text(size: 10pt)[#xlabels.at(c)])
  }

  // 行ラベル
  for r in range(rows) {
    content((ox - 0.95, oy + r * dy), text(size: 11pt)[#rowlabels.at(r)])
  }

  // 破線
  draw-dashed-line(ox - 0.35, oy - dy / 2, ox + 5 * dx + 0.35)

  // 下段（ワンパスの単語終端スコア）
  // base item = (col, label, value)
  for item in base {
    let c = item.at(0)
    let lab = item.at(1)
    let val = item.at(2)
    let q = p(origin, c, -1)

    circle(q, radius: rad, fill: white, stroke: 0.7pt)

    if lab != "" {
      content((q.at(0) - 0.48, q.at(1)), text(size: 10pt)[#lab])
    }

    if val != "" {
      content(q, text(size: 10pt)[#val])
    }
  }

  // 局所距離ノード
  for r in range(rows) {
    for c in range(6) {
      let q = p(origin, c, r)
      circle(q, radius: rad, fill: white, stroke: 0.7pt)
      content(q, text(size: 10pt)[#costs.at(r).at(c)])
    }
  }

  // 矢印
  let vadd(a, b) = a.zip(b, exact: true).map(((x, y)) => x + y)

  // 矢印
  for edge in arrows {
    if (edge.at(0).at(1) == edge.at(1).at(1)) {
      draw-arrow(origin, vadd(edge.at(0), (0.2, 0)), vadd(edge.at(1), (-0.2, 0)))
    } else {
      draw-arrow(origin, vadd(edge.at(0), (0.2, 0.2)), vadd(edge.at(1), (-0.15, -0.15)))
    }
  }

  // 累積距離
  // cums item = (col, row, value)
  for item in cums {
    let c = item.at(0)
    let r = item.at(1)
    let val = item.at(2)
    let q = p(origin, c, r)

    content(
      (q.at(0) + 0.30, q.at(1) + 0.34),
      text(size: 9pt)[#val],
    )
  }
}

// ------------------------------------------------------------
// 入力 X = a b b c b c
// A = a b a
// B = b c
// ------------------------------------------------------------

#let costs-a = (
  (0, 2, 2, 3, 2, 3), // a₁
  (2, 0, 0, 1, 0, 1), // a₂
  (0, 2, 2, 3, 2, 3), // a₃
)

#let costs-b = (
  (2, 0, 0, 1, 0, 1), // b₁
  (3, 1, 1, 0, 1, 0), // b₂
)

// 下段のワンパス終端スコア
// x1: 完結単語なし
// x2: B で 3
// x3: A で 2
// x4: B で 2
// x5: A/B で 3（同値）
// x6: B で 2
#let base-row = (
  (0, "", ""),
  (1, "B", "3"),
  (2, "A", "2"),
  (3, "B", "2"),
  (4, "A/B", "3"),
  (5, "B", "2"),
)

#figure(
  cetz.canvas(length: 8mm, {
    import cetz.draw: *

    // --------------------------------------------------------
    // 上: 単語 A
    // --------------------------------------------------------
    draw-onepass-panel(
      (1.2, 6.6),
      [ワンパスDP法：単語 A],
      $A$,
      ($a_1$, $a_2$, $a_3$),
      costs-a,
      (
        (0, 0, "0"),
        (1, 0, "2"),
        (2, 0, "4"),
        (3, 0, "5"),
        (4, 0, "4"),
        (5, 0, "6"),
        (1, 1, "0"),
        (2, 1, "0"),
        (3, 1, "1"),
        (4, 1, "1"),
        (5, 1, "2"),
        (2, 2, "2"),
        (3, 2, "3"),
        (4, 2, "3"),
        (5, 2, "4"),
      ),
      (
        // a1
        ((0, 0), (1, 0)),
        ((1, 0), (2, 0)),
        ((2, -1), (3, 0)),
        ((3, -1), (4, 0)),
        ((4, -1), (5, 0)),
        // a2
        ((0, 0), (1, 1)),
        ((1, 1), (2, 1)),
        ((2, 1), (3, 1)),
        ((3, 1), (4, 1)),
        ((4, 1), (5, 1)),
        // a3
        ((1, 1), (2, 2)),
        ((2, 1), (3, 2)),
        ((3, 1), (4, 2)),
        ((4, 1), (5, 2)),
      ),
      base-row,
    )

    // --------------------------------------------------------
    // 下: 単語 B
    // --------------------------------------------------------
    draw-onepass-panel(
      (1.2, 1.4),
      [ワンパスDP法：単語 B],
      $B$,
      ($b_1$, $b_2$),
      costs-b,
      (
        (0, 0, "2"),
        (1, 0, "2"),
        (2, 0, "2"),
        (3, 0, "3"),
        (4, 0, "2"),
        (5, 0, "3"),
        (1, 1, "3"),
        (2, 1, "3"),
        (3, 1, "2"),
        (4, 1, "3"),
        (5, 1, "2"),
      ),
      (
        // b1
        ((0, 0), (1, 0)),
        ((1, 0), (2, 0)),
        ((2, -1), (3, 0)),
        ((3, -1), (4, 0)),
        ((4, 0), (5, 0)),
        // b2
        ((0, 0), (1, 1)),
        ((1, 0), (2, 1)),
        ((2, 0), (3, 1)),
        ((3, 1), (4, 1)),
        ((4, 0), (5, 1)),
      ),
      base-row,
    )
  }),
  caption: [ワンパスDP法の図],
)

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    content((2, 2), text(size: 13pt)[$b$])
    content((3, 2), text(size: 13pt)[$c$])
    content((4, 2), text(size: 13pt)[$b$])
    content((5, 2), text(size: 13pt)[$c$])

    content((1, 0), text(size: 13pt)[$a$])
    content((2, 0), text(size: 13pt)[$b$])
    content((3, 0), text(size: 13pt)[$b$])
    content((4, 0), text(size: 13pt)[$c$])
    content((5, 0), text(size: 13pt)[$b$])
    content((6, 0), text(size: 13pt)[$c$])

    line((2, 2 - 0.3), (1 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))
    line((2, 2 - 0.3), (2 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))
    line((2, 2 - 0.3), (3 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))

    line((3, 2 - 0.3), (4 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))

    line((4, 2 - 0.3), (5 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))

    line((5, 2 - 0.3), (6 - 0.2, 0 + 0.2), stroke: 0.8pt, mark: (end: "stealth", fill: black))
  }),
)

よって、

- 単語列：$"BB"$
- 累積距離：$2$
- 正規化累積距離：$2 / 6 = 1 / 3$
