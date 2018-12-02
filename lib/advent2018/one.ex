defmodule Advent2018.One do
  def run(1) do
    frequency_deltas()
    |> Enum.reduce(fn number, memo -> number + memo end)
    |> IO.inspect(label: :result)
  end

  def run(2) do
    frequency_deltas()
    |> first_repeated_value()
    |> IO.inspect(label: :result)
  end

  defp frequency_deltas do
    File.stream!("input/one.txt")
    |> Stream.map(fn line -> String.replace(line, "\n", "", global: true) end)
    |> Stream.map(fn num_str -> String.to_integer(num_str) end)
  end

  def first_repeated_value(stream) do
    initial_state = %{current: 0, frequencies: MapSet.new()}

    stream
    |> Stream.cycle()
    |> Enum.reduce_while(initial_state, fn delta, state ->
      if MapSet.member?(state.frequencies, state.current) do
        {:halt, state.current}
      else
        new_state = %{
          state
          | current: state.current + delta,
            frequencies: MapSet.put(state.frequencies, state.current)
        }

        {:cont, new_state}
      end
    end)
  end
end
