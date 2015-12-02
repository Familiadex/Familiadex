defmodule Familiada.Utils do
  # Required
  def uniq_add(list, x) do
    ids = Enum.map(list, fn(r) -> r["id"] end)
    if Enum.member?(ids, x["id"] || x) do
      list
    else
      [x | list]
    end
  end

  def without(enumerable, to_remove) do
    Enum.filter(enumerable, fn(x) -> x != to_remove end)
  end
end
