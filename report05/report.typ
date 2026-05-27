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
