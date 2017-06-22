defmodule SimpleBlog.User.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleBlog.User.Session

  embedded_schema do
    field :email, :string
    field :password, :string
  end

  @doc false
  def changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end
end
