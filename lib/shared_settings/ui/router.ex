defmodule SharedSettings.UI.Router do
  use Plug.Router

  alias SharedSettings.UI.Parser

  plug CORSPlug, origin: "*"
  plug Plug.Logger, log: :debug
  plug Plug.Static,
    at: "/public",
    from: :shared_settings_ui

  plug Plug.Parsers, parsers: [:json],
    json_decoder: Jason

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200,
      "
      <!DOCTYPE html>
      <html lang=en>
        <head>
          <meta charset=utf-8>
          <meta http-equiv=X-UA-Compatible content=\"IE=edge\">
          <meta name=viewport content=\"width=device-width,initial-scale=1\">
          <link rel=icon href=\"/public/favicon.ico\">
          <title>shared-settings-ui</title>
          <link href=\"/public/app.css\" rel=stylesheet>
        </head>
        <body>
          <div id=app></div>
          <script src=\"/public/chunks.js\"></script>
          <script src=\"/public/app.js\"></script>
        </body>
      </html>
      "
    )
  end

  get "/api/settings" do
    {:ok, settings} = SharedSettings.get_all()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(settings))
  end

  post "/api/settings" do
    setting_value = Parser.parse_value(conn.params["type"], conn.params["value"])

    {:ok, _} = SharedSettings.put(conn.params["name"], setting_value)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(201, Jason.encode!(%{created: true}))
  end

  put "/api/settings/:name" do
    setting_value = Parser.parse_value(conn.params["type"], conn.params["value"])

    {:ok, _} = SharedSettings.put(name, setting_value)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(201, Jason.encode!(%{created: true}))
  end

  delete "/api/settings/:name/destroy" do
    :ok = SharedSettings.delete(name)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{deleted: true}))
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
