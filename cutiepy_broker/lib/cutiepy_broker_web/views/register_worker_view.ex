defmodule CutiepyBrokerWeb.RegisterWorkerView do
  use CutiepyBrokerWeb, :view

  def render("ok.json", %{event: event}) do
    event
  end
end
