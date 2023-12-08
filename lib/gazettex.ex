defmodule Gazettex do
  alias Gazettex.Protocol
  alias Gazettex.Protocol.Journal.Stub

  defmodule Connection do
    defstruct endpoint: nil, channel: nil

    alias Gazettex.Connection

    def new(endpoint, channel) do
      %Connection{endpoint: endpoint, channel: channel}
    end
  end

  def connect(endpoint) do
    case GRPC.Stub.connect(endpoint) do
      {:ok, channel} -> {:ok, Connection.new(endpoint, channel)}
      err -> err
    end
  end

  def list_journals(conn) do
    request = Protocol.ListRequest.new()

    result =
      conn.channel
      |> Stub.list(request)

    case result do
      %Protocol.ListResponse{status: :OK, journals: journals} ->
        {:ok, journals}

      other ->
        {:error, other}
    end
  end

  def publish(conn, journal_name, data) do
    request = Protocol.AppendRequest.new(journal: journal_name, content: data)

    result =
      conn.channel
      |> Stub.append(request)

    case result do
      {:ok, %Protocol.AppendResponse{status: :OK}} ->
        IO.inspect(result)
        :ok

      other ->
        {:error, other}
    end
  end
end
