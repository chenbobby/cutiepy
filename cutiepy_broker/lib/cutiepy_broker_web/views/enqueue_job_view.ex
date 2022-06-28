defmodule CutiepyBrokerWeb.EnqueueJobView do
  use CutiepyBrokerWeb, :view

  def render("response.json", %{event: %{"job_id" => job_id}}) do
    %{"job_id" => job_id}
  end
end
