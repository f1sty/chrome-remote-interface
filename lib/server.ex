defmodule ChromeRemoteInterface.Server do
  defstruct [
    :host,
    :port
  ]

  @type t :: %__MODULE__{
    host: String.t,
    port: non_neg_integer() | String.t
  }

  @default_opts [
    host: "localhost",
    port: 9222
  ]

  @doc """
  Create a new ChromeRemoteInterface.Server to perform HTTP requests to.
  """
  @spec new(keyword()) :: __MODULE__.t
  def new(opts \\ []) do
    merged_opts = Keyword.merge(@default_opts, opts)

    %__MODULE__{
      host: Keyword.get(merged_opts, :host),
      port: Keyword.get(merged_opts, :port)
    }
  end
end
