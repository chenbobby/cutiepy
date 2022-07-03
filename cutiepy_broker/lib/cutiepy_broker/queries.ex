defmodule CutiepyBroker.Queries do
  @moduledoc false
  import Ecto.Query

  def deferred_jobs do
    CutiepyBroker.Repo.all(
      from deferred_job in CutiepyBroker.DeferredJob,
        order_by: [desc: deferred_job.updated_at],
        limit: 20,
        select: deferred_job
    )
  end

  def deferred_jobs(%{
        enqueued_at: nil,
        enqueue_after_upper_bound: enqueue_after_upper_bound
      }) do
    CutiepyBroker.Repo.all(
      from deferred_job in CutiepyBroker.DeferredJob,
        where: is_nil(deferred_job.enqueued_at),
        where: deferred_job.enqueue_after < ^enqueue_after_upper_bound,
        order_by: deferred_job.enqueue_after,
        select: deferred_job
    )
  end

  def events do
    CutiepyBroker.Repo.all(
      from event in CutiepyBroker.Event,
        order_by: [desc: event.timestamp],
        limit: 20,
        select: event
    )
  end

  def events(%{job_id: job_id}) do
    CutiepyBroker.Repo.all(
      from event in CutiepyBroker.Event,
        where: event.data["job_id"] == ^job_id,
        order_by: [desc: event.timestamp],
        limit: 20,
        select: event
    )
  end

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

  def job_run(%{job_run_id: job_run_id}) do
    CutiepyBroker.Repo.one(
      from job_run in CutiepyBroker.JobRun,
        where: job_run.id == ^job_run_id,
        select: job_run
    )
  end

  def job_runs(%{job_id: job_id}) do
    CutiepyBroker.Repo.all(
      from job_run in CutiepyBroker.JobRun,
        where: job_run.job_id == ^job_id,
        order_by: [desc: job_run.updated_at],
        select: job_run
    )
  end

  def repeating_jobs do
    CutiepyBroker.Repo.all(
      from repeating_job in CutiepyBroker.RepeatingJob,
        order_by: [desc: repeating_job.updated_at],
        limit: 20,
        select: repeating_job
    )
  end

  def repeating_jobs(%{
        enqueue_next_job_after_upper_bound: enqueue_next_job_after_upper_bound
      }) do
    CutiepyBroker.Repo.all(
      from repeating_job in CutiepyBroker.RepeatingJob,
        where: repeating_job.enqueue_next_job_after < ^enqueue_next_job_after_upper_bound,
        order_by: repeating_job.enqueue_next_job_after,
        select: repeating_job
    )
  end

  def workers do
    CutiepyBroker.Repo.all(
      from worker in CutiepyBroker.Worker,
        limit: 20,
        order_by: [desc: worker.updated_at],
        select: worker
    )
  end
end
