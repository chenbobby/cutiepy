defmodule CutiepyBrokerWeb.CreateDeferredJobView do
  use CutiepyBrokerWeb, :view

  def render("ok.json", %{deferred_job_id: deferred_job_id}) do
    %{deferred_job_id: deferred_job_id}
  end
end
