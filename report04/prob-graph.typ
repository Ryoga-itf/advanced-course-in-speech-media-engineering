#import "@preview/cetz:0.3.4"

#let N(label, right: none, down: none) = (
  label: label,
  to: (right, down),
)

#let draw-prob-graph(
  data,
  length: 1cm,
  bw: 1.65,
  bh: 0.75,
  col-gap: 3.0,
  row-gap: 2.2,
  value-size: 10pt,
  edge-size: 8pt,
  state-size: 12pt,
  head-size: 12pt,
  row-label-x: -1.25,
  header-gap: 0.85,
  stroke-style: black + 0.8pt,
  highlight-text-color: red,
  highlight-stroke-style: red + 1.4pt,
) = {
  assert.eq(data.heads.len(), data.nodes.len())

  let ncols = data.nodes.len()
  let nrows = data.states.len()

  for col in data.nodes {
    assert.eq(col.len(), nrows)
  }

  let highlight = data.at(
    "highlight",
    default: (nodes: (), edges: ()),
  )

  let highlight-nodes = highlight.at("nodes", default: ())
  let highlight-edges = highlight.at("edges", default: ())

  let is-highlight-node(c, r) = {
    highlight-nodes.contains((c, r))
  }

  let is-highlight-edge(c, r, dir) = {
    highlight-edges.contains((c, r, dir))
  }

  cetz.canvas(length: length, {
    import cetz.draw: *

    let x(c) = c * col-gap
    let y(r) = (nrows - 1 - r) * row-gap

    let header-y = y(0) + header-gap

    let node-at(c, r) = data.nodes.at(c).at(r)

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

    let draw-node(pos, body: none, highlight: false) = {
      let p = center(pos)
      let px = p.at(0)
      let py = p.at(1)

      rect(
        (px - bw / 2, py - bh / 2),
        (px + bw / 2, py + bh / 2),
        stroke: if highlight { highlight-stroke-style } else { stroke-style },
      )

      if body != none {
        content(
          p,
          text(size: value-size, body, fill: if highlight { highlight-text-color } else { black }),
        )
      }
    }

    let draw-link(
      from,
      to,
      body,
      side: 1,
      offset: 0.28,
      along: 0.5,
      from-dy: 0.0,
      to-dy: 0.0,
      highlight: false,
    ) = {
      let a = port(from, "right", dy: from-dy)
      let b = port(to, "left", dy: to-dy)

      line(
        a,
        b,
        stroke: if highlight { highlight-stroke-style } else { stroke-style },
        mark: (end: ">", fill: black),
      )

      content(
        label-point(a, b, side: side, offset: offset, along: along),
        text(size: edge-size, body),
      )
    }

    // row labels
    for r in range(nrows) {
      let label = data.states.at(r)

      if label != none {
        content(
          (row-label-x, y(r)),
          text(size: state-size, label),
        )
      }
    }

    // column labels
    for c in range(ncols) {
      let head = data.heads.at(c)

      if head != none {
        content(
          (x(c), header-y),
          text(size: head-size, head),
        )
      }
    }

    // links
    for c in range(ncols) {
      for r in range(nrows) {
        let node = node-at(c, r)

        let right = node.to.at(0)
        let down = node.to.at(1)

        if right != none and c + 1 < ncols {
          let side = if 2 * r < nrows { 1 } else { -1 }

          draw-link(
            (c, r),
            (c + 1, r),
            right,
            side: side,
            offset: 0.28,
            along: 0.5,
            highlight: is-highlight-edge(c, r, "right"),
          )
        }

        if down != none and c + 1 < ncols and r + 1 < nrows {
          draw-link(
            (c, r),
            (c + 1, r + 1),
            down,
            side: 1,
            offset: 0.22,
            along: 0.55,
            from-dy: -0.10,
            to-dy: 0.05,
            highlight: is-highlight-edge(c, r, "down"),
          )
        }
      }
    }

    // nodes
    for c in range(ncols) {
      for r in range(nrows) {
        let node = node-at(c, r)

        draw-node(
          (c, r),
          body: node.label,
          highlight: is-highlight-node(c, r),
        )
      }
    }
  })
}
