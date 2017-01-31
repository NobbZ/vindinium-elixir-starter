defmodule Vindinium.Bots.NobbZ do

  defstruct blocked: [],
    mine_count: 0,
    unowned: [],
    taverns: [],
    players: %{1 => nil, 2 => nil, 3 => nil, 4 => nil}
  
  def move(state) do
    IO.inspect state

    pois = check_board(state["game"]["board"]["tiles"], {0,0}, state["game"]["board"]["size"], %__MODULE__{}) |> IO.inspect

    
    
    demands = %{
      thirst: 100 - state["hero"]["life"],
      fear:   100 - (state["hero"]["life"] - 20)
    }

    IO.inspect demands
    
    "Stay"
  end

  defp check_board(boardstring, current, size, poi)
  defp check_board(<<>>, {_, y}, y, poi), do: poi
  defp check_board(rest, {x, y}, x, poi), do: check_board(rest, {0, y+1}, x, poi)
  defp check_board(<<?\#, ?\#, rest::binary>>, {x, y}, size, poi), do: check_board(rest, {x+1, y}, size, %{poi|blocked: [{x,y}|poi.blocked]})
  defp check_board(<<?\s, ?\s, rest::binary>>, {x,y}, size, poi), do: check_board(rest, {x+1, y}, size, poi)
  defp check_board(<<?$, ?-, rest::binary>>, {x,y}, size, poi), do: check_board(rest, {x+1, y}, size, %{poi|unowned: [{x,y}|poi.unowned], mine_count: poi.mine_count + 1})
  defp check_board(<<?[, ?], rest::binary>>, {x,y}, size, poi), do: check_board(rest, {x+1,y}, size, %{poi|taverns: [{x,y}|poi.taverns]})
  defp check_board(<<?@, n::utf8, rest::binary>>, {x,y}, size, poi) do
    player = n - ?0
    check_board(rest, {x+1,y}, size, %{poi|players: %{poi.players | player => {x,y}}})
  end
  defp check_board(<<a::utf8, b::utf8, _::binary>>, pos, size, poi), do: IO.inspect {<<a::utf8, b::utf8>>, pos, poi}
end
