defmodule DemoWeb.Authentication do
  use Phauxth.Authenticate.Token

  @impl true
  def set_user(user, conn) do
    Absinthe.Plug.put_options(conn, context: %{current_user: user})
  end
end