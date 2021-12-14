defmodule GenReport do
  def build(nome_arquivo) do
    nome_arquivo
    |> ler_arquivo()
    |> Enum.reduce(criar_map(), fn linha, meu_map -> mostrar_valor(linha, meu_map) end)
  end

  def build, do: {:error, "Insira o nome de um arquivo"}

  def build_for_many(nome_arquivo) do
    nome_arquivo
    |> Task.async_stream(fn arquivo -> build(arquivo) end)
    |> Enum.reduce(criar_map(), fn {:ok, resultado}, meu_map ->
      juntando_maps(meu_map, resultado)
    end)
  end

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

  def somar() do
  end

  def juntando_maps(
        %{
          "all_hours" => valor01,
          "hours_per_month" => valor02,
          "hours_per_year" => valor03
        },
        %{
          "all_hours" => valor04,
          "hours_per_month" => valor05,
          "hours_per_year" => valor06
        }
      ) do
    all = merge_map(valor01, valor04)
    month = merge_map(valor02, valor05)
    year = merge_map(valor03, valor06)

    %{
      "all_hours" => all,
      "hours_per_month" => month,
      "hours_per_year" => year
    }
  end

  defp merge_map(map1, map2) do
    Map.merge(map1, map2, fn _key, val1, val2 ->
      case is_map(val1) and is_map(val2) do
        true -> merge_map(val1, val2)
        false -> val1 + val2
      end
    end)
  end

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
