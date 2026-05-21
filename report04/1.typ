#import "@preview/cetz:0.5.0"

== ①

入力パターン「aba」に対する確率をフォワードアルゴリズムとバックワードアルゴリズムにより求めよ

#figure(
  image("fig01.jpg", width: 80%),
)

=== 解答

#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  // -------------------------
  // data
  // -------------------------
  // 行 index:
  // 0 = q_1, 1 = q_2, 2 = q_3, ...

  let states = (
    [$q_1$],
    [$q_2$],
  )

  // 各列の値。
  // values の長さは states と同じにする。
  let columns = (
    (
      head: none,
      values: ([$1.0$], none),
    ),
    (
      head: [$a$],
      values: ([$0.35$], [$0.15$]),
    ),
    (
      head: [$a$],
      values: ([$0.1225$], [$0.0975$]),
    ),
    (
      head: [$b$],
      values: (none, [$0.111125$]),
    ),
  )

  let data = (
    states: ($q_1$, $q_2$),
    head: (none, $a$, $a$, $b$),
    nodes: (
      (
        (label: $1.0$, to: (((1, 0), $0.5 dot 0.7$),)),
        // ...
      ),
      (
        // ...
      ),
    ),
  )

  // 矢印。
  // from / to は (列, 行)。
  let L(
    from,
    to,
    body,
    side: 1,
    from-dy: 0.0,
    to-dy: 0.0,
    offset: 0.28,
    along: 0.5,
  ) = (
    from: from,
    to: to,
    body: body,
    side: side,
    from-dy: from-dy,
    to-dy: to-dy,
    offset: offset,
    along: along,
  )

  let links = (
    L((0, 0), (1, 0), [0.5・0.7]),
    L((0, 0), (1, 1), [0.5・0.3], from-dy: -0.10, to-dy: 0.05),
    L((1, 0), (2, 0), [0.5・0.7]),
    L((1, 0), (2, 1), [0.5・0.3], from-dy: -0.10, to-dy: 0.05),
    L((1, 1), (2, 1), [1.0・0.3], side: -1),
    L((2, 0), (3, 1), [0.5・0.7], from-dy: -0.02, to-dy: 0.03),
    L((2, 1), (3, 1), [1.0・0.7], side: -1),
  )

  // -------------------------
  // style
  // -------------------------

  let bw = 1.65
  let bh = 0.75

  let col-gap = 3.0
  let row-gap = 2.2

  let value-size = 10pt
  let label-size = 8pt
  let state-size = 12pt
  let head-size = 12pt

  let stroke-style = black + 0.8pt

  // -------------------------
  // layout
  // -------------------------

  let nrows = states.len()
  let ncols = columns.len()

  let x(c) = c * col-gap
  let y(r) = (nrows - 1 - r) * row-gap

  let header-y = y(0) + 0.85
  let row-label-x = -1.25

  let center(pos) = {
    let c = pos.at(0)
    let r = pos.at(1)
    (x(c), y(r))
  }

  let port(pos, side, dy: 0.0) = {
    let p = center(pos)
    let px = p.at(0)
    let py = p.at(1)

    if side == "left" {
      (px - bw / 2, py + dy)
    } else {
      (px + bw / 2, py + dy)
    }
  }

  let label-point(a, b, side: 1, offset: 0.28, along: 0.5) = {
    let ax = a.at(0)
    let ay = a.at(1)
    let bx = b.at(0)
    let by = b.at(1)

    let dx = bx - ax
    let dy = by - ay
    let len = calc.sqrt(dx * dx + dy * dy)

    if len == 0.0 {
      (ax, ay)
    } else {
      let nx = -dy / len
      let ny = dx / len

      (
        ax + dx * along + nx * offset * side,
        ay + dy * along + ny * offset * side,
      )
    }
  }

  // -------------------------
  // drawing helpers
  // -------------------------

  let draw-node(pos, body: none) = {
    let p = center(pos)
    let px = p.at(0)
    let py = p.at(1)

    rect(
      (px - bw / 2, py - bh / 2),
      (px + bw / 2, py + bh / 2),
      stroke: stroke-style,
    )

    if body != none {
      content(p, text(size: value-size, body))
    }
  }

  let draw-link(link) = {
    let a = port(link.from, "right", dy: link.from-dy)
    let b = port(link.to, "left", dy: link.to-dy)

    line(
      a,
      b,
      stroke: stroke-style,
      mark: (end: ">", fill: black),
    )

    content(
      label-point(
        a,
        b,
        side: link.side,
        offset: link.offset,
        along: link.along,
      ),
      text(size: label-size, link.body),
    )
  }

  // -------------------------
  // row labels
  // -------------------------

  for r in range(nrows) {
    content(
      (row-label-x, y(r)),
      text(size: state-size, states.at(r)),
    )
  }

  // -------------------------
  // columns and nodes
  // -------------------------

  for c in range(ncols) {
    let col = columns.at(c)

    if col.head != none {
      content(
        (x(c), header-y),
        text(size: head-size, col.head),
      )
    }

    for r in range(nrows) {
      draw-node(
        (c, r),
        body: col.values.at(r),
      )
    }
  }

  // -------------------------
  // links
  // -------------------------

  for link in links {
    draw-link(link)
  }
})
