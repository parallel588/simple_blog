defmodule SimpleBlog.User.Password do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleBlog.User.Password

  embedded_schema do
    field :password, :string
    field :password_confirmation, :string
  end

end
