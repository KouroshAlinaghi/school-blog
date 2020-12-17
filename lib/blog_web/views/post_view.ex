defmodule BlogWeb.PostView do
  use BlogWeb, :view

  def to_jalaali(datetime) do
    datetime
    |> NaiveDateTime.to_date()
    |> Jalaali.to_jalaali()
  end
end
