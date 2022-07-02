defmodule CutiepyBrokerWeb.ScheduleJobView do
  use CutiepyBrokerWeb, :view

  def render("ok.json", %{event: event}) do
    %{event: event}
  end
end
