defmodule CutiepyBroker.Commands do
  @moduledoc false
  import Ecto.Query

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
          nil

        job ->
          now = DateTime.utc_now()

          job_run = %CutiepyBroker.JobRun{
            id: Ecto.UUID.generate(),
            updated_at: now,
            assigned_at: now,
            status: "IN_PROGRESS",
            job_id: job.id,
            worker_id: worker_id
          }

          job_changeset = Ecto.Changeset.change(job, status: "IN_PROGRESS")

          event = %{
            id: Ecto.UUID.generate(),
            event_type: "assigned_job_run",
            assigned_job_run_at: now,
            job_run_id: job_run.id,
            job_id: job.id,
            job_callable_key: job.callable_key,
            job_args_serialized: job.args_serialized,
            job_kwargs_serialized: job.kwargs_serialized,
            worker_id: worker_id
          }

          CutiepyBroker.Repo.update!(job_changeset)
          CutiepyBroker.Repo.insert!(job_run)
          CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

          event
      end
    end)
    |> handle_command_transaction_result()
  end

  def complete_job_run(%{
        job_run_id: job_run_id,
        job_run_result_serialized: result_serialized,
        job_run_result_repr: result_repr,
        worker_id: worker_id
      }) do
    CutiepyBroker.Repo.transaction(fn ->
      job_run =
        CutiepyBroker.Repo.one!(
          from job_run in CutiepyBroker.JobRun,
            where: job_run.id == ^job_run_id,
            where: job_run.worker_id == ^worker_id,
            select: job_run
        )

      case job_run.status do
        "IN_PROGRESS" ->
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
              completed_at: now,
              status: "DONE"
            )

          job_changeset =
            Ecto.Changeset.change(
              job,
              updated_at: now,
              completed_at: now,
              status: "DONE",
              result_serialized: result_serialized,
              result_repr: result_repr
            )

          event = %{
            id: Ecto.UUID.generate(),
            event_type: "completed_job_run",
            completed_job_run_at: now,
            job_run_id: job_run_id
          }

          CutiepyBroker.Repo.update!(job_run_changeset)
          CutiepyBroker.Repo.update!(job_changeset)
          CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

          event

        "TIMED_OUT" ->
          CutiepyBroker.Repo.rollback(:job_run_timed_out)
      end
    end)
    |> handle_command_transaction_result()
  end

  def enqueue_job(%{
        job_callable_key: callable_key,
        job_args_serialized: args_serialized,
        job_kwargs_serialized: kwargs_serialized,
        job_args_repr: args_repr,
        job_kwargs_repr: kwargs_repr
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
        args_repr: args_repr,
        kwargs_repr: kwargs_repr,
        status: "READY"
      }

      event = %{
        id: Ecto.UUID.generate(),
        event_type: "enqueued_job",
        enqueued_job_at: now,
        job_id: job.id
      }

      CutiepyBroker.Repo.insert!(job)
      CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

      event
    end)
    |> handle_command_transaction_result()
  end

  def time_out_job_run(%{job_run_id: job_run_id}) do
    CutiepyBroker.Repo.transaction(fn ->
      job_run =
        CutiepyBroker.Repo.one!(
          from job_run in CutiepyBroker.JobRun,
            where: job_run.id == ^job_run_id,
            where: job_run.status == "IN_PROGRESS",
            select: job_run
        )

      job =
        CutiepyBroker.Repo.one!(
          from job in CutiepyBroker.Job,
            where: job.id == ^job_run.job_id,
            where: job.status == "IN_PROGRESS",
            select: job
        )

      now = DateTime.utc_now()

      job_run_changeset =
        Ecto.Changeset.change(
          job_run,
          updated_at: now,
          timed_out_at: now,
          status: "TIMED_OUT"
        )

      job_changeset =
        Ecto.Changeset.change(
          job,
          updated_at: now,
          timed_out_at: now,
          status: "TIMED_OUT"
        )

      event = %{
        id: Ecto.UUID.generate(),
        event_type: "timed_out_job_run",
        timed_out_job_run_at: now,
        job_run_id: job_run_id
      }

      CutiepyBroker.Repo.update!(job_run_changeset)
      CutiepyBroker.Repo.update!(job_changeset)
      CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

      event
    end)
    |> handle_command_transaction_result()
  end

  defp handle_command_transaction_result({:ok, %{event_type: event_type} = event}) do
    :ok = Phoenix.PubSub.broadcast!(CutiepyBroker.PubSub, event_type, event)
    {:ok, event}
  end

  defp handle_command_transaction_result({:ok, nil}) do
    {:ok, nil}
  end

  defp handle_command_transaction_result({:error, error}) do
    {:error, error}
  end
end
