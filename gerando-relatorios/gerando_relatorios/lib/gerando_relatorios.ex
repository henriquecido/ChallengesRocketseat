defmodule GenReport do
  def build(nome_arquivo) do
    nome_arquivo
    |> ler_arquivo()
    |> Enum.reduce(criar_map(), fn linha, meu_map -> mostrar_valor(linha, meu_map) end)
  end

  def build, do: {:error, "Insira o nome de um arquivo"}

  @nomes_funcionarios [
    "Cleiton",
    "Daniele",
    "Danilo",
    "Diego",
    "Giuliano",
    "Jakeliny",
    "Joseph",
    "Mayk",
    "Rafael",
    "Vinicius"
  ]
  @meses %{
    "janeiro" => 0,
    "fevereiro" => 0,
    "marco" => 0,
    "abril" => 0,
    "maio" => 0,
    "junho" => 0,
    "julho" => 0,
    "agosto" => 0,
    "setembro" => 0,
    "outubro" => 0,
    "novembro" => 0,
    "dezembro" => 0
  }
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
  @anos %{
    "2016" => 0,
    "2017" => 0,
    "2018" => 0,
    "2019" => 0,
    "2020" => 0
  }

  def mostrar_valor(
        [nome, hora, _dia, mes, ano],
        %{
          "all_hours" => all_hours,
          "hours_per_month" => hours_per_month,
          "hours_per_year" => hours_per_years
        } = meu_map
      ) do
    all_hours = Map.put(all_hours, nome, all_hours[nome] + hora)
    mes = Map.get(@meses_numero, mes)

    hours_per_month =
      Map.put(hours_per_month, nome, gerar_horas(hours_per_month, nome, hora, mes))

    hours_per_years =
      Map.put(hours_per_years, nome, gerar_horas(hours_per_years, nome, hora, ano))

    meu_map
    |> Map.put("all_hours", all_hours)
    |> Map.put("hours_per_month", hours_per_month)
    |> Map.put("hours_per_year", hours_per_years)
  end

  defp gerar_horas(mapa, nome, hora, opcao) do
    %{
      mapa[nome]
      | opcao => mapa[nome][opcao] + hora
    }
  end

  def ler_arquivo(nome_arquivo) do
    "./relatorio/#{nome_arquivo}.csv"
    |> File.stream!()
    |> Stream.map(fn linha -> converter_linha(linha) end)
  end

  defp converter_linha(arquivo) do
    arquivo
    |> String.trim()
    |> String.split(",")
    |> List.update_at(1, &String.to_integer(&1))
  end

  defp criar_map do
    all_hours = Enum.into(@nomes_funcionarios, %{}, &{&1, 0})

    hours_per_month = Enum.into(@nomes_funcionarios, %{}, &{&1, @meses})

    hours_per_year = Enum.into(@nomes_funcionarios, %{}, &{&1, @anos})

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
