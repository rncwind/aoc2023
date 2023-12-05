defmodule Day2Test do
  use ExUnit.Case

  test "split_game_prefix works for Game 1 test inputs" do
    input = game1()
    expected = ["Game 1", "3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"]
    assert Day2.split_game_prefix(input) == expected
  end

  test "split_game_prefix works for test input" do
    expected = [
      ["Game 1", "3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"],
      ["Game 2", "1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"],
      ["Game 3", "8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"],
      ["Game 4", "1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"],
      ["Game 5", "6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"]
    ]

    result = Enum.map(part1_test_input(), fn x -> Day2.split_game_prefix(x) end)
    assert result == expected
  end

  test "split_rounds works for Game 1" do
    input = game1()
    expected = ["3 blue, 4 red", "1 red, 2 green, 6 blue", "2 green"]
    [_, rest] = Day2.split_game_prefix(input)
    rounds = Day2.split_rounds(rest)
    assert rounds == expected
  end

  test "split_pulls works for Game 1" do
    input = game1()
    expected = [["3 blue", "4 red"], ["1 red", "2 green", "6 blue"], ["2 green"]]
    [_, rest] = Day2.split_game_prefix(input)
    rounds = Day2.split_rounds(rest)
    pulls = Enum.map(rounds, fn x -> Day2.split_pulls(x) end)
    assert pulls == expected
  end

  test "pull_to_map works for Game 1" do
    input = game1()

    expected = [
      [{:blue, 3}, {:red, 4}],
      [{:red, 1}, {:green, 2}, {:blue, 6}],
      [{:green, 2}]
    ]

    [_, rest] = Day2.split_game_prefix(input)
    rounds = Day2.split_rounds(rest)
    pulls = Enum.map(rounds, fn x -> Day2.split_pulls(x) end)
    mapped = Enum.map(pulls, fn x -> Enum.map(x, fn y -> Day2.pull_to_tuple(y) end) end)
    # IO.inspect(mapped)
    assert mapped == expected
  end

  test "shown_too_many? works for game1" do
    input = game1()
    baglim = game1_baglimit()
    [_, rest] = Day2.split_game_prefix(input)
    rounds = Day2.split_rounds(rest)
    pulls = Enum.map(rounds, fn x -> Day2.split_pulls(x) end)
    mapped = Enum.map(pulls, fn x -> Enum.map(x, fn y -> Day2.pull_to_tuple(y) end) end)
    flat = mapped |> List.flatten()
    wasvalid = Day2.shown_too_many?(flat, baglim)
    assert wasvalid == true
  end

  test "is_game_valid works for game1" do
    input = game1()
    baglim = game1_baglimit()
    assert Day2.is_game_valid?(input, baglim) == true
  end

  test "is_game_valid works for game2" do
    input = game2()
    baglim = game1_baglimit()
    assert Day2.is_game_valid?(input, baglim) == true
  end

  test "is_game_valid works for game3" do
    input = game3()
    baglim = game1_baglimit()
    assert Day2.is_game_valid?(input, baglim) == false
  end

  test "is_game_valid works for game4" do
    input = game4()
    baglim = game1_baglimit()
    assert Day2.is_game_valid?(input, baglim) == false
  end

  test "is_game_valid works for game5" do
    input = game5()
    baglim = game1_baglimit()
    assert Day2.is_game_valid?(input, baglim) == true
  end

  test "collect validity of games for test input" do
    input = part1_test_input()
    baglim = game1_baglimit()
    expected = [{1, true}, {2, true}, {3, false}, {4, false}, {5, true}]

    validgames =
      Enum.map(input, fn x ->
        {id, _} = Day2.get_game_id_and_game(x)
        valid = Day2.is_game_valid?(x, baglim)
        {id, valid}
      end)

    assert validgames == expected
  end

  test "part 1 examples sum correctly" do
    input = part1_test_input()
    baglim = game1_baglimit()
    expected = 8

    validgames =
      Enum.map(input, fn x ->
        {id, _} = Day2.get_game_id_and_game(x)
        valid = Day2.is_game_valid?(x, baglim)
        {id, valid}
      end)

    sum_of_valid_games = Day2.sum_valid_games(validgames)
    assert sum_of_valid_games == expected
  end

  test "Answer part 1" do
    input = part1_full_input()
    baglim = game1_baglimit()

    validgames =
      Enum.map(input, fn x ->
        {id, _} = Day2.get_game_id_and_game(x)
        valid = Day2.is_game_valid?(x, baglim)
        {id, valid}
      end)

    sum_of_valid_games = Day2.sum_valid_games(validgames)
    IO.puts(sum_of_valid_games)
  end

  test "Get max of each colour for round" do
    input = part1_test_input()

    maxes =
      Enum.map(input, fn x ->
        {id, _} = Day2.get_game_id_and_game(x)
        max = Day2.get_max_of_colour(x)
        power = Day2.calculate_cube_power(max)
        {id, max, power}
      end)

    # IO.inspect(maxes)
    # IO.inspect(Enum.at(maxes, 0))
  end

  test "answer part 2" do
    input = part1_full_input()

    powers =
      Enum.map(input, fn x ->
        {id, _} = Day2.get_game_id_and_game(x)
        max = Day2.get_max_of_colour(x)
        power = Day2.calculate_cube_power(max)
        power
      end)

    IO.puts(Enum.sum(powers))
  end

  def part1_test_input, do: AOCHelpers.file_to_list_of_string("part1_test.txt")
  def part1_full_input, do: AOCHelpers.file_to_list_of_string("part1_full_input.txt")
  def game1, do: hd(part1_test_input())
  def game2, do: Enum.fetch!(part1_test_input(), 1)
  def game3, do: Enum.fetch!(part1_test_input(), 2)
  def game4, do: Enum.fetch!(part1_test_input(), 3)
  def game5, do: Enum.fetch!(part1_test_input(), 4)
  def game1_baglimit, do: [{:red, 12}, {:green, 13}, {:blue, 14}]
end
