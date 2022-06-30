defmodule CutiepyBroker.Queries do
  @moduledoc false
  import Ecto.Query

  def job(%{job_id: job_id}) do
    CutiepyBroker.Repo.one(
      from job in CutiepyBroker.Job,
        where: job.id == ^job_id,
        select: job
    )
  end

  def job(%{job_run_id: job_run_id}) do
    CutiepyBroker.Repo.one(
      from job in CutiepyBroker.Job,
        join: job_run in CutiepyBroker.JobRun,
        on: job_run.job_id == job.id,
        where: job_run.id == ^job_run_id,
        select: job
    )
  end

  def jobs do
    CutiepyBroker.Repo.all(
      from job in CutiepyBroker.Job,
        order_by: [desc: job.updated_at],
        limit: 20,
        select: job
    )
  end

  def job_runs(%{job_id: job_id}) do
    CutiepyBroker.Repo.all(
      from job_run in CutiepyBroker.JobRun,
        where: job_run.job_id == ^job_id,
        select: job_run
    )
  end
end
