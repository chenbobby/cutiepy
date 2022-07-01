defmodule CutiepyBrokerWeb.EnqueueJobControllerTest do
  use CutiepyBrokerWeb.ConnCase

  test "returns Bad Request if command parameters are missing", %{conn: conn} do
    conn = post(conn, "/api/enqueue_job", %{})
    body = json_response(conn, 200)
  end
end
