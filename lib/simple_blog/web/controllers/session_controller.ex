defmodule SimpleBlog.Web.SessionController do
  use SimpleBlog.Web, :controller

  alias SimpleBlog.User

  def new(conn, _params) do
    changeset = User.prepare_session(%User.Session{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"session" => session_params}) do
    case User.signin_account(session_params) do
      {:ok, account} ->
        conn
        |> Guardian.Plug.sign_in(account)
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "You have been logged out")
    |> redirect(to: "/")
  end
end
