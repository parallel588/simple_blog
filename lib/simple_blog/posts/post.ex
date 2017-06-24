defmodule SimpleBlog.Post do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  schema "posts" do
    field :content, :string
    field :subject, :string
    field :title, :string
    belongs_to :user, SimpleBlog.User.Account

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :subject, :content, :user_id])
    |> validate_required([:title, :subject, :content, :user_id])
  end
end
