defmodule Day1 do
  def get_numbers(cs) do
    get_numbers(cs, [])
  end

  def get_numbers([], found) do
    found |> Enum.reverse()
  end

  def get_numbers([x | xs], found) do
    case x do
      x when x in ?0..?9 ->
        ix = List.to_string([x]) |> String.to_integer()
        get_numbers(xs, [ix | found])

      _ ->
        get_numbers(xs, found)
    end
  end

  def get_first_number(cs) do
    get_numbers(cs) |> hd()
  end

  def get_last_number(cs) do
    get_numbers(cs) |> List.last()
  end

  def get_calibration_number(cs) do
    numbers = get_numbers(cs)
    result = hd(numbers) * 10
    result = result + List.last(numbers)
    result
  end

  def collect_calibration_numbers() do
    {:ok, contents} = File.read("calibrations.txt")
    split = contents |> String.split("\n", trim: true)
    charlistified = Enum.map(split, &to_charlist/1)
    numbers = Enum.map(charlistified, &get_calibration_number/1)
    numbers
  end

  def collect_calibration_numbers(inputs) do
    numbers = Enum.map(inputs, &get_calibration_number/1)
    numbers
  end

  def replace_number_words_with_numerals(line) do
    replacements = %{
      "eighthree" => "83",
      "eightwo" => "82",
      "sevenine" => "79",
      "twone" => "21",
      "oneight" => "18",
      "one" => "1",
      "two" => "2",
      "three" => "3",
      "four" => "4",
      "five" => "5",
      "six" => "6",
      "seven" => "7",
      "eight" => "8",
      "nine" => "9"
    }

    line |> String.replace(Map.keys(replacements), &Map.get(replacements, &1))
  end
end
