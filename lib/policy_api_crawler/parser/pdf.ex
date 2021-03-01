defmodule PolicyApi.Parser.Pdf do
  def run(raw) do
    codepoints = String.codepoints(raw)  
    val = Enum.reduce(codepoints, 
      fn(w, result) ->  
        cond do 
          String.valid?(w) -> 
            result <> w 

          true ->
            << parsed :: 8>> = w 
            result <>   << parsed :: utf8 >>
        end
      end)
    val
  end
end
