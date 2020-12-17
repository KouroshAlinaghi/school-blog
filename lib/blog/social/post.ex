defmodule Blog.Social.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blog.Users.User

  schema "posts" do
    field :body, :string
    field :title, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :user_id])
    |> validate_required([:title, :body, :user_id])
    |> validate_length(:body, min: 40)
    |> validate_length(:title, in: 3..30)
  end
end
