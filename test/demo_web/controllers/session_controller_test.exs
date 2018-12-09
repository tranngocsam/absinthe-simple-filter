defmodule DemoWeb.SessionControllerTest do
  use DemoWeb.ConnCase

  import DemoWeb.AuthCase

  @create_attrs %{email: "robin@example.com", password: "reallyHard2gue$$"}
  @invalid_attrs %{email: "robin@example.com", password: "cannotGue$$it"}

  setup %{conn: conn} do
    user = add_user("robin@example.com")
    {:ok, %{conn: conn, user: user}}
  end

  describe "create session" do
    test "login succeeds", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @create_attrs)
      assert json_response(conn, 200)["access_token"]
    end

    test "login fails for user that is already logged in", %{conn: conn, user: user} do
      conn = conn |> add_token_conn(user)
      conn = post(conn, Routes.session_path(conn, :create), session: @create_attrs)
      assert json_response(conn, 401)["errors"]["detail"] =~ "already logged in"
    end

    test "login fails for invalid password", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @invalid_attrs)
      assert json_response(conn, 401)["errors"]["detail"] =~ "need to login"
    end
  end
end
