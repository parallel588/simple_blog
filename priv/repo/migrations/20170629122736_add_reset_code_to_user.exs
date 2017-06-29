defmodule SimpleBlog.Repo.Migrations.AddResetCodeToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password_reset_code, :string
    end
  end
end
