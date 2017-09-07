defmodule Events.Social do
  @moduledoc """
  The Social context.
  """

  import Ecto.Query, warn: false
  alias Events.Repo

  alias Events.Social.Event
  alias Events.Social.Comment

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

    @doc """
    Gets an event with its comments.

    Raises `Ecto.NoResultsError` if the Event does not exist.

    ## Examples

        iex> get_event_with_comments!(1)
        [%Events.Social.Event{__meta__: #Ecto.Schema.Metadata<:loaded, "events">,
          comments: [], date: ~N[2017-08-01 00:00:00.000000],
          description: "Birras en la birreria", duration: 120, id: 1,
          inserted_at: ~N[2017-08-29 13:06:54.000000], title: "Peña",
          updated_at: ~N[2017-08-29 13:06:54.000000]}]

  """
  def get_event_with_comments!(id), do: Repo.all(from(e in Event, where: e.id == ^id, preload: :comments))

    @doc """
    Inserts a comment in an event.

    Raises `Ecto.NoResultsError` if the Event does not exist.

    ## Examples

        iex> get_event!(123)
        %Event{}

        iex> get_event!(456)
        ** (Ecto.NoResultsError)

    """

  def insert_comment!(event, body) do
    comment = Ecto.Changeset.change(%Comment{}, body: body)
    post_with_comments = Ecto.Changeset.put_assoc(event, :comments, [comment])
    Repo.insert!(post_with_comments)
  end

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Adds a comment to an event.
  """
  def create_comment(event, body) do
    # Build a comment from the event struct
    comment = Ecto.build_assoc(event, :comments, body: body)

    Repo.insert(comment)
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end


  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end
end
