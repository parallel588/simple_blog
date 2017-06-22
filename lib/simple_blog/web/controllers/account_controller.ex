defmodule SimpleBlog.Web.AccountController do
  use SimpleBlog.Web, :controller

  alias SimpleBlog.User

  def edit(conn, _) do
    account = Guardian.Plug.current_resource(conn)
    account_changeset = User.change_account(account)
    render(conn, "edit.html", account: account, changeset: account_changeset)
  end

  def update(conn, %{"account" => account_params}) do
    account = Guardian.Plug.current_resource(conn)
    case User.update_account(account, account_params) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account updated successfully.")
        |> redirect(to: account_path(conn, :edit))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", account: account, changeset: changeset)
      {:error, error_type} ->
        redirect(conn, to: "/")
    end
  end
end
