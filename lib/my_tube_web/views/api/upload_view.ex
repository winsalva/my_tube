defmodule MyTubeWeb.Api.UploadView do
  use MyTubeWeb, :view

  def render("index.json", %{uploads: uploads}) do
    %{data: Enum.map(uploads, fn upload -> %{title: upload.title, description: upload.description, file: url(upload.file)} end)}
  end
end