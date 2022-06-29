defmodule CutiepyBroker.JobRunTimer do
  @moduledoc false
  use GenServer

  @impl true
  def init(_init_arg) do
    :ok = Phoenix.PubSub.subscribe(CutiepyBroker.PubSub, "assigned_job_run")
    :ok = Phoenix.PubSub.subscribe(CutiepyBroker.PubSub, "completed_job_run")
    :ok = Phoenix.PubSub.subscribe(CutiepyBroker.PubSub, "failed_job_run")
    {:ok, nil}
  end

  @impl true
  def handle_info(%{event_type: "assigned_job_run", job_run_id: job_run_id}, nil) do
    Task.Supervisor.start_child(CutiepyBroker.TaskSupervisor, fn ->
      {:ok, _pid} = Registry.register(CutiepyBroker.Registry, job_run_id, nil)
      Process.sleep(500)
      {:ok, _event} = CutiepyBroker.Commands.time_out_job_run(%{job_run_id: job_run_id})
    end)

    {:noreply, nil}
  end

  @impl true
  def handle_info(%{event_type: "completed_job_run", job_run_id: job_run_id}, nil) do
    [{timer_task_pid, nil}] = Registry.lookup(CutiepyBroker.Registry, job_run_id)
    :ok = Task.Supervisor.terminate_child(CutiepyBroker.TaskSupervisor, timer_task_pid)
    {:noreply, nil}
  end

  @impl true
  def handle_info(%{event_type: "failed_job_run", job_run_id: job_run_id}, nil) do
    [{timer_task_pid, nil}] = Registry.lookup(CutiepyBroker.Registry, job_run_id)
    :ok = Task.Supervisor.terminate_child(CutiepyBroker.TaskSupervisor, timer_task_pid)
    {:noreply, nil}
  end

  def start_link(init_arg) do
    GenServer.start_link(CutiepyBroker.JobRunTimer, init_arg)
  end
end
