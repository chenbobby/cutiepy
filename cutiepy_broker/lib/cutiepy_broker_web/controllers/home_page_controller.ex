defmodule CutiepyBrokerWeb.HomePageController do
  use CutiepyBrokerWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: Routes.live_path(conn, CutiepyBrokerWeb.JobIndex))
  end
end
