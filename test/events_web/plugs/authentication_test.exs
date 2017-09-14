defmodule EventsWeb.Plug.Authentication do
    use EventsWeb.ConnCase
    import Plug.Conn

    alias Events.Accounts

  @create_attrs %{email: "someemail@outlook.com", password: "some password"}

  describe "user accesses to an authenticated page" do
    test "user struct is added when it has session", %{conn: conn} do
      conn = create_session(conn)
      conn = get conn, event_path(conn, :index)

      assert html_response(conn, 200) =~ "Listing Events"
      user = conn.assigns[:user]
      assert user.email == "someemail@outlook.com"
    end
    test "is redirected to login page when it doesn't have session", %{conn: conn} do
      conn = get conn, event_path(conn, :index)

      assert redirected_to(conn) == user_path(conn, :login)
      assert conn.halted
    end
  end

  defp create_session(conn) do
      {:ok, user} = Accounts.create_user(@create_attrs)
      conn = conn
        |> bypass_through(EventsWeb.Router, :browser)
        |> get("/")
        |> put_session(:user_id, user.id)
        |> send_resp(:ok, "")
        |> recycle()
      conn
    end
  end
