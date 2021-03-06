defmodule EventsWeb.UserControllerTest do
  use EventsWeb.ConnCase
  import Plug.Conn

  alias Events.Accounts

  @create_attrs %{email: "someemail@outlook.com", password: "some password"}
  @invalid_attrs %{email: "not_valid_email", password: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get conn, user_path(conn, :new)
      assert html_response(conn, 200) =~ "Create account"
    end
  end

  describe "create user" do
    test "redirects to index when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs

      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Create account"
    end
  end


  describe "login" do
    test "renders form", %{conn: conn} do
      conn = get conn, user_path(conn, :login)
      assert html_response(conn, 200) =~ "Login"
    end
    test "creates session when data is valid", %{conn: conn} do
      create_user(@create_attrs)
      conn = post conn, user_path(conn, :session), user: @create_attrs
      assert redirected_to(conn) == page_path(conn, :index)
    end
    test "creates session when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :session), user: @create_attrs
      assert html_response(conn, 200) =~ "Username or password invalid"
    end
  end

  describe "logout" do
    test "drops session", %{conn: conn} do
      conn = create_session(conn)
      conn = delete conn, user_path(conn, :logout)
      assert redirected_to(conn) == user_path(conn, :login)
      assert get_session(conn, :user_id) == nil
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
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
