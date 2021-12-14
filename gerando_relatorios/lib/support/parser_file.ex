defmodule Parser do
  alias GenReport

  @meses_numero %{
    "1" => "janeiro",
    "2" => "fevereiro",
    "3" => "marco",
    "4" => "abril",
    "5" => "maio",
    "6" => "junho",
    "7" => "julho",
    "8" => "agosto",
    "9" => "setembro",
    "10" => "outubro",
    "11" => "novembro",
    "12" => "dezembro"
  }

  def parse_file(nome_arquivo) do
    nome_arquivo
    |> ler_arquivo()
  end

  def formatar_mes([nome, hora, dia, mes, ano]) do
    mes = Map.get(@meses_numero, mes)
    [nome, hora, dia, mes, ano]
  end

  def ler_arquivo(nome_arquivo) do
    "./relatorio/#{nome_arquivo}.csv"
    |> File.stream!()
    |> Enum.map(fn linha -> converter_linha(linha) end)
    |> Enum.map(fn linha -> formatar_mes(linha) end)
  end

  defp converter_linha(arquivo) do
    arquivo
    |> String.trim()
    |> String.split(",")
    |> List.update_at(1, &String.to_integer(&1))
    |> List.update_at(2, &String.to_integer(&1))
    |> List.update_at(4, &String.to_integer(&1))
  end
end
