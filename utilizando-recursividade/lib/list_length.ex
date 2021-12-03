defmodule ListLength do
  def call(lista), do: recursividade(lista, 0)

  def recursividade([], cont), do: cont

  def recursividade(lista, cont) do
    cont = cont + 1
    recursividade(tl(lista), cont)
  end
end
