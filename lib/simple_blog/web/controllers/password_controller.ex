defmodule SimpleBlog.Web.PasswordController do

  use SimpleBlog.Web, :controller
  alias SimpleBlog.User

  def forget(conn, _) do
    render(conn, :forget)
  end

  def reset(conn, %{"user" => %{"email" => email}}) do
    account = User.get_account_by_email(email)
    if account do
      case User.reset_password_account(account) do
        {:ok, account} ->
          reset_link = password_url(conn, :confirm, account.password_reset_code)
          account
          |> SimpleBlog.User.Mailer.reset_password(reset_link)
          |> SimpleBlog.Mailer.deliver
          conn
          |> put_flash(:info, "Password reset link has been sent to your email address.")
          |> redirect(to: "/")
        {:error, changeset} ->
          conn
          |> put_flash(:error, "Unable to generate password reset code")
          |> redirect(to: "/")
      end
    else
      conn
      |> put_flash(:error, "Invalid email")
      |> redirect(to: "/")
    end
  end


  def confirm(conn, %{"code" => code}) do
    account = User.get_account_by_code(code)
    if account do
      with changeset <- User.prepare_reset_password_changeset(%{}),
        do: render(conn, :confirm, account: account, changeset: changeset)
    else
      conn
      |> put_flash(:error, "Invalid reset link")
      |> redirect(to: "/")
    end
  end

  def confirmed(conn, %{"code" => code, "user" => password_params}) do
    account = User.get_account_by_code(code)
    if account do
      case User.update_password(account, password_params) do
        {:ok, account} ->
          conn
          |> put_flash(:info, "Password updated, please login")
          |> redirect(to: session_path(conn, :new))
        {:error, changeset} ->
          render(conn, :confirm, account: account, changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, "Invalid reset link")
      |> redirect(to: "/")
    end
  end
end
