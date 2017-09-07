defmodule EventsWeb.EventController do
  use EventsWeb, :controller

  alias Events.Social
  alias Events.Social.Event
  alias Events.Social.User
  alias Events.Repo

  def index(conn, _params) do
    events = Social.list_events()
    IO.inspect events
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = Social.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    case Social.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: event_path(conn, :show, event))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Social.get_event!(id)
    render(conn, "show.html", event: event)

  end

  def edit(conn, %{"id" => id}) do
    event = Social.get_event!(id)
    changeset = Social.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Social.get_event!(id)

    case Social.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: event_path(conn, :show, event))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Social.get_event!(id)
    {:ok, _event} = Social.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: event_path(conn, :index))
  end

  def add_participant(conn, %{"id" => event_id} ) do

    event  = Repo.get(Event, event_id) |> Repo.preload(:participants)
    user_id = 1
    user = Repo.get(User, user_id)
    case Social.update_participants_list(event, user) do
      {ok, _} ->
        conn
        |> put_flash(:info, "You have been joined to event")
        |> redirect(to: event_path(conn, :index))
      {error, _reason} ->
        conn
        |> put_flash(:info, "There was an error on adding participant")
        |> redirect(to: event_path(conn, :index))
    end

  end

end
