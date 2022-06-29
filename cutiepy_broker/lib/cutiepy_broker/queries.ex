defmodule CutiepyBroker.Queries do
  @moduledoc false
  import Ecto.Query

  def job(job_id) do
    CutiepyBroker.Repo.one(
      from job in CutiepyBroker.Job,
        where: job.id == ^job_id,
        select: job
    )
  end

  def jobs do
    CutiepyBroker.Repo.all(
      from job in CutiepyBroker.Job,
        order_by: [desc: job.updated_at],
        select: job
    )
  end

  def job_runs(job_id) do
    CutiepyBroker.Repo.all(
      from job_run in CutiepyBroker.JobRun,
        where: job_run.job_id == ^job_id,
        select: job_run
    )
  end
end
