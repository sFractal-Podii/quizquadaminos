defmodule QuadBlockQuiz.Repo do
  use Ecto.Repo,
    otp_app: :QuadBlockQuiz,
    adapter: Ecto.Adapters.Postgres
end
