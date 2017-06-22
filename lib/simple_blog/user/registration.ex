defmodule SimpleBlog.User.Registration do
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleBlog.User.Registration

  embedded_schema do
    field :email, :string
    field :name, :string
    field :password, :string
    field :password_confirmation, :string
  end

  @doc false
  def changeset(%Registration{} = registration, attrs) do
    registration
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
