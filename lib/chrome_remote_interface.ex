defmodule ChromeRemoteInterface do
  @moduledoc """
  Documentation for ChromeRemoteInterface.
  """

  alias ChromeRemoteInterface.PageSession

  protocol =
    with {:ok, _} <- Application.ensure_all_started(:hackney),
         {:ok, _, _, proto} <-
           :hackney.get("http://localhost:9222/json/protocol/", [], "", [:with_body]) do
      Poison.decode!(proto)
    else
      _ -> # fallback to static protocol file
        File.read!("priv/protocol.json")
        |> Poison.decode!()
    end

  # Generate ChromeRemoteInterface.RPC Modules

  Enum.each(protocol["domains"], fn(domain) ->
    defmodule Module.concat(ChromeRemoteInterface.RPC, domain["domain"]) do
      @domain domain
      @moduledoc domain["description"]

      def experimental?(), do: @domain["experimental"]

      for command <- @domain["commands"] do
        name = command["name"]
        description = command["description"]
        arg_doc =
          command["parameters"]
          |> List.wrap()
          |> Enum.map(fn(param) ->
            "#{param["name"]} - <#{param["$ref"] || param["type"]}> - #{param["description"]}"
          end)

        @doc """
        #{description}

        Parameters:
        #{arg_doc}
        """
        def unquote(:"#{name}")(page_pid) do
          page_pid |> PageSession.execute_command(
            unquote("#{domain["domain"]}.#{name}"),
            %{},
            []
          )
        end
        def unquote(:"#{name}")(page_pid, parameters) do
          page_pid |> PageSession.execute_command(
            unquote("#{domain["domain"]}.#{name}"),
            parameters,
            []
          )
        end
        def unquote(:"#{name}")(page_pid, parameters, opts) when is_list(opts) do
          page_pid |> PageSession.execute_command(
            unquote("#{domain["domain"]}.#{name}"),
            parameters,
            opts
          )
        end
      end
    end
  end)

  @protocol_version "#{protocol["version"]["major"]}.#{protocol["version"]["minor"]}"
  @doc """
  Gets the current version of the Chrome Debugger Protocol
  """
  def protocol_version(), do: @protocol_version
end
