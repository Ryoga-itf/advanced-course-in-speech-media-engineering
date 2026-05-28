#import "../template.typ": *
#import "@preview/tenv:0.1.2": parse_dotenv
#import "@preview/physica:0.9.2": *
#import "@preview/cetz:0.5.0"

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: "第5回 レポート課題",
  authors: (
    (name: env.STUDENT_NAME, email: "学籍番号：" + env.STUDENT_ID, affiliation: "所属：情報科学類"),
  ),
  date: "2026 年 5 月 28 日",
)

#set footnote(numbering: sym.dagger + "1")

#set math.mat(delim: "[", gap: 0.5em)

== ①

以下の (a) と (b) のWFSTを合成しなさい（最適化は不要）

#figure(
  image("fig01.jpg"),
)

=== 解答

#set math.frac(style: "horizontal")

#figure(
  cetz.canvas(length: 1.5cm, {
    import cetz.draw: *

    let r = 0.5

    let q00 = (0, 0)
    let q01 = (2.0, 0)
    let q02 = (4.0, 0)
    let q03 = (6.7, 0)
    let q04 = (4.0, -1.9)
    let q05 = (6.7, -1.9)

    // 矢印つき遷移
    let arrow(a, b) = line(a, b, mark: (end: ">", fill: black), stroke: 0.8pt)

    // 状態
    let state(p, label, start: false, final: false) = {
      circle(p, radius: r, fill: white, stroke: if start { 1.6pt } else { 0.8pt })
      if final {
        circle(p, radius: r + 0.10, fill: none, stroke: 0.8pt)
      }
      content(p, label)
    }

    // 遷移
    arrow((0.45, 0), (1.55, 0))
    content((1.0, 0.55), align(center, text(size: 7pt)[
      しろ：$S / 0.2$ \
      あお：$S / 0.2$ \
      あか：$S / 0.2$
    ]))

    arrow((2.45, 0), (3.55, 0))
    content((3.0, 0.43), align(center, text(size: 7pt)[
      を：$epsilon / 0.2$ \
      に：$epsilon / 0.2$
    ]))

    arrow((4.45, 0), (6.15, 0))
    content((5.30, 0.32), text(size: 7pt)[しろ：$epsilon / 0.4$])

    arrow((4.0, -0.45), (4.0, -1.45))
    content((3.20, -0.95), align(center, text(size: 7pt)[
      しろ：$epsilon / 0.2$ \
      あお：$epsilon / 0.2$ \
      あか：$epsilon / 0.2$
    ]))

    arrow((4.45, -1.9), (6.15, -1.9))
    content((5.30, -1.55), align(center, text(size: 7pt)[
      を：$epsilon / 0.2$ \
      に：$epsilon / 0.2$
    ]))

    arrow((6.7, -1.45), (6.7, -0.55))
    content((7.35, -0.95), text(size: 7pt)[しろ：$epsilon / 0.4$])

    // 状態をあとから描いて、弧の端を隠す
    state(q00, text(size: 8pt)[$(0,0) / 0.5$], start: true)
    state(q01, text(size: 8pt)[$(0,1) / 0.5$])
    state(q02, text(size: 8pt)[$(0,2) / 0.5$])
    state(q03, text(size: 7pt)[$(0,3) / 1.0$], final: true)
    state(q04, text(size: 8pt)[$(0,4) / 0.5$])
    state(q05, text(size: 8pt)[$(0,5) / 0.5$])
  }),
)
