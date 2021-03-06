defmodule ChromeRemoteInterface.Session do
  @moduledoc """
  This module provides an API to the DevTools HTTP API.
  """

  alias ChromeRemoteInterface.{
    HTTP,
    Server
  }

  @doc """
  List all Pages.

  Calls `/json/list`.
  """
  @spec list_pages(Server.t) :: HTTP.success_http_response | HTTP.error_http_response
  def list_pages(server) do
    server
    |> HTTP.call("/json/list")
  end

  @doc """
  List all Pages.

  Calls `/json/list`.
  """
  @spec list_pages!(Server.t) :: HTTP.success_http_response_short | Exception.t
  def list_pages!(server) do
    case list_pages(server) do
      {:ok, resp} -> resp
      {:error, error}  -> raise(error)
    end
  end

  @doc """
  Creates a new Page.

  Calls `/json/new`.
  """
  @spec new_page(Server.t) :: HTTP.success_http_response | HTTP.error_http_response
  def new_page(server) do
    server
    |> HTTP.call("/json/new")
  end

  @doc """
  Creates a new Page.

  Calls `/json/new`.
  """
  @spec new_page!(Server.t) :: HTTP.success_http_response_short | Exception.t
  def new_page!(server) do
    case new_page(server) do
      {:ok, resp} -> resp
      {:error, error}  -> raise(error)
    end
  end

  @doc """
  <documentation needed>

  Calls `/json/activate/:id`.
  """
  @spec activate_page(Server.t, String.t) :: HTTP.success_http_response | HTTP.error_http_response
  def activate_page(server, id) do
    server
    |> HTTP.call("/json/activate/#{id}")
  end


  @doc """
  Closes a Page.

  Calls `/json/close/:id`.
  """
  @spec close_page(Server.t, String.t) :: HTTP.success_http_response | HTTP.error_http_response
  def close_page(server, id) do
    server
    |> HTTP.call("/json/close/#{id}")
  end

  @doc """
  Gets the version of Chrome.

  Calls `/json/version`.
  """
  @spec version(Server.t) :: HTTP.success_http_response | HTTP.error_http_response
  def version(server) do
    server
    |> HTTP.call("/json/version")
  end
end
