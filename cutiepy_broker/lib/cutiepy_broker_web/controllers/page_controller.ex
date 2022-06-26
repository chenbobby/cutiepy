defmodule CutiepyBrokerWeb.PageController do
  use CutiepyBrokerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
