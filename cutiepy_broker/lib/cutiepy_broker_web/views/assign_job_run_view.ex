defmodule CutiepyBrokerWeb.AssignJobRunView do
  use CutiepyBrokerWeb, :view

  def render("ok.json", %{
        job_run_id: job_run_id,
        job_function_key: job_function_key,
        job_args_serialized: job_args_serialized,
        job_kwargs_serialized: job_kwargs_serialized
      }) do
    %{
      job_run_id: job_run_id,
      job_function_key: job_function_key,
      job_args_serialized: job_args_serialized,
      job_kwargs_serialized: job_kwargs_serialized
    }
  end
end
