defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  def about_us(conn, _) do
    conn
    |> render("about.html")
  end
end
