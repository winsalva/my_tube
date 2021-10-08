defmodule MyTube.Query.Upload do
  @moduledoc """
  Documentation for Upload Query.
  """


  alias MyTube.{Repo}
  alias MyTube.Schema.{Upload, Comment}
  import Ecto.Query
  

  @doc """
  List all uploads.
  """
  def list_uploads do
    query =
      from u in Upload,
        order_by: [desc: :updated_at],
	preload: [:user, :comments]

    Repo.all(query)
  end


  @doc """
  List user uploads
  """
  def list_user_uploads(user_id) do
    query =
      from u in Upload,
        where: u.user_id == ^user_id,
	order_by: [desc: :updated_at],
	preload: [:user, :comments]

    Repo.all(query)
  end
  

  @doc """
  New upload.
  """
  def new_upload do
    %Upload{}
    |> Upload.changeset()
  end


  @doc """
  Insert new upload.
  """
  def insert_upload(params) do
    %Upload{}
    |> Upload.changeset(params)
    |> Repo.insert()
  end


  @doc """
  Get upload by id.
  """
  def get_upload!(id) do
    comments =
      from c in Comment,
        order_by: [desc: :updated_at],
	preload: [:user]
	 
    query =
      from u in Upload,
        where: u.id == ^id,
	preload: [:user, comments: ^comments]

    Repo.one(query)
  end

  def edit_upload(id) do
    Repo.get(Upload, id)
    |> Upload.changeset
  end

  def update_upload(id, params) do
    Repo.get(Upload, id)
    |> Upload.changeset(params)
    |> Repo.update()
  end

  def delete_upload(id) do
    Repo.get(Upload, id)
    |> Repo.delete()
  end
end