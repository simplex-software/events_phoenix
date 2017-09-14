defmodule EventsWeb.UserController do
  use EventsWeb, :controller

  alias Events.Accounts
  alias Events.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
        case Accounts.create_user(user_params) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "User created successfully.")
            |> put_session(:user_id, user.id)
            |> redirect(to: page_path(conn, :index))
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
  end

  def login(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "login.html", changeset: changeset)
  end

  def session(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.get_user_by_email!(email) do
      nil ->
        reject_login(conn)
      %User{id: id} = db_user ->
        cond  do
          User.is_valid_password?(db_user ,password) ->
            conn
             |> put_flash(:info, "Login successfully")
             |> put_session(:user_id, id)
             |> redirect(to: page_path(conn, :index))
          true ->
            reject_login(conn)
          end
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
         |> put_flash(:error, "Ups, something went wrong, please try again")
         |> login(changeset: changeset)
    end
  end

  def logout(conn, _) do
    conn
    |> clear_session()
    |> configure_session(drop: true)
    |> put_flash(:info, "Logged out successfully")
    |> redirect(to: user_path(conn, :login))
  end

  defp reject_login(conn) do
    conn
     |> put_flash(:error, "Username or password invalid")
     |> login(nil)
  end
end
