defmodule CutiepyBroker.Commands do
  @moduledoc false
  import Ecto.Query

  def enqueue_job(%{
        "callable_key" => callable_key,
        "args_serialized" => args_serialized,
        "kwargs_serialized" => kwargs_serialized
      }) do
    job_id = Ecto.UUID.generate()
    enqueued_job_at = DateTime.utc_now()

    event = %CutiepyBroker.Event{
      id: Ecto.UUID.generate(),
      data: %{
        event_type: "enqueued_job",
        enqueued_job_at: enqueued_job_at,
        job_id: job_id
      }
    }

    job = %CutiepyBroker.Job{
      id: job_id,
      updated_at: enqueued_job_at,
      enqueued_at: enqueued_job_at,
      callable_key: callable_key,
      args_serialized: args_serialized,
      kwargs_serialized: kwargs_serialized,
      status: "READY"
    }

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:job, job)
    |> Ecto.Multi.insert(:event, event)
    |> CutiepyBroker.Repo.transaction()
    |> case do
      {:ok, _} -> {:ok, CutiepyBroker.Event.flatten(event)}
      {:error, _failed_operation, _failed_value, _changes} -> :error
    end
  end

  def assign_job_run(%{worker_id: worker_id}) do
    CutiepyBroker.Repo.transaction(fn ->
      CutiepyBroker.Repo.one(
        from job in CutiepyBroker.Job,
          where: job.status == "READY",
          select: job,
          limit: 1
      )
      |> case do
        nil ->
          {:ok, nil}

        job ->
          job_run_id = Ecto.UUID.generate()
          assigned_job_run_at = DateTime.utc_now()

          event = %CutiepyBroker.Event{
            id: Ecto.UUID.generate(),
            data: %{
              event_type: "assigned_job_run",
              assigned_job_run_at: assigned_job_run_at,
              job_run_id: job_run_id,
              job_id: job.id,
              worker_id: worker_id
            }
          }

          job_changeset = Ecto.Changeset.change(job, status: "IN_PROGRESS")

          job_run = %CutiepyBroker.JobRun{
            id: job_run_id,
            updated_at: assigned_job_run_at,
            assigned_at: assigned_job_run_at,
            job_id: job.id,
            worker_id: worker_id
          }

          CutiepyBroker.Repo.insert!(event)
          CutiepyBroker.Repo.update!(job_changeset)
          CutiepyBroker.Repo.insert!(job_run)

          {:ok, job_run_id, job}
      end
    end)
    |> case do
      {:ok, result} -> result
      {:error, _failed_operation, _failed_value, _changes} -> :error
    end
  end

  def complete_job_run(%{
        "job_run_id" => job_run_id,
        "worker_id" => worker_id,
        "result_serialized" => result_serialized
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

      completed_job_run_at = DateTime.utc_now()

      event = %CutiepyBroker.Event{
        id: Ecto.UUID.generate(),
        data: %{
          event_type: "completed_job_run",
          completed_job_run_at: completed_job_run_at,
          job_run_id: job_run_id
        }
      }

      job_run_changeset =
        Ecto.Changeset.change(
          job_run,
          updated_at: completed_job_run_at,
          completed_at: completed_job_run_at
        )

      job_changeset =
        Ecto.Changeset.change(
          job,
          updated_at: completed_job_run_at,
          status: "DONE",
          result_serialized: result_serialized
        )

      CutiepyBroker.Repo.insert!(event)
      CutiepyBroker.Repo.update!(job_run_changeset)
      CutiepyBroker.Repo.update!(job_changeset)
    end)
    |> case do
      {:ok, _} -> :ok
    end
  end
end
