defmodule DemoWeb.SessionView do
  use DemoWeb, :view

  def render("info.json", %{info: token}) do
    %{access_token: token}
  end
end
