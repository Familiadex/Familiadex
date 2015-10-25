# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Familiada.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

q1 = Familiada.Repo.insert!(%Familiada.Question{question: "Popularny owoc"})
Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q1.id, answer: "Jabłko", points: 60})
Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q1.id, answer: "Gruszka", points: 40})
