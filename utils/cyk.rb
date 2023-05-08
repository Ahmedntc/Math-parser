require_relative 'gramatica'

class CYKParser
  attr_reader :tabela, :gramatica
  
  def initialize(gramatica)
    @gramatica = gramatica
  end

  def parse(entrada)
    n = entrada.length
    # Cria uma tabela NxN
    @tabela = Array.new(n) { Array.new(n) { [] } }

    # Passo 1: Analiza os símbolos terminais e adiciona seus
    # não-terminais geradores A->a
    adiciona_terminais(entrada)
    # Passo 2: subir na tabela pelas regras 
    # com não-terminais A->BC
    adiciona_nao_terminais(entrada)

    tabela
  end

  def aceito?
    tabela[0][-1].include?(gramatica.simbolo_inicial)
  end

  private
  def adiciona_terminais(entrada)
    arr_entrada = entrada.split('')
    arr_simbolos = Array.new(entrada.length) { [] }
    entrada.split('').each_with_index do |simbolo, i|
      @gramatica.regras.each do |regra|
        tabela[i][i] << regra.esquerda if terminal?(regra.direita, simbolo)
        arr_simbolos[i] << regra.esquerda if terminal?(regra.direita, simbolo)
      end
    end

    #imprime_linha(arr_entrada)
    dados = ""
    arr_simbolos.each do |simbolo|
      dados << simbolo.join(",")
      dados << " | "
    end
    puts dados
  end

  def adiciona_nao_terminais(entrada)
    n = entrada.length
    for largura in 1...n
      for inicio in 0...(n - largura)
        fim = inicio + largura
        (inicio...fim).each do |meio|
          @gramatica.regras.each do |regra|  
            if match_de_nao_terminais?(inicio, meio, fim, regra)
              puts regra.esquerda
              tabela[inicio][fim] << regra.esquerda
            end
          end
        end
      end
    end
  end

  def match_de_nao_terminais?(inicio, meio, fim, regra)
    return false if regra.direita.length < 2
    
    primeira_direita = regra.direita[0]
    segunda_direita = regra.direita[1]
    
    tabela[inicio][meio].include?(primeira_direita) &&
                tabela[meio + 1][fim].include?(segunda_direita)
  end

  def terminal?(direita, simbolo_lido)
    direita.length == 1 && direita[0] == simbolo_lido
  end
end