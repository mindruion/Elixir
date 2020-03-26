defmodule Print do
  def start_link do
    time_now = Time.utc_now()
    update_frequency = 1000
    forecast_pid = spawn_link(__MODULE__, :get_forecast, [time_now, update_frequency, true])
    :ets.new(:buckets_registry, [:named_table])

    :ets.insert(:buckets_registry, {"forecast_pid", forecast_pid})
    {:ok, self()}
  end

  def get_forecast(start_time, update_frequency, is_working) do
    time_now = Time.utc_now()
    diff = Time.diff(time_now, start_time, :millisecond)

    if diff > update_frequency && is_working === true do
      get_forecast(time_now, update_frequency, is_working)
    else
      receive do
        [is_working | update_frequency] ->
          if update_frequency < 200 do
            IO.puts("Minimum update frequency is 200")
            Process.sleep(2000)
            get_forecast(start_time, 200, is_working)
          else
            get_forecast(start_time, update_frequency, is_working)
          end
      after
        10 -> get_forecast(start_time, update_frequency, is_working)
      end
    end
  end
end
