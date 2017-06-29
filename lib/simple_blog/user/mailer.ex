defmodule SimpleBlog.User.Mailer do
  use Phoenix.Swoosh,
    view: SimpleBlog.Web.EmailView,
    layout: {SimpleBlog.Web.LayoutView, :email}

  def reset_password(account, reset_link) do
    new
    |> from("noreply@simple_blog.com")
    |> to(account.email)
    |> subject("Reset Password")
    |> render_body("reset_password.html", %{
          account: account, reset_link: reset_link})
  end
end
