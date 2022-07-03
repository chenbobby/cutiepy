defmodule CutiepyBrokerWeb.CreateScheduledJobView do
  use CutiepyBrokerWeb, :view

  def render("ok.json", %{scheduled_job_id: scheduled_job_id}) do
    %{scheduled_job_id: scheduled_job_id}
  end
end
