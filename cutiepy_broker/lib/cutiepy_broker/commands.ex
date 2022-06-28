defmodule CutiepyBroker.Commands do
  @moduledoc false
  import Ecto.Query

  def enqueue_job(%{
        "job_callable_key" => callable_key,
        "job_args_serialized" => args_serialized,
        "job_kwargs_serialized" => kwargs_serialized
      }) do
    CutiepyBroker.Repo.transaction(fn ->
      now = DateTime.utc_now()

      job = %CutiepyBroker.Job{
        id: Ecto.UUID.generate(),
        updated_at: now,
        enqueued_at: now,
        callable_key: callable_key,
        args_serialized: args_serialized,
        kwargs_serialized: kwargs_serialized,
        status: "READY"
      }

      event = %CutiepyBroker.Event{
        id: Ecto.UUID.generate(),
        data: %{
          event_type: "enqueued_job",
          enqueued_job_at: now,
          job_id: job.id
        }
      }

      CutiepyBroker.Repo.insert!(job)
      CutiepyBroker.Repo.insert!(event)

      CutiepyBroker.Event.string_map(event)
    end)
    |> case do
      {:ok, event} -> {:ok, event}
    end
  end

  def assign_job_run(%{"worker_id" => worker_id}) do
    CutiepyBroker.Repo.transaction(fn ->
      CutiepyBroker.Repo.one(
        from job in CutiepyBroker.Job,
          where: job.status == "READY",
          select: job,
          limit: 1
      )
      |> case do
        nil ->
          nil

        job ->
          now = DateTime.utc_now()

          job_run = %CutiepyBroker.JobRun{
            id: Ecto.UUID.generate(),
            updated_at: now,
            assigned_at: now,
            job_id: job.id,
            worker_id: worker_id
          }

          job_changeset = Ecto.Changeset.change(job, status: "IN_PROGRESS")

          event = %CutiepyBroker.Event{
            id: Ecto.UUID.generate(),
            data: %{
              event_type: "assigned_job_run",
              assigned_job_run_at: now,
              job_run_id: job_run.id,
              job_id: job.id,
              job_callable_key: job.callable_key,
              job_args_serialized: job.args_serialized,
              job_kwargs_serialized: job.kwargs_serialized,
              worker_id: worker_id
            }
          }

          CutiepyBroker.Repo.update!(job_changeset)
          CutiepyBroker.Repo.insert!(job_run)
          CutiepyBroker.Repo.insert!(event)

          CutiepyBroker.Event.string_map(event)
      end
    end)
    |> case do
      {:ok, nil} -> {:ok, nil}
      {:ok, event} -> {:ok, event}
    end
  end

  def complete_job_run(%{
        "job_run_id" => job_run_id,
        "job_run_result_serialized" => result_serialized,
        "worker_id" => worker_id
      }) do
    CutiepyBroker.Repo.transaction(fn ->
      job_run =
        CutiepyBroker.Repo.one!(
          from job_run in CutiepyBroker.JobRun,
            where: job_run.id == ^job_run_id,
            where: job_run.worker_id == ^worker_id,
            select: job_run
        )

      job =
        CutiepyBroker.Repo.one!(
          from job in CutiepyBroker.Job,
            where: job.id == ^job_run.job_id,
            select: job
        )

      now = DateTime.utc_now()

      job_run_changeset =
        Ecto.Changeset.change(
          job_run,
          updated_at: now,
          completed_at: now
        )

      job_changeset =
        Ecto.Changeset.change(
          job,
          updated_at: now,
          status: "DONE",
          result_serialized: result_serialized
        )

      event = %CutiepyBroker.Event{
        id: Ecto.UUID.generate(),
        data: %{
          event_type: "completed_job_run",
          completed_job_run_at: now,
          job_run_id: job_run_id
        }
      }

      CutiepyBroker.Repo.update!(job_run_changeset)
      CutiepyBroker.Repo.update!(job_changeset)
      CutiepyBroker.Repo.insert!(event)

      CutiepyBroker.Event.string_map(event)
    end)
    |> case do
      {:ok, event} -> {:ok, event}
    end
  end
end
