defmodule CutiepyBrokerWeb.EnqueueJobView do
  use CutiepyBrokerWeb, :view

  def render("enqueued.json", %{job_id: job_id}) do
    %{job: %{job_id: job_id}}
  end
end
