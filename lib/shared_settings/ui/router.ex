defmodule SharedSettings.UI.Router do
  use Plug.Router

  plug Plug.Logger, log: :debug
  plug Plug.Static,
    at: "/public",
    from: :shared_settings_ui


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
          <link href=\"/public/app.ab3694f9.css\" rel=stylesheet>
        </head>
        <body>
          <div id=app></div>
          <script src=\"/public/chunk-vendors.d0d7cb2a.js\"></script>
          <script src=\"/public/app.8554b9fa.js\"></script>
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

  match _ do
    send_resp(conn, 404, "oops")
  end
end
