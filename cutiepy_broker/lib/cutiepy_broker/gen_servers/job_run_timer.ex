defmodule CutiepyBroker.JobRunTimer do
  @moduledoc false
  use GenServer

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, nil, init_arg)
  end

  @impl true
  def init(nil) do
    :ok = Phoenix.PubSub.subscribe(CutiepyBroker.PubSub, "assigned_job_run")
    :ok = Phoenix.PubSub.subscribe(CutiepyBroker.PubSub, "canceled_job_run")
    :ok = Phoenix.PubSub.subscribe(CutiepyBroker.PubSub, "completed_job_run")
    :ok = Phoenix.PubSub.subscribe(CutiepyBroker.PubSub, "failed_job_run")
    job_run_id_to_timer_ref = %{}
    {:ok, job_run_id_to_timer_ref}
  end

  @impl true
  def handle_info(
        %{event_type: "assigned_job_run", job_run_id: job_run_id},
        job_run_id_to_timer_ref
      ) do
    job = CutiepyBroker.Queries.job(%{job_run_id: job_run_id})

    case job.job_run_timeout_ms do
      nil ->
        {:noreply, job_run_id_to_timer_ref}

      job_run_timeout_ms ->
        timer_ref = Process.send_after(self(), {:timeout_job_run, job_run_id}, job_run_timeout_ms)
        job_run_id_to_timer_ref = Map.put(job_run_id_to_timer_ref, job_run_id, timer_ref)
        {:noreply, job_run_id_to_timer_ref}
    end
  end

  @impl true
  def handle_info(
        %{event_type: "canceled_job_run", job_run_id: job_run_id},
        job_run_id_to_timer_ref
      ) do
    {:noreply, cancel_job_run_timer(job_run_id_to_timer_ref, job_run_id)}
  end

  @impl true
  def handle_info(
        %{event_type: "completed_job_run", job_run_id: job_run_id},
        job_run_id_to_timer_ref
      ) do
    {:noreply, cancel_job_run_timer(job_run_id_to_timer_ref, job_run_id)}
  end

  @impl true
  def handle_info(
        %{event_type: "failed_job_run", job_run_id: job_run_id},
        job_run_id_to_timer_ref
      ) do
    {:noreply, cancel_job_run_timer(job_run_id_to_timer_ref, job_run_id)}
  end

  @impl true
  def handle_info({:timeout_job_run, job_run_id}, job_run_id_to_timer_ref) do
    {:ok, _event} = CutiepyBroker.Commands.time_out_job_run(%{job_run_id: job_run_id})
    job_run_id_to_timer_ref = Map.delete(job_run_id_to_timer_ref, job_run_id)
    {:noreply, job_run_id_to_timer_ref}
  end

  defp cancel_job_run_timer(job_run_id_to_timer_ref, job_run_id) do
    case job_run_id_to_timer_ref[job_run_id] do
      nil ->
        job_run_id_to_timer_ref

      timer_ref ->
        Process.cancel_timer(timer_ref)
        Map.delete(job_run_id_to_timer_ref, job_run_id)
    end
  end
end
