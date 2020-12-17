defmodule Blog.Repo.Migrations.RemovePhotoFromPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      remove :photo
    end
  end
end
