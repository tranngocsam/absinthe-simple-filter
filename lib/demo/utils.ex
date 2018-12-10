defmodule Demo.Utils do
  def full_messages(errors) do
    for {key, {message, _}} <- errors do
      "#{key} #{message}"
    end
  end

  def upload_file(uploader, %Plug.Upload{} = file) do
    uploader.store(file)
  end

  @spec upload_file(any, String.t) :: tuple
  def upload_file(uploader, url) do
    uri = URI.parse(url)

    if uri.scheme == "http" || uri.scheme == "https" do
      uploader.store(url)
    else
      {:error, "Invalid url: #{url}"}
    end
  end

  def uploaded_file_urls(uploader, filename, model) do
    if filename do
      uploader.urls({filename, model})
    else
      %{}
    end
  end
end