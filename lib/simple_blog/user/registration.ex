defmodule SimpleBlog.User.Registration do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleBlog.User.Registration

  embedded_schema do
    field :email, :string
    field :name, :string
    field :password, :string
    field :password_confirmation, :string
  end

end
