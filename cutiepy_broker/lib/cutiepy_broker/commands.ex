defmodule CutiepyBroker.Commands do
  @moduledoc false
  import Ecto.Query

  def assign_job_run(%{worker_id: _} = params) do
    params
    |> dispatch_assign_job_run()
    |> handle_command_result()
  end

  def cancel_job(%{job_id: _} = params) do
    params
    |> dispatch_cancel_job()
    |> handle_command_result()
  end

  def cancel_job_run(%{job_run_id: _} = params) do
    params
    |> dispatch_cancel_job_run()
    |> handle_command_result()
  end

  def complete_job_run(
        %{
          job_run_id: _,
          job_run_result_serialized: _,
          job_run_result_repr: _,
          worker_id: _
        } = params
      ) do
    params
    |> dispatch_complete_job_run()
    |> handle_command_result()
  end

  def create_repeating_job(
        %{
          start_after: _,
          interval_ms: _,
          function_key: _,
          args_serialized: _,
          kwargs_serialized: _,
          args_repr: _,
          kwargs_repr: _,
          job_timeout_ms: _,
          job_run_timeout_ms: _
        } = params
      ) do
    params
    |> dispatch_create_repeating_job()
    |> handle_command_result()
  end

  def enqueue_job(
        %{
          job_function_key: _,
          job_args_serialized: _,
          job_kwargs_serialized: _,
          job_args_repr: _,
          job_kwargs_repr: _,
          job_timeout_ms: _,
          job_run_timeout_ms: _
        } = params
      ) do
    params
    |> dispatch_enqueue_job()
    |> handle_command_result()
  end

  def enqueue_deferred_job(%{deferred_job_id: _} = params) do
    params
    |> dispatch_enqueue_deferred_job()
    |> handle_command_result()
  end

  def enqueue_repeating_job(%{repeating_job_id: _} = params) do
    params
    |> dispatch_enqueue_repeating_job()
    |> handle_command_result()
  end

  def fail_job_run(
        %{
          job_run_id: _,
          job_run_exception_serialized: _,
          job_run_exception_repr: _,
          worker_id: _
        } = params
      ) do
    params
    |> dispatch_fail_job_run()
    |> handle_command_result()
  end

  def register_worker(%{} = params) do
    params
    |> dispatch_register_worker()
    |> handle_command_result()
  end

  def create_deferred_job(
        %{
          enqueue_after: _,
          function_key: _,
          args_serialized: _,
          kwargs_serialized: _,
          args_repr: _,
          kwargs_repr: _,
          job_timeout_ms: _,
          job_run_timeout_ms: _
        } = params
      ) do
    params
    |> dispatch_create_deferred_job()
    |> handle_command_result()
  end

  def time_out_job(%{job_id: _} = params) do
    params
    |> dispatch_time_out_job()
    |> handle_command_result()
  end

  def time_out_job_run(%{job_run_id: _} = params) do
    params
    |> dispatch_time_out_job_run()
    |> handle_command_result()
  end

  defp dispatch_assign_job_run(%{worker_id: worker_id}) do
    CutiepyBroker.Repo.transaction(fn ->
      worker =
        CutiepyBroker.Repo.one(
          from worker in CutiepyBroker.Worker,
            where: worker.id == ^worker_id,
            select: worker
        )

      if is_nil(worker) do
        CutiepyBroker.Repo.rollback(:worker_not_found)
      end

      job =
        CutiepyBroker.Repo.one(
          from job in CutiepyBroker.Job,
            where: job.status == "READY",
            select: job,
            limit: 1
        )

      case job do
        nil ->
          []

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
            event_id: Ecto.UUID.generate(),
            event_timestamp: now,
            event_type: "assigned_job_run",
            job_run_id: job_run.id,
            job_id: job.id,
            worker_id: worker_id
          }

          CutiepyBroker.Repo.update!(job_changeset)
          CutiepyBroker.Repo.insert!(job_run)
          CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

          [event]
      end
    end)
  end

  defp dispatch_cancel_job(%{job_id: job_id}) do
    CutiepyBroker.Repo.transaction(fn ->
      job =
        CutiepyBroker.Repo.one!(
          from job in CutiepyBroker.Job,
            where: job.id == ^job_id,
            select: job
        )

      case job.status do
        status when status in ["READY", "IN_PROGRESS"] ->
          now = DateTime.utc_now()

          job_changeset =
            Ecto.Changeset.change(
              job,
              updated_at: now,
              canceled_at: now,
              status: "CANCELED"
            )

          event = %{
            event_id: Ecto.UUID.generate(),
            event_timestamp: now,
            event_type: "canceled_job",
            job_id: job_id
          }

          CutiepyBroker.Repo.update!(job_changeset)
          CutiepyBroker.Repo.insert!(event)

          job_run =
            CutiepyBroker.Repo.one!(
              from job_run in CutiepyBroker.JobRun,
                where: job_run.job_id == ^job_id,
                select: job_run
            )

          events =
            case job_run.status do
              "IN_PROGRESS" ->
                {:ok, events} = dispatch_cancel_job_run(%{job_run_id: job_run.id})
                events

              _job_run_status ->
                []
            end

          [event | events]

        "SUCCESS" ->
          CutiepyBroker.Repo.rollback(:job_completed)

        "FAILED" ->
          CutiepyBroker.Repo.rollback(:job_completed)

        "CANCELED" ->
          CutiepyBroker.Repo.rollback(:job_canceled)

        "TIMED_OUT" ->
          CutiepyBroker.Repo.rollback(:job_timed_out)
      end
    end)
  end

  defp dispatch_cancel_job_run(%{job_run_id: job_run_id}) do
    CutiepyBroker.Repo.transaction(fn ->
      job_run =
        CutiepyBroker.Repo.one!(
          from job_run in CutiepyBroker.JobRun,
            where: job_run.id == ^job_run_id,
            select: job_run
        )

      case job_run.status do
        "IN_PROGRESS" ->
          now = DateTime.utc_now()

          job_run_changeset =
            Ecto.Changeset.change(
              job_run,
              updated_at: now,
              canceled_at: now,
              status: "CANCELED"
            )

          event = %{
            event_id: Ecto.UUID.generate(),
            event_timestamp: now,
            event_type: "canceled_job_run",
            job_run_id: job_run_id
          }

          CutiepyBroker.Repo.update!(job_run_changeset)
          CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

          job =
            CutiepyBroker.Repo.one!(
              from job in CutiepyBroker.Job,
                where: job.id == ^job_run.job_id,
                select: job
            )

          events =
            case job.status do
              "IN_PROGRESS" ->
                {:ok, events} = dispatch_cancel_job(%{job_id: job.id})
                events

              _job_status ->
                []
            end

          [event | events]

        "SUCCESS" ->
          CutiepyBroker.Repo.rollback(:job_run_completed)

        "FAILED" ->
          CutiepyBroker.Repo.rollback(:job_run_completed)

        "CANCELED" ->
          CutiepyBroker.Repo.rollback(:job_run_canceled)

        "TIMED_OUT" ->
          CutiepyBroker.Repo.rollback(:job_run_timed_out)
      end
    end)
  end

  defp dispatch_complete_job(%{job_id: job_id}) do
    CutiepyBroker.Repo.transaction(fn ->
      job =
        CutiepyBroker.Repo.one!(
          from job in CutiepyBroker.Job,
            where: job.id == ^job_id,
            select: job
        )

      case job.status do
        "IN_PROGRESS" ->
          now = DateTime.utc_now()

          job_changeset =
            Ecto.Changeset.change(
              job,
              updated_at: now,
              completed_at: now,
              status: "SUCCESS"
            )

          event = %{
            event_id: Ecto.UUID.generate(),
            event_timestamp: now,
            event_type: "completed_job",
            job_id: job.id
          }

          CutiepyBroker.Repo.update!(job_changeset)
          CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

          [event]

        "READY" ->
          CutiepyBroker.Repo.rollback(:job_in_queue)

        "SUCCESS" ->
          CutiepyBroker.Repo.rollback(:job_completed)

        "FAILED" ->
          CutiepyBroker.Repo.rollback(:job_completed)

        "CANCELED" ->
          CutiepyBroker.Repo.rollback(:job_canceled)

        "TIMED_OUT" ->
          CutiepyBroker.Repo.rollback(:job_timed_out)
      end
    end)
  end

  defp dispatch_complete_job_run(%{
         job_run_id: job_run_id,
         job_run_result_serialized: job_run_result_serialized,
         job_run_result_repr: job_run_result_repr,
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
              status: "SUCCESS",
              result_serialized: job_run_result_serialized,
              result_repr: job_run_result_repr
            )

          event = %{
            event_id: Ecto.UUID.generate(),
            event_timestamp: now,
            event_type: "completed_job_run",
            job_run_id: job_run_id
          }

          CutiepyBroker.Repo.update!(job_run_changeset)
          CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

          {:ok, events} = dispatch_complete_job(%{job_id: job.id})

          [event | events]

        "SUCCESS" ->
          CutiepyBroker.Repo.rollback(:job_run_completed)

        "FAILED" ->
          CutiepyBroker.Repo.rollback(:job_run_completed)

        "CANCELED" ->
          CutiepyBroker.Repo.rollback(:job_run_canceled)

        "TIMED_OUT" ->
          CutiepyBroker.Repo.rollback(:job_run_timed_out)
      end
    end)
  end

  defp dispatch_create_deferred_job(%{
         enqueue_after: enqueue_after,
         function_key: function_key,
         args_serialized: args_serialized,
         kwargs_serialized: kwargs_serialized,
         args_repr: args_repr,
         kwargs_repr: kwargs_repr,
         job_timeout_ms: job_timeout_ms,
         job_run_timeout_ms: job_run_timeout_ms
       }) do
    CutiepyBroker.Repo.transaction(fn ->
      now = DateTime.utc_now()

      deferred_job = %CutiepyBroker.DeferredJob{
        id: Ecto.UUID.generate(),
        updated_at: now,
        created_at: now,
        enqueue_after: enqueue_after,
        function_key: function_key,
        args_serialized: args_serialized,
        kwargs_serialized: kwargs_serialized,
        args_repr: args_repr,
        kwargs_repr: kwargs_repr,
        job_timeout_ms: job_timeout_ms,
        job_run_timeout_ms: job_run_timeout_ms
      }

      event = %{
        event_id: Ecto.UUID.generate(),
        event_timestamp: now,
        event_type: "created_deferred_job",
        deferred_job_id: deferred_job.id
      }

      CutiepyBroker.Repo.insert!(deferred_job)
      CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

      [event]
    end)
  end

  defp dispatch_create_repeating_job(%{
         start_after: start_after,
         interval_ms: interval_ms,
         function_key: function_key,
         args_serialized: args_serialized,
         kwargs_serialized: kwargs_serialized,
         args_repr: args_repr,
         kwargs_repr: kwargs_repr,
         job_timeout_ms: job_timeout_ms,
         job_run_timeout_ms: job_run_timeout_ms
       }) do
    CutiepyBroker.Repo.transaction(fn ->
      now = DateTime.utc_now()

      repeating_job = %CutiepyBroker.RepeatingJob{
        id: Ecto.UUID.generate(),
        updated_at: now,
        created_at: now,
        start_after: start_after,
        enqueue_next_job_after: start_after,
        interval_ms: interval_ms,
        function_key: function_key,
        args_serialized: args_serialized,
        kwargs_serialized: kwargs_serialized,
        args_repr: args_repr,
        kwargs_repr: kwargs_repr,
        job_timeout_ms: job_timeout_ms,
        job_run_timeout_ms: job_run_timeout_ms
      }

      event = %{
        event_id: Ecto.UUID.generate(),
        event_timestamp: now,
        event_type: "created_repeating_job",
        repeating_job_id: repeating_job.id
      }

      CutiepyBroker.Repo.insert!(repeating_job)
      CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

      [event]
    end)
  end

  defp dispatch_enqueue_deferred_job(%{deferred_job_id: deferred_job_id}) do
    CutiepyBroker.Repo.transaction(fn ->
      deferred_job =
        CutiepyBroker.Repo.one!(
          from deferred_job in CutiepyBroker.DeferredJob,
            where: deferred_job.id == ^deferred_job_id,
            select: deferred_job
        )

      {:ok, [enqueued_job_event | _] = events} =
        dispatch_enqueue_job(%{
          job_function_key: deferred_job.function_key,
          job_args_serialized: deferred_job.args_serialized,
          job_kwargs_serialized: deferred_job.kwargs_serialized,
          job_args_repr: deferred_job.args_repr,
          job_kwargs_repr: deferred_job.kwargs_repr,
          job_timeout_ms: deferred_job.job_timeout_ms,
          job_run_timeout_ms: deferred_job.job_run_timeout_ms
        })

      job =
        CutiepyBroker.Repo.one!(
          from job in CutiepyBroker.Job,
            where: job.id == ^enqueued_job_event.job_id,
            select: job
        )

      now = DateTime.utc_now()

      job_changeset =
        Ecto.Changeset.change(
          job,
          updated_at: now,
          deferred_job_id: deferred_job.id
        )

      deferred_job_changeset =
        Ecto.Changeset.change(
          deferred_job,
          updated_at: now,
          enqueued_at: now
        )

      event = %{
        event_id: Ecto.UUID.generate(),
        event_timestamp: now,
        event_type: "enqueued_deferred_job",
        deferred_job_id: deferred_job.id,
        job_id: job.id
      }

      CutiepyBroker.Repo.update!(job_changeset)
      CutiepyBroker.Repo.update!(deferred_job_changeset)
      CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

      events ++ [event]
    end)
  end

  defp dispatch_enqueue_job(%{
         job_function_key: job_function_key,
         job_args_serialized: job_args_serialized,
         job_kwargs_serialized: job_kwargs_serialized,
         job_args_repr: job_args_repr,
         job_kwargs_repr: job_kwargs_repr,
         job_timeout_ms: job_timeout_ms,
         job_run_timeout_ms: job_run_timeout_ms
       }) do
    CutiepyBroker.Repo.transaction(fn ->
      now = DateTime.utc_now()

      job = %CutiepyBroker.Job{
        id: Ecto.UUID.generate(),
        updated_at: now,
        enqueued_at: now,
        function_key: job_function_key,
        args_serialized: job_args_serialized,
        kwargs_serialized: job_kwargs_serialized,
        args_repr: job_args_repr,
        kwargs_repr: job_kwargs_repr,
        job_timeout_ms: job_timeout_ms,
        job_run_timeout_ms: job_run_timeout_ms,
        status: "READY"
      }

      event = %{
        event_id: Ecto.UUID.generate(),
        event_timestamp: now,
        event_type: "enqueued_job",
        job_id: job.id
      }

      CutiepyBroker.Repo.insert!(job)
      CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

      [event]
    end)
  end

  defp dispatch_enqueue_repeating_job(%{repeating_job_id: repeating_job_id}) do
    CutiepyBroker.Repo.transaction(fn ->
      repeating_job =
        CutiepyBroker.Repo.one!(
          from repeating_job in CutiepyBroker.RepeatingJob,
            where: repeating_job.id == ^repeating_job_id,
            select: repeating_job
        )

      now = DateTime.utc_now()

      {:ok, events} =
        dispatch_enqueue_job(%{
          job_function_key: repeating_job.function_key,
          job_args_serialized: repeating_job.args_serialized,
          job_kwargs_serialized: repeating_job.kwargs_serialized,
          job_args_repr: repeating_job.args_repr,
          job_kwargs_repr: repeating_job.kwargs_repr,
          job_timeout_ms: repeating_job.job_timeout_ms,
          job_run_timeout_ms: repeating_job.job_run_timeout_ms
        })

      repeating_job_changeset =
        Ecto.Changeset.change(
          repeating_job,
          updated_at: now,
          enqueue_next_job_after:
            DateTime.add(
              repeating_job.enqueue_next_job_after,
              repeating_job.interval_ms,
              :millisecond
            )
        )

      event = %{
        event_id: Ecto.UUID.generate(),
        event_timestamp: now,
        event_type: "enqueued_repeating_job",
        repeating_job_id: repeating_job.id
      }

      CutiepyBroker.Repo.update!(repeating_job_changeset)
      CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

      events ++ [event]
    end)
  end

  defp dispatch_fail_job(%{job_id: job_id}) do
    CutiepyBroker.Repo.transaction(fn ->
      job =
        CutiepyBroker.Repo.one!(
          from job in CutiepyBroker.Job,
            where: job.id == ^job_id,
            select: job
        )

      case job.status do
        "IN_PROGRESS" ->
          now = DateTime.utc_now()

          job_changeset =
            Ecto.Changeset.change(
              job,
              updated_at: now,
              failed_at: now,
              status: "FAILED"
            )

          event = %{
            event_id: Ecto.UUID.generate(),
            event_timestamp: now,
            event_type: "failed_job",
            job_id: job.id
          }

          CutiepyBroker.Repo.update!(job_changeset)
          CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

          [event]

        "READY" ->
          CutiepyBroker.Repo.rollback(:job_in_queue)

        "SUCCESS" ->
          CutiepyBroker.Repo.rollback(:job_completed)

        "FAILED" ->
          CutiepyBroker.Repo.rollback(:job_completed)

        "CANCELED" ->
          CutiepyBroker.Repo.rollback(:job_canceled)

        "TIMED_OUT" ->
          CutiepyBroker.Repo.rollback(:job_timed_out)
      end
    end)
  end

  defp dispatch_fail_job_run(%{
         job_run_id: job_run_id,
         job_run_exception_serialized: job_run_exception_serialized,
         job_run_exception_repr: job_run_exception_repr,
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
              failed_at: now,
              status: "FAILED",
              exception_serialized: job_run_exception_serialized,
              exception_repr: job_run_exception_repr
            )

          event = %{
            event_id: Ecto.UUID.generate(),
            event_timestamp: now,
            event_type: "failed_job_run",
            job_run_id: job_run_id
          }

          CutiepyBroker.Repo.update!(job_run_changeset)
          CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

          {:ok, events} = dispatch_fail_job(%{job_id: job.id})

          [event | events]

        "SUCCESS" ->
          CutiepyBroker.Repo.rollback(:job_run_completed)

        "FAILED" ->
          CutiepyBroker.Repo.rollback(:job_run_completed)

        "CANCELED" ->
          CutiepyBroker.Repo.rollback(:job_run_canceled)

        "TIMED_OUT" ->
          CutiepyBroker.Repo.rollback(:job_run_timed_out)
      end
    end)
  end

  defp dispatch_register_worker(%{}) do
    CutiepyBroker.Repo.transaction(fn ->
      now = DateTime.utc_now()

      worker = %CutiepyBroker.Worker{
        id: Ecto.UUID.generate(),
        updated_at: now
      }

      event = %{
        event_id: Ecto.UUID.generate(),
        event_timestamp: now,
        event_type: "registered_worker",
        worker_id: worker.id
      }

      CutiepyBroker.Repo.insert!(worker)
      CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

      [event]
    end)
  end

  defp dispatch_time_out_job(%{job_id: job_id}) do
    CutiepyBroker.Repo.transaction(fn ->
      job =
        CutiepyBroker.Repo.one!(
          from job in CutiepyBroker.Job,
            where: job.id == ^job_id,
            select: job
        )

      case job.status do
        status when status in ["READY", "IN_PROGRESS"] ->
          now = DateTime.utc_now()

          job_changeset =
            Ecto.Changeset.change(
              job,
              updated_at: now,
              timed_out_at: now,
              status: "TIMED_OUT"
            )

          event = %{
            event_id: Ecto.UUID.generate(),
            event_timestamp: now,
            event_type: "timed_out_job",
            job_id: job_id
          }

          CutiepyBroker.Repo.update!(job_changeset)
          CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

          job_run =
            CutiepyBroker.Repo.one(
              from job_run in CutiepyBroker.JobRun,
                where: job_run.job_id == ^job_id,
                select: job_run
            )

          events =
            case job_run do
              nil ->
                []

              job_run ->
                case job_run.status do
                  "IN_PROGRESS" ->
                    {:ok, events} = dispatch_cancel_job_run(%{job_run_id: job_run.id})
                    events

                  _job_run_status ->
                    []
                end
            end

          [event | events]

        "SUCCESS" ->
          CutiepyBroker.Repo.rollback(:job_completed)

        "FAILED" ->
          CutiepyBroker.Repo.rollback(:job_completed)

        "CANCELED" ->
          CutiepyBroker.Repo.rollback(:job_canceled)

        "TIMED_OUT" ->
          CutiepyBroker.Repo.rollback(:job_timed_out)
      end
    end)
  end

  defp dispatch_time_out_job_run(%{job_run_id: job_run_id}) do
    CutiepyBroker.Repo.transaction(fn ->
      job_run =
        CutiepyBroker.Repo.one!(
          from job_run in CutiepyBroker.JobRun,
            where: job_run.id == ^job_run_id,
            select: job_run
        )

      case job_run.status do
        "IN_PROGRESS" ->
          now = DateTime.utc_now()

          job_run_changeset =
            Ecto.Changeset.change(
              job_run,
              updated_at: now,
              timed_out_at: now,
              status: "TIMED_OUT"
            )

          event = %{
            event_id: Ecto.UUID.generate(),
            event_timestamp: now,
            event_type: "timed_out_job_run",
            job_run_id: job_run_id
          }

          CutiepyBroker.Repo.update!(job_run_changeset)
          CutiepyBroker.Repo.insert!(CutiepyBroker.Event.from_map(event))

          {:ok, events} = dispatch_time_out_job(%{job_id: job_run.job_id})

          [event | events]

        "SUCCESS" ->
          CutiepyBroker.Repo.rollback(:job_run_completed)

        "FAILED" ->
          CutiepyBroker.Repo.rollback(:job_run_completed)

        "CANCELED" ->
          CutiepyBroker.Repo.rollback(:job_run_canceled)

        "TIMED_OUT" ->
          CutiepyBroker.Repo.rollback(:job_run_timed_out)
      end
    end)
  end

  defp handle_command_result({:ok, []}) do
    {:ok, []}
  end

  defp handle_command_result({:ok, events}) when is_list(events) do
    Enum.each(events, fn %{event_type: event_type} = event ->
      :ok = Phoenix.PubSub.broadcast!(CutiepyBroker.PubSub, event_type, event)
    end)

    {:ok, events}
  end

  defp handle_command_result({:error, error}) do
    {:error, error}
  end
end
