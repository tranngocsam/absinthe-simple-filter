# Copied and modified from https://blog.drewolson.org/pagination-with-phoenix-ecto (Written by Drew Olson on February 20, 2015)
defmodule Demo.Paginator do
  defstruct [:entries, :page_number, :per_page, :total_entries]
  import Ecto.Query, only: [offset: 2, limit: 2, exclude: 2, select: 3]
  import Ecto.Query.API, only: [fragment: 1]
  
  def paginate(query, %{} = params) do
    page_number = to_int(Map.get(params, "page") || Map.get(params, :page) || 1)
    per_page = to_int(Map.get(params, "per_page") || Map.get(params, :per_page) || 10)
    
    %Demo.Paginator{
      entries: entries(query, page_number, per_page),
      page_number: page_number,
      per_page: per_page,
      total_entries: total_entries(query)
    }
  end
  
  defp entries(query, page_number, per_page) do
    offset = per_page * (page_number - 1)
    
    query
    |> limit(^per_page)
    |> offset(^offset)
    |> Demo.Repo.all
  end
  
  defp to_int(i) when is_integer(i), do: i
  defp to_int(s) when is_binary(s) do
    case Integer.parse(s) do
      {i, _} -> i
      :error -> :error
    end
  end
  
  defp total_entries(query) do
    query
    |> exclude(:order_by)
    |> exclude(:preload)
    |> exclude(:select)
    |> select([e], fragment("count(*)"))
    |> Demo.Repo.one
  end
end