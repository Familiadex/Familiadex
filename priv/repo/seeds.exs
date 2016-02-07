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

File.stream!("priv/repo/data.csv") |> CSV.decode(separator: ?\t) |> Enum.each fn row ->
  [question,
      ans1, score1,
      ans2, score2,
      ans3, score3,
      ans4, score4,
      ans5, score5,
      ans6, score6] = row
  IO.puts ("question: |" <> question <> "|")
  IO.puts ("ans1: " <> ans1)
  IO.puts ("score1: " <> score1)
  IO.puts ("an6:" <> score6)
  IO.puts "#########"
  q = Familiada.Repo.insert!(%Familiada.Question{question: question})
  # Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q.id, answer: ans1, points: score1})
  # Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q.id, answer: ans2, points: score2})
  # Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q.id, answer: ans3, points: score3})
  # Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q.id, answer: ans4, points: score4})
  # Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q.id, answer: ans5, points: score5})
  # Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q.id, answer: ans6, points: score6})
end


# user = %Familiada.User{email: "test@user.com", crypted_password: Comeonin.Bcrypt.hashpwsalt("test")}
# Familiada.Repo.insert!(user)

# Musi być po co najmniej 6 odpowiedzi
# q2 = Familiada.Repo.insert!(%Familiada.Question{question: "Co kobieta ma w torebce?"})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q2.id, answer: "szminka", points: 25})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q2.id, answer: "portfel", points: 30})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q2.id, answer: "telefon", points: 15})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q2.id, answer: "klucze", points: 10})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q2.id, answer: "klucze", points: 10})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q2.id, answer: "buty", points: 5})
#
# q3 = Familiada.Repo.insert!(%Familiada.Question{question: "Co jemy na śniadanie"})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q3.id, answer: "kanapki", points: 25})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q3.id, answer: "płatki", points: 30})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q3.id, answer: "naleśniki", points: 15})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q3.id, answer: "naleśniki", points: 15})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q3.id, answer: "jajecznicę", points: 10})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q3.id, answer: "parówki", points: 5})
#
# q4 = Familiada.Repo.insert!(%Familiada.Question{question: "Co zakłada na siebie kobieta"})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q4.id, answer: "sukienkę", points: 40})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q4.id, answer: "spódnicę", points: 30})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q4.id, answer: "buty na obcasie", points: 15})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q4.id, answer: "Spodnie", points: 10})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q4.id, answer: "kapelusz", points: 5})
#
# q5 = Familiada.Repo.insert!(%Familiada.Question{question: "Wymień największe kraje świata"})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q5.id, answer: "Rosja", points: 40})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q5.id, answer: "Chiny", points: 30})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q5.id, answer: "Stany Zjednoczone", points: 15})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q5.id, answer: "Australia", points: 10})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q5.id, answer: "Polska", points: 5})
#
# q6 = Familiada.Repo.insert!(%Familiada.Question{question: "Wymień tradycyjne dania wigilijne"})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q6.id, answer: "karp", points: 40})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q6.id, answer: "bigos", points: 30})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q6.id, answer: "barszcz z uszkami", points: 15})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q6.id, answer: "kutia", points: 10})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q6.id, answer: "śledzie", points: 5})
#
# q7 = Familiada.Repo.insert!(%Familiada.Question{question: "Najczęściej używane języki świata"})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q7.id, answer: "angielski", points: 40})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q7.id, answer: "francuski", points: 30})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q7.id, answer: "hiszpański", points: 15})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q7.id, answer: "chiński", points: 10})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q7.id, answer: "niemiecki", points: 5})
#
# q8 = Familiada.Repo.insert!(%Familiada.Question{question: "Co znajduje się w domowym salonie?"})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q8.id, answer: "sofa", points: 40})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q8.id, answer: "telewizor", points: 30})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q8.id, answer: "stolik", points: 15})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q8.id, answer: "telefon", points: 10})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q8.id, answer: "komputer", points: 5})
#
# q9 = Familiada.Repo.insert!(%Familiada.Question{question: "Czego potrzeba do zrobienia kanapki"})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q9.id, answer: "chleb", points: 40})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q9.id, answer: "masło", points: 30})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q9.id, answer: "wędlina", points: 15})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q9.id, answer: "ser", points: 10})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q9.id, answer: "pomidor", points: 5})
#
# q10 = Familiada.Repo.insert!(%Familiada.Question{question: "Co oglądamy w telewizji"})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q10.id, answer: "seriale", points: 40})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q10.id, answer: "filmy", points: 30})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q10.id, answer: "wiadomości", points: 15})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q10.id, answer: "dokumenty", points: 10})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q10.id, answer: "reklamy", points: 5})
#
# q11 = Familiada.Repo.insert!(%Familiada.Question{question: "Co pijemy"})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q11.id, answer: "Kawę", points: 40})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q11.id, answer: "Herbatę", points: 30})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q11.id, answer: "Wódkę", points: 15})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q11.id, answer: "Wodę", points: 10})
# Familiada.Repo.insert!(%Familiada.PolledAnswer{question_id: q11.id, answer: "Sok", points: 5})
