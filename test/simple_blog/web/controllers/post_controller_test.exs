defmodule SimpleBlog.Web.PostControllerTest do
  use SimpleBlog.Web.ConnCase

  alias SimpleBlog.Posts

  @create_attrs %{content: "some content", subject: "some subject", title: "some title", user_id: 42}
  @update_attrs %{content: "some updated content", subject: "some updated subject", title: "some updated title", user_id: 43}
  @invalid_attrs %{content: nil, subject: nil, title: nil, user_id: nil}

  def fixture(:post) do
    {:ok, post} = Posts.create_post(@create_attrs)
    post
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Posts"
  end
end
