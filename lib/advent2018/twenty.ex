defmodule Advent2018.Twenty do
  def solve do
    File.read!("input/twenty.txt")
    |> parse_path
    |> max_distance
    |> IO.inspect()
  end

  @doc """
  Parses a path into a list of lists.
    iex> Advent2018.Twenty.parse_path("^ENWWW$")
    [:E, :N, :W, :W, :W]

    iex> Advent2018.Twenty.parse_path("^ENWWW(S|)$")
    [:E, :N, :W, :W, :W, [[:S], []]]

    iex> Advent2018.Twenty.parse_path("^ENWWW(NEEE|SSE)$")
    [
      :E, :N, :W, :W, :W,
      [
        [:N, :E, :E, :E],
        [:S, :S, :E]
      ]
    ]

    iex> Advent2018.Twenty.parse_path("^ENWWW(NEEE|SSE(EE|N))NEEE$")
    [
      :E, :N, :W, :W, :W, [ [:N, :E, :E, :E], [:S, :S, :E, [ [:E, :E], [:N],
        ]]
      ],
      :N, :E, :E, :E,
    ]
  """
  def parse_path(string) do
    string_path = string |> String.replace("$", "") |> String.replace("^", "") |> String.trim()

    parse_path(string_path, {[], []}, [])
  end

  defp parse_path("N" <> rest, {buffer, branches}, stack),
    do: parse_path(rest, {[:N | buffer], branches}, stack)

  defp parse_path("S" <> rest, {buffer, branches}, stack),
    do: parse_path(rest, {[:S | buffer], branches}, stack)

  defp parse_path("E" <> rest, {buffer, branches}, stack),
    do: parse_path(rest, {[:E | buffer], branches}, stack)

  defp parse_path("W" <> rest, {buffer, branches}, stack),
    do: parse_path(rest, {[:W | buffer], branches}, stack)

  defp parse_path("(" <> rest, current, stack),
    do: parse_path(rest, {[], []}, [current | stack])

  defp parse_path("|" <> rest, {buffer, branches}, stack),
    do: parse_path(rest, {[], [Enum.reverse(buffer) | branches]}, stack)

  defp parse_path(")" <> rest, {buffer, branches}, [{previous_buffer, previous_branches} | stack]),
    do:
      parse_path(
        rest,
        {[Enum.reverse([Enum.reverse(buffer) | Enum.reverse(branches)]) | previous_buffer],
         previous_branches},
        stack
      )

  defp parse_path("", {result, []}, []), do: Enum.reverse(result)

  @doc """
    Finds the longest route in the path

    iex> Advent2018.Twenty.max_distance([:N,:S,:N])
    3

    iex> Advent2018.Twenty.max_distance([:N,:S,:N,[[:W, :E], []]])
    5
  """
  def max_distance(path) do
    max_distance(path, 0)
  end

  defp max_distance([direction | rest], count) when is_atom(direction),
    do: max_distance(rest, count + 1)

  defp max_distance([branches | rest], count) when is_list(branches) do
    max_branch_distance =
      branches
      |> Enum.map(&max_distance(&1, 0))
      |> Enum.min()

    max_distance(rest, count + max_branch_distance)
  end

  defp max_distance([], count), do: count
end
