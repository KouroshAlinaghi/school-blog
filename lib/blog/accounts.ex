defmodule Blog.Accounts do
  import Ecto.Query, warn: false
  alias Blog.Repo
  alias Blog.Users.User

  def list_users() do
    Repo.all(User)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user!(id), do: Repo.get!(User, id)

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
end
