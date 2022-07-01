defmodule CutiepyBrokerWeb.FailJobRunView do
  use CutiepyBrokerWeb, :view

  def render("ok.json", %{event: event}) do
    event
  end

  def render("conflict.json", %{error: :job_run_timed_out}) do
    %{error: "JOB_RUN_TIMED_OUT"}
  end
end
