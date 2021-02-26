defmodule PolicyApi.Parser.To do

  def json(struct) do
    struct
    |>Map.to_list()
  end
  
end
