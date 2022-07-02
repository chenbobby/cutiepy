defmodule CutiepyBroker.RepeatingJobWatcher do
  @moduledoc false
  use GenServer

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, nil, init_arg)
  end

  @impl true
  def init(nil) do
    Process.send_after(self(), :tick, 100)
    {:ok, nil}
  end

  @impl true
  def handle_info(:tick, nil) do
    CutiepyBroker.Queries.repeating_jobs(%{enqueue_next_job_after_upper_bound: DateTime.utc_now()})
    |> Enum.map(fn repeating_job ->
      :ok =
        GenServer.cast(
          CutiepyBroker.RepeatingJobEnqueuer,
          {:enqueue_repeating_job, repeating_job.id}
        )
    end)

    Process.send_after(self(), :tick, 100)
    {:noreply, nil}
  end
end
