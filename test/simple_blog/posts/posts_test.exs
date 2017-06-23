defmodule SimpleBlog.PostsTest do
  use SimpleBlog.DataCase

  alias SimpleBlog.Posts

  describe "posts" do
    alias SimpleBlog.Posts.Post

    @valid_attrs %{content: "some content", subject: "some subject", title: "some title", user_id: 42}
    @update_attrs %{content: "some updated content", subject: "some updated subject", title: "some updated title", user_id: 43}
    @invalid_attrs %{content: nil, subject: nil, title: nil, user_id: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture() |> SimpleBlog.Repo.preload(:user)
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

  end
end
