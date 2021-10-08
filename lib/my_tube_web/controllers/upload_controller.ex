defmodule MyTubeWeb.UploadController do
  use MyTubeWeb, :controller


  plug :authenticate when action not in [:show]

  alias MyTube.Query.{Upload, Comment}


  def new(conn, _params) do
    changeset = Upload.new_upload()
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"upload" => %{"title" => title, "file" => file, "description" => description} = params}) do
    params = Map.put(params, "user_id", conn.assigns.current_user.id)

    case Upload.insert_upload(params) do
      {:ok, _upload} ->
        conn
	|> redirect(to: "/")
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render(:new, changeset: changeset)
    end
  end

  @doc """
  Show an upload 
  """
  def show(conn, %{"id" => id}) do
    upload = Upload.get_upload!(id)
    comment = Comment.new_comment()
    render(conn, :show, upload: upload, comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    upload = Upload.edit_upload(id)
    render(conn, :edit, upload: upload)
  end

  def update(conn, %{"upload" => params, "id" => id}) do
    case Upload.update_upload(id, params) do
      {:ok, upload} ->
        conn
	|> redirect(to: Routes.upload_path(conn, :show, upload.id))
      {:error, %Ecto.Changeset{} = upload} ->
        conn
	|> render(:edit, upload: upload)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Upload.delete_upload(id) do
      {:ok, _upload} ->
        conn
	|> put_flash(:info, "Your video was deleted!")
	|> redirect(to: Routes.page_path(conn, :index))
      {:error, _} ->
        conn
	|> put_flash(:info, "Something went wrong.")
	|> redirect(to: Routes.page_path(conn, :index))
    end
  end


  ### authenticator.
  defp authenticate(conn, _params) do
    with user when not is_nil(user) <- conn.assigns.current_user do
      conn
    else
      nil ->
        conn |> redirect(to: "/") |> halt()
    end
  end
end