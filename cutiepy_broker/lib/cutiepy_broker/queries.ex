defmodule CutiepyBroker.Queries do
  @moduledoc false
  import Ecto.Query

  def jobs do
    CutiepyBroker.Repo.all(
      from job in CutiepyBroker.Job,
        order_by: [desc: job.updated_at],
        select: job
    )
  end
end
