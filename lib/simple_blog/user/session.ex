defmodule SimpleBlog.User.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleBlog.User.Session

  embedded_schema do
    field :email, :string
    field :password, :string
  end

end
