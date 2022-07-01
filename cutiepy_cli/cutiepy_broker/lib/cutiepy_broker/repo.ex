defmodule CutiepyBroker.Repo do
  use Ecto.Repo,
    otp_app: :cutiepy_broker,
    adapter: Ecto.Adapters.SQLite3
end
