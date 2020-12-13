defmodule ZehChallengeWeb.PageController do
  use ZehChallengeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
