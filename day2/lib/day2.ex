defmodule Day2 do
  def get_game_id_and_game(line) do
    [gameid, rest] = split_game_prefix(line)
    games = split_rounds(rest)
    [_, id] = gameid |> AOCHelpers.split_and_trim(" ")
    realid = id |> String.to_integer()
    {realid, games}
  end

  @spec split_game_prefix(String.t()) :: list[String.t()]
  def split_game_prefix(line) do
    AOCHelpers.split_and_trim(line, ":")
  end

  @spec split_rounds(String.t()) :: list[String.t()]
  def split_rounds(line) do
    AOCHelpers.split_and_trim(line, ";")
  end

  @spec split_pulls(String.t()) :: list[String.t()]
  def split_pulls(round) do
    AOCHelpers.split_and_trim(round, ",")
  end

  def pull_to_tuple(pull) do
    pull_parts = AOCHelpers.split_and_trim(pull, " ")
    count = hd(pull_parts) |> String.to_integer()
    colour_str = List.last(pull_parts)

    cond do
      colour_str == "red" -> {:red, count}
      colour_str == "green" -> {:green, count}
      colour_str == "blue" -> {:blue, count}
    end
  end

  def shown_too_many?(round, baglimit) do
    [{_, redlim}, {_, greenlim}, {_, bluelim}] = baglimit

    wasvalid =
      Enum.map(round, fn x ->
        case x do
          {:red, seen} -> seen <= redlim
          {:green, seen} -> seen <= greenlim
          {:blue, seen} -> seen <= bluelim
          _ -> nil
        end
      end)

    # IO.inspect(wasvalid, label: "was valid?")
    !Enum.member?(wasvalid, false)
  end

  def is_game_valid?(input, baglimit) do
    [_, rest] = Day2.split_game_prefix(input)
    rounds = Day2.split_rounds(rest)
    pulls = Enum.map(rounds, fn x -> Day2.split_pulls(x) end)
    mapped = Enum.map(pulls, fn x -> Enum.map(x, fn y -> Day2.pull_to_tuple(y) end) end)
    flat = mapped |> List.flatten()
    Day2.shown_too_many?(flat, baglimit)
  end

  def sum_valid_games(id_valid_pair_list) do
    Enum.reduce(id_valid_pair_list, 0, fn {id, valid}, acc ->
      if valid do
        acc + id
      else
        acc
      end
    end)
  end

  def get_max_of_colour(input) do
    flat = convert_rounds(input)

    Enum.reduce(flat, %{:red => 0, :green => 0, :blue => 0}, fn x, acc ->
      case x do
        {:red, seen} ->
          if seen > acc[:red] do
            Map.replace(acc, :red, seen)
          else
            acc
          end

        {:green, seen} ->
          if seen > acc[:green] do
            Map.replace(acc, :green, seen)
          else
            acc
          end

        {:blue, seen} ->
          if seen > acc[:blue] do
            Map.replace(acc, :blue, seen)
          else
            acc
          end

        _ ->
          acc
      end
    end)
  end

  def calculate_cube_power(maxes) do
    maxes[:red] * maxes[:green] * maxes[:blue]
  end

  def convert_rounds(input) do
    [_, rest] = split_game_prefix(input)
    rounds = Day2.split_rounds(rest)
    pulls = Enum.map(rounds, fn x -> Day2.split_pulls(x) end)
    mapped = Enum.map(pulls, fn x -> Enum.map(x, fn y -> Day2.pull_to_tuple(y) end) end)
    mapped |> List.flatten()
  end
end

defmodule AOCHelpers do
  def file_to_list_of_string(filename) do
    {:ok, contents} = File.read(filename)
    contents |> String.split("\n", trim: true)
  end

  @spec split_and_trim(String.t(), String.t()) :: list[String.t()]
  def split_and_trim(line, spliton) do
    line |> String.split(spliton, trim: true) |> Enum.map(fn x -> String.trim(x) end)
  end
end
