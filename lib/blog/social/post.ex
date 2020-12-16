defmodule Blog.Social.Post do
  use Ecto.Schema
  import Ecto.Changeset
  use Arc.Ecto.Schema

  alias Blog.Users.User

  schema "posts" do
    field :body, :string
    field :title, :string
    field :photo, Blog.Photo.Type
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    attrs = add_timestamp(attrs)
    post
    |> cast(attrs, [:title, :body, :user_id])
    |> cast_attachments(attrs, [:photo])
    |> validate_required([:title, :body, :user_id, :photo])
    |> validate_length(:body, min: 40)
    |> validate_length(:title, in: 3..30)
  end

  defp add_timestamp(%{"photo" => %Plug.Upload{filename: name} = photo} = attrs) do
    photo = %Plug.Upload{photo | filename: prepend_timestamp(name)}
    %{attrs | "photo" => photo}
  end

  defp add_timestamp(params), do: params

  defp prepend_timestamp(name) do
    "#{:os.system_time()}" <> name
  end
end
