defmodule SimpleBlog.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleBlog.User


  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :encrypted_password])
    |> validate_required([:name, :email, :encrypted_password])
  end
end
