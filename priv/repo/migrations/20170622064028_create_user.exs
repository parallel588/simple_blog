defmodule SimpleBlog.Repo.Migrations.CreateSimpleBlog.User do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false, default: ""
      add :email, :string, null: false, default: ""
      add :encrypted_password, :string, null: false, default: ""

      timestamps()
    end

    create unique_index(:users, :email)
  end
end
