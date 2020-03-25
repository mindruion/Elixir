defmodule RealTimeProgramming.Router do
  use Plug.Router

  plug Plug.Parsers,
       parsers: [:json],
       pass: ["text/*"],
       json_decoder: JSON
  plug :match
  plug :dispatch

  get "/" do
    forecast = GenServer.call(Aggregator, :get_forecast)
    date = "Forecast for #{DateTime.utc_now().day}/#{DateTime.utc_now().month}/#{DateTime.utc_now().year} #{
      DateTime.utc_now().hour
    }:#{DateTime.utc_now().minute}"
    result = [forecast: forecast[:final_forecast], date: date]
    {:ok, json} = JSON.encode(result)
    send_resp(conn, 200, json)
  end

  get "/favicon.ico" do
    send_resp(conn, 200, 'ok')
  end
end

