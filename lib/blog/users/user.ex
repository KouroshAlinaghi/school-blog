defmodule Blog.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema,
    user_id_field: :username,
    password_min_length: 6

  alias Blog.Social.Post

  schema "users" do
    pow_user_fields()
    has_many :posts, Post

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> pow_changeset(attrs)
    |> Ecto.Changeset.cast(attrs, [:username, :password])
    |> Ecto.Changeset.unique_constraint(:username)
  end
end
