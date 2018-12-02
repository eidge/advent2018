defmodule Advent2018.Two do
  def run(1) do
    {twos, threes} =
      File.stream!("input/two.txt")
      |> Enum.reduce({0, 0}, fn line, {twos, threes} ->
        {line_twos, line_threes} = checksum(line)
        {twos + line_twos, threes + line_threes}
      end)

    IO.inspect(twos * threes, label: :result)
  end

  defp checksum(entry) do
    values =
      entry
      |> String.graphemes()
      |> Enum.reduce(%{}, fn letter, count ->
        Map.update(count, letter, 1, &(&1 + 1))
      end)
      |> Map.values()
      |> Enum.uniq()

    {Enum.count(values, &(&1 == 2)), Enum.count(values, &(&1 == 3))}
  end
end
