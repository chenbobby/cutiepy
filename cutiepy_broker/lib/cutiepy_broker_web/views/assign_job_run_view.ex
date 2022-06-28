defmodule CutiepyBrokerWeb.AssignJobRunView do
  use CutiepyBrokerWeb, :view

  def render("response.json", %{event: nil}) do
    %{"job_run_id" => nil}
  end

  def render("response.json", %{
        event: %{
          "job_run_id" => job_run_id,
          "job_callable_key" => job_callable_key,
          "job_args_serialized" => job_args_serialized,
          "job_kwargs_serialized" => job_kwargs_serialized
        }
      }) do
    %{
      "job_run_id" => job_run_id,
      "job_callable_key" => job_callable_key,
      "job_args_serialized" => job_args_serialized,
      "job_kwargs_serialized" => job_kwargs_serialized
    }
  end
end
