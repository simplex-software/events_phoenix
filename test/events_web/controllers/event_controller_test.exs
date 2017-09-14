defmodule EventsWeb.EventControllerTest do
  use EventsWeb.ConnCase
  import Plug.Conn

  alias Events.Social
  alias Events.Accounts

  @create_attrs %{date: ~N[2010-04-17 14:00:00.000000], description: "some description", duration: 42, title: "some title"}
  @update_attrs %{date: ~N[2011-05-18 15:01:01.000000], description: "some updated description", duration: 43, title: "some updated title"}
  @invalid_attrs %{date: nil, description: nil, duration: nil, title: nil}

  @create_user_attrs %{email: "someemail@outlook.com", password: "some password"}

  def fixture(:event) do
    {:ok, event} = Social.create_event(@create_attrs)
    event
  end

  setup %{conn: conn} do
    {:ok, user} = Accounts.create_user(@create_user_attrs)
    conn = conn
      |> bypass_through(EventsWeb.Router, :browser)
      |> get("/")
      |> put_session(:user_id, user.id)
      |> send_resp(:ok, "")
      |> recycle()
    %{conn: conn}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get conn, event_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Events"
    end
  end

  describe "new event" do
    test "renders form", %{conn: conn} do
      conn = get conn, event_path(conn, :new)
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "create event" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == event_path(conn, :show, id)

      conn = get conn, event_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Event"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @invalid_attrs
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "edit event" do
    setup [:create_event]

    test "renders form for editing chosen event", %{conn: conn, event: event} do
      conn = get conn, event_path(conn, :edit, event)
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "update event" do
    setup [:create_event]

    test "redirects when data is valid", %{conn: conn, event: event} do
      conn = put conn, event_path(conn, :update, event), event: @update_attrs
      assert redirected_to(conn) == event_path(conn, :show, event)

      conn = get conn, event_path(conn, :show, event)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put conn, event_path(conn, :update, event), event: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete conn, event_path(conn, :delete, event)
      assert redirected_to(conn) == event_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, event_path(conn, :show, event)
      end
    end
  end

  defp create_event(_) do
    event = fixture(:event)
    {:ok, event: event}
  end
end
