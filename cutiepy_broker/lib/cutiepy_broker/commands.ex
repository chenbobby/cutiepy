defmodule CutiepyBroker.Commands do
  @moduledoc false

  def enqueue_job(%{
        "function_serialized" => function_serialized,
        "args_serialized" => args_serialized,
        "kwargs_serialized" => kwargs_serialized
      }) do
    job_id = Ecto.UUID.generate()
    enqueued_job_at = DateTime.utc_now()

    event = %CutiepyBroker.Event{
      id: Ecto.UUID.generate(),
      data: %{
        event_type: "enqueued_job",
        job_id: job_id,
        enqueued_job_at: enqueued_job_at
      }
    }

    job = %CutiepyBroker.Job{
      id: job_id,
      updated_at: DateTime.utc_now(),
      enqueued_at: enqueued_job_at,
      function_serialized: function_serialized,
      args_serialized: args_serialized,
      kwargs_serialized: kwargs_serialized
    }

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:events, event)
    |> Ecto.Multi.insert(:jobs, job)
    |> CutiepyBroker.Repo.transaction()
    |> case do
      {:ok, _} -> {:ok, job_id}
      {:error, _failed_operation, _failed_value, _changes} -> :error
    end
  end
end
