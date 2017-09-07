defmodule EventsWeb.EventView do
  use EventsWeb, :view
  alias Events.Social.Event
  alias Events.Social

  def count_participants(event = %Event{}) do
      Social.get_participants_count(event.id)
  end
end
