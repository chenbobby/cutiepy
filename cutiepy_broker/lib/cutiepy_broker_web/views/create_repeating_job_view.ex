defmodule CutiepyBrokerWeb.CreateRepeatingJobView do
  use CutiepyBrokerWeb, :view

  def render("ok.json", %{repeating_job_id: repeating_job_id}) do
    %{repeating_job_id: repeating_job_id}
  end
end
