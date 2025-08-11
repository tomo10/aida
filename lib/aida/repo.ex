defmodule Aida.Repo do
  use Ecto.Repo,
    otp_app: :aida,
    adapter: Ecto.Adapters.Postgres
end
