defmodule SimpleBlog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleBlog.Posts.Post


  schema "posts_posts" do
    field :content, :string
    field :subject, :string
    field :title, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :subject, :content, :user_id])
    |> validate_required([:title, :subject, :content, :user_id])
  end
end
