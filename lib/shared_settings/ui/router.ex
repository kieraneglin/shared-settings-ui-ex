defmodule SharedSettings.UI.Router do
  use Plug.Router
  require EEx

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

  def call(conn, opts) do
    conn = extract_namespace(conn, opts)
    super(conn, opts)
  end

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, index_template(%{conn: conn}))
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

  EEx.function_from_file(:def, :index_template, Path.expand("./templates/index.html.eex", __DIR__), [:assigns])

  def path(conn, path) do
    Path.join(conn.assigns[:namespace], path)
  end

  defp extract_namespace(conn, opts) do
    namespace = opts[:namespace] || ""

    Plug.Conn.assign(conn, :namespace, "/#{namespace}")
  end
end
