defmodule Blog.Repo.Migrations.RemoveUserIdFromPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      remove :user_id
    end
  end
end
