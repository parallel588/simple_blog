defmodule SimpleBlog.Repo.Migrations.CreateSimpleBlog.Posts.Post do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string, null: false, default: ""
      add :subject, :string, null: false, default: ""
      add :content, :text, null: false, default: ""
      add :user_id, :integer, null: false

      timestamps()
    end
    create index(:posts, :user_id)
  end
end
