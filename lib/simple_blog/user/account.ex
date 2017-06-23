defmodule SimpleBlog.User.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleBlog.User.Account


  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :name, :string
    has_many :posts, SimpleBlog.Post
    timestamps()
  end

  @doc false
  def changeset(%Account{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :encrypted_password])
    |> validate_required([:name, :email, :encrypted_password])
  end
end