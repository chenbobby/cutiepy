defmodule CutiepyBroker.ScheduledJobEnqueuer do
  @moduledoc false
  use GenServer

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, nil, init_arg)
  end

  @impl true
  def init(nil) do
    {:ok, nil}
  end

  @impl true
  def handle_cast({:enqueue_scheduled_job, scheduled_job_id}, nil) do
    {:ok, _events} =
      CutiepyBroker.Commands.enqueue_scheduled_job(%{scheduled_job_id: scheduled_job_id})

    {:noreply, nil}
  end
end
