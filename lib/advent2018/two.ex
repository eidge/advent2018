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

  def run(2) do
    ids =
      File.stream!("input/two.txt")
      |> Stream.map(&String.trim/1)
      |> Enum.into([])

    combinations = for id1 <- ids, id2 <- ids, do: {id1, id2}

    Enum.reduce_while(combinations, nil, fn {id1, id2}, nil ->
      grouped_chars = Enum.zip(String.graphemes(id1), String.graphemes(id2))

      case Enum.count(grouped_chars, fn {c1, c2} -> c1 != c2 end) do
        1 -> {:halt, {id1, id2}}
        _ -> {:cont, nil}
      end
    end)
    |> IO.inspect(label: :result)
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

  def do_stuff do
    options = %{
      headers: %{
        user_agent: "Ms Explorer",
        accept_language: "EN"
      },
      proxy: %{
        ip: "69.69.69.11",
        port: 8080
      }
    }

    ibrowse_options = ibrowse_options(options)
  end

  defp ibrowse_options(%{proxy: %{ip: ip, port: port}}),
    do: Keyword.new([{:proxy_host, ip}, {:proxy_port, port}])

  defp ibrowse_options(%{proxy: _invalid_proxy}),
    do: throw(:invalid_proxy)

  defp ibrowse_options(_), do: Keyword.new()
end
