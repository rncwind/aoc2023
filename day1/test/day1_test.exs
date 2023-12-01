defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "numbers of 1abc2 is [1,2]" do
    assert Day1.get_numbers(~c"1abc2") == [1, 2]
  end

  test "first number of 1abc2 is 1" do
    assert Day1.get_first_number(~c"1abc2") == 1
  end

  test "first number of pqr3stu8vwx is 3" do
    assert Day1.get_first_number(~c"pqr3stu8vwx") == 3
  end

  test "last number of 1abc2 is 2" do
    assert Day1.get_last_number(~c"1abc2") == 2
  end

  test "last number of pqr3stu8vwx is 8" do
    assert Day1.get_last_number(~c"pqr3stu8vwx") == 8
  end

  test "1abc2 returns 12" do
    assert Day1.get_calibration_number(~c"1abc2") == 12
  end

  test "pqr3stu8vwx returns 38" do
    assert Day1.get_calibration_number(~c"pqr3stu8vwx") == 38
  end

  test "a1b2c3d4e5f returns 15" do
    assert Day1.get_calibration_number(~c"a1b2c3d4e5f") == 15
  end

  test "collect_calibration_numbers works for our test inputs" do
    inputs = [~c"1abc2", ~c"pqr3stu8vwx", ~c"a1b2c3d4e5f", ~c"treb7uchet"]
    numbers = Day1.collect_calibration_numbers(inputs)
    assert numbers != nil
    assert numbers == [12, 38, 15, 77]
    assert Enum.sum(numbers) == 142
  end

  test "part2examples" do
    {:ok, contents} = File.read("part2test.txt")
    split = contents |> String.split("\n", trim: true)
    replaced = Enum.map(split, &Day1.replace_number_words_with_numerals/1)
    charlistified = Enum.map(replaced, &to_charlist/1)
    numbers = Enum.map(charlistified, &Day1.get_calibration_number/1)
    sum = Enum.sum(numbers)
    # IO.puts(sum)
  end

  test "part2answer" do
    {:ok, contents} = File.read("calibrations.txt")
    split = contents |> String.split("\n", trim: true)
    replaced = Enum.map(split, &Day1.replace_number_words_with_numerals/1)
    charlistified = Enum.map(replaced, &to_charlist/1)
    numbers = Enum.map(charlistified, &Day1.get_calibration_number/1)
    sum = Enum.sum(numbers)
    IO.puts(sum)
  end
end
