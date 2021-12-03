defmodule NumeroImpar do
  def impar(lista),
    do:
      Enum.count(lista, fn valor ->
        if is_number(valor), do: rem(valor, 2) != 0
      end)
end
