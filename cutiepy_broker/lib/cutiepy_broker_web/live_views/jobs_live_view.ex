defmodule CutiepyBrokerWeb.JobsLiveView do
  use CutiepyBrokerWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Jobs</h1>
    <%= case @jobs do %>
    <% [] -> %>
      <p>No jobs yet! See the documentation on how to create new jobs for CutiePy.</p>
    <% jobs -> %>
      <%= for job <- jobs do %>
      <p><%= job.id %> : <%= job.status %> : <%= job.result_serialized %></p>
      <% end %>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    jobs = CutiepyBroker.Queries.jobs()
    {:ok, assign(socket, :jobs, jobs)}
  end
end
