defmodule Blog.Repo.Migrations.AddPhotoToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :photo, :string, null: false
    end
  end
end
