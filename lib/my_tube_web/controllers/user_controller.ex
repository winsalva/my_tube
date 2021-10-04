defmodule MyTubeWeb.UserController do
  use MyTubeWeb, :controller


  alias MyTube.Query.{User, Upload}


  @doc """
  Render new registration page.
  """
  def new(conn, _params) do
    changeset = User.new_user()
    render(conn, :new, changeset: changeset)
  end


  @doc """
  Create user.
  """
  def create(conn, %{"user" => %{"name" => name, "email" => email, "password" => password, "password_confirmation" => password_confirmation} = params}) do
  case User.insert_user(params) do
    {:ok, _user} ->
      conn
      |> put_flash(:info, "Congrats for registering your account! You can now log in using your email and password.")
      |> redirect(to: Routes.session_path(conn, :login))
    {:error, %Ecto.Changeset{} = changeset} ->
      conn
      |> render(:new, changeset: changeset)
    end
  end


  @doc """
  Show user.
  """
  def show(conn, %{"id" => id}) do
    user = User.get_user!(id)
    user_uploads = Upload.list_user_uploads(id)
    render(conn, :show, user: user, user_uploads: user_uploads)
  end


  @doc """
  Edit user
  """
  def edit(conn, %{"id" => id}) do
    user = User.edit_user(id)
    render(conn, :edit, user: user)
  end


  @doc """
  Update user.
  """
  def update(conn, %{"user" => params, "id" => id}) do
    case User.update_user(id, params) do
      {:ok, user} ->
        conn
	|> redirect(to: Routes.user_path(conn, :show, user.id))
      {:error, %Ecto.Changeset{} = user} ->
        conn
	|> render(:edit, user: user)
    end
  end
end