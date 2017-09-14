defmodule EventsWeb.Plugs.Authentication do
  import Plug.Conn
  import Phoenix.Controller

  alias Events.Accounts
  alias EventsWeb.Router.Helpers

  def init(default), do: default

  def call(conn, _params) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> redirect(to: Helpers.user_path(conn, :login))
      user_id ->
        user = Accounts.get_user!(user_id)
        assign(conn, :user, user)
    end
  end


end
