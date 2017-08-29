defmodule Events.SocialTest do
  use Events.DataCase

  alias Events.Social

  describe "events" do
    alias Events.Social.Event

    @valid_attrs %{date: ~N[2010-04-17 14:00:00.000000], description: "some description", duration: 42, title: "some title"}
    @update_attrs %{date: ~N[2011-05-18 15:01:01.000000], description: "some updated description", duration: 43, title: "some updated title"}
    @invalid_attrs %{date: nil, description: nil, duration: nil, title: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Social.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Social.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Social.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Social.create_event(@valid_attrs)
      assert event.date == ~N[2010-04-17 14:00:00.000000]
      assert event.description == "some description"
      assert event.duration == 42
      assert event.title == "some title"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = Social.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.date == ~N[2011-05-18 15:01:01.000000]
      assert event.description == "some updated description"
      assert event.duration == 43
      assert event.title == "some updated title"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_event(event, @invalid_attrs)
      assert event == Social.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Social.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Social.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Social.change_event(event)
    end
  end
end
