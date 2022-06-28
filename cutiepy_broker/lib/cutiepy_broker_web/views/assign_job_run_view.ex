defmodule CutiepyBrokerWeb.AssignJobRunView do
  use CutiepyBrokerWeb, :view

  def render("assigned.json", %{job_run_id: job_run_id, job: job}) do
    %{
      job_run_id: job_run_id,
      callable_key: job.callable_key,
      args_serialized: job.args_serialized,
      kwargs_serialized: job.kwargs_serialized
    }
  end

  def render("no_jobs.json", _assigns) do
    %{job_run_id: nil}
  end
end
