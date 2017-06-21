defmodule SimpleBlog.Repo.Migrations.CreateSimpleBlog.Posts.Post do
  use Ecto.Migration

  def change do
    create table(:posts_posts) do
      add :title, :string
      add :subject, :string
      add :content, :text
      add :user_id, :integer

      timestamps()
    end

  end
end
