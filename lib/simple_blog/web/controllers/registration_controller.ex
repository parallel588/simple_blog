defmodule SimpleBlog.Web.RegistrationController do
  use SimpleBlog.Web, :controller

  alias SimpleBlog.User

  def new(conn, _params) do
    changeset = User.prepare_registration(%SimpleBlog.User.Registration{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"registration" => account_params}) do
    case User.register_account(account_params) do
      {:ok, account} ->
        conn
        |> Guardian.Plug.sign_in(account)
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
end
