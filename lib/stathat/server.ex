defmodule StatHat.Server do
  use GenServer

  @stathat_url "https://api.stathat.com/"

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: StatHat)    
  end

  def init(state) do
    {:ok, state}
  end
  
  def handle_cast({:ez_count, stat, count}, state) do    
    url = build_url("ez", [{"ezkey", state[:ez_key]}, {"stat", stat}, {"count", to_s(count)}])
    send_request(url)
    {:noreply, state}
  end
  
  def handle_cast({:ez_value, stat, value}, state) do
    url = build_url("ez", [{"ezkey", state[:ez_key]}, {"stat", stat}, {"value", to_s(value)}])
    send_request(url)
    {:noreply, state}
  end

  defp send_request(url) do
    :httpc.request(:get, {url, []}, [], [sync: false])
  end

  defp to_s(number) when is_float(number), do: Float.to_string(number)
  
  defp to_s(number) when is_integer(number), do: Integer.to_string(number)

  defp build_url(url, []), do: url
  
  defp build_url(url, args) do
    args = Stream.map(args, fn({k,v}) -> k <> "=" <> v end) |> Enum.join "&"
    @stathat_url <> url <> "?" <> args |> URI.encode |> :erlang.binary_to_list
  end
end
