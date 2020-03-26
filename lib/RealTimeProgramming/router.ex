defmodule RealTimeProgramming.Router do
  use Plug.Router

  plug CORSPlug, origin: ["http://localhost:4200"]
  plug Plug.Parsers,
       parsers: [:json],
       origin: ["*"],
       pass: ["text/*"],
       json_decoder: JSON
  plug :match
  plug :dispatch

  get "/" do
    forecast = GenServer.call(Aggregator, :get_forecast)
    date_now = "#{DateTime.utc_now().day}/#{DateTime.utc_now().month}/#{DateTime.utc_now().year} #{
      DateTime.utc_now().hour
    }:#{DateTime.utc_now().minute}:#{DateTime.utc_now().second}"
    result = [forecast: forecast[:final_forecast], date: date_now]
    {:ok, json} = JSON.encode(result)
    send_resp(conn, 200, json)
  end

  get "/favicon.ico" do
    send_resp(conn, 200, 'ok')
  end
end

