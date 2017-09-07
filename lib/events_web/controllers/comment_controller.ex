defmodule EventsWeb.CommentController do
  use EventsWeb, :controller

  alias Events.Social
  alias Events.Social.Comment

  def new(conn, _params) do
    changeset = Social.change_comment(%Comment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"comment" => comment, "id" => id}) do
    event = Social.get_event!(id)
    case Social.create_comment(event, comment["body"]) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: event_path(conn, :show, event))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
