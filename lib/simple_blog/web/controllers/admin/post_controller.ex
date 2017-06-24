defmodule SimpleBlog.Web.Admin.PostController do
  use SimpleBlog.Web, :controller

  alias SimpleBlog.{Posts, User}

  def index(conn, _params) do
    posts = Posts.list_posts
    render(conn, "index.html", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    render(conn, "show.html", post: post)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%SimpleBlog.Post{})
    authors = User.list_accounts() |> Enum.map(&{&1.email, &1.id})
    render(conn, "new.html", changeset: changeset, authors: authors)
  end

  def create(conn, %{"post" => post_params}) do
    case Posts.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: admin_blog_path(conn, :show, post))
      {:error, %Ecto.Changeset{} = changeset} ->
        authors = User.list_accounts() |> Enum.map(&{&1.email, &1.id})
        render(conn, "new.html", changeset: changeset, authors: authors)
    end
  end

  def edit(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    changeset = Posts.change_post(post)
    authors = User.list_accounts() |> Enum.map(&{&1.email, &1.id})
    render(conn, "edit.html", post: post, changeset: changeset, authors: authors)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: admin_blog_path(conn, :show, post))
      {:error, %Ecto.Changeset{} = changeset} ->
        authors = User.list_accounts() |> Enum.map(&{&1.email, &1.id})
        render(conn, "edit.html", post: post, changeset: changeset, authors: authors)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    {:ok, _post} = Posts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: admin_blog_path(conn, :index))
  end

end
