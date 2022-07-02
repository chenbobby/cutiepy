defmodule CutiepyBroker.DeferredJobWatcher do
  @moduledoc false
  use GenServer

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  @impl true
  def init(_init_arg) do
    Process.send_after(self(), :tick, 100)
    {:ok, nil}
  end

  @impl true
  def handle_info(:tick, nil) do
    CutiepyBroker.Queries.deferred_jobs(%{
      job_id: nil,
      enqueue_after_upper_bound: DateTime.utc_now()
    })
    |> Enum.map(fn deferred_job ->
      :ok =
        GenServer.cast(
          CutiepyBroker.DeferredJobEnqueuer,
          {:enqueue_deferred_job, deferred_job.id}
        )
    end)

    Process.send_after(self(), :tick, 100)
    {:noreply, nil}
  end
end
