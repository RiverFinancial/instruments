defmodule Instruments.Statix do
  @moduledoc """
  The default stats reporter. Uses the `Statix` library.
  """
  use Statix, runtime_config: true

  def distribution(key, val, options \\ []) do
    message =
      case Keyword.get(options, :tags) do
        nil ->
          [key, ?:, to_string(val), "|d"]

        tag_list ->
          [key, ?:, to_string(val), "|d|#", Enum.intersperse(tag_list, ",")]
      end

    __MODULE__
    |> Process.whereis()
    |> :gen_udp.send(Instruments.statsd_host(), Instruments.statsd_port(), message)
  end
end
