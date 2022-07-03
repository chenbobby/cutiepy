defmodule CutiepyBrokerWeb.CreateRecurringJobView do
  use CutiepyBrokerWeb, :view

  def render("ok.json", %{recurring_job_id: recurring_job_id}) do
    %{recurring_job_id: recurring_job_id}
  end
end
