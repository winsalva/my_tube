defmodule MyTubeWeb.Api.UploadController do
  use MyTubeWeb, :controller

  alias MyTube.Query.Upload
  
  def index(conn, _params) do
    uploads = Upload.list_uploads
    render(conn, "index.json", uploads: uploads)
  end
end