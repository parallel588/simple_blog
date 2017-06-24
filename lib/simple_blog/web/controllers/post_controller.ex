defmodule SimpleBlog.Web.PostController do
  use SimpleBlog.Web, :controller

  alias SimpleBlog.{Posts, Repo}

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = id
    |> Posts.get_post!
    |> Repo.preload([:user])
    render(conn, "show.html", post: post)
  end
end
