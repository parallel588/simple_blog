defmodule SimpleBlog.Web.Admin.AccountController do
  use SimpleBlog.Web, :controller

  alias SimpleBlog.User

  def index(conn, _params) do
    accounts = User.list_accounts()
    render(conn, "index.html", accounts: accounts)
  end

  def show(conn, %{"id" => id}) do
    account = User.get_account!(id)
    render(conn, "show.html", account: account)
  end

  def edit(conn, %{"id" => id}) do
    account = User.get_account!(id)
    changeset = User.change_account(account)
    render(conn, "edit.html", account: account, changeset: changeset)
  end

end
