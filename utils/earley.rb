require 'set'
require_relative 'gramatica'
require_relative 'estado'


class EarleyParser
  attr_reader :gramatica
  
  def initialize(gramatica)
    @gramatica = gramatica
    # Parser de Early precisa de um uma regra S->S
    # para o primeiro passo, assim, adicionamos 
    # automaticamente na gramática
    @gramatica.regras.unshift(Regra.new(gramatica.simbolo_inicial, [gramatica.simbolo_inicial]))
  end

  def parse(entrada)
    # Lista de estado. Tem tamanho do entrada + 1
    # pq se o último tiver o estado inicial,
    # estará no entrada + 1
    @tabela = Array.new(entrada.length + 1) { |indice| S.new(indice, entrada) }

    predict(Estado.new(@gramatica.regras[0], 0, 0, "Regra inicial"), 0)

    puts "\nLendo os caracteres... \n\n"
    
    #entrada.split('').each_with_index do |item, index|
    (0..entrada.size).each do |index|
      if (index == entrada.size)
        puts "\n================ Posição: #{index} ================"
      else
        puts "\n==== Caracter: #{entrada[index]}, Posição: #{index} ========"
      end
      
      until @tabela[index].empty?
        estado = @tabela[index].take!
        if estado.completo?
          complete(estado, index)
        else
          # checa se próximo item é um terminal
          if estado.next_symbol == entrada[index] 
            scan(estado, index)
          else
            predict(estado, index)
          end
        end
      end
    end

    puts "\n================ Fim de predição ================\n"

    puts @tabela
    final_is_valid?(@tabela[entrada.length])
  end

  private

  def final_is_valid?(estado)
    estado.estados.select { |estado| estado.regra.esquerda == gramatica.simbolo_inicial && estado.completo? && estado.inicio == 0 }.any?
  end

  def predict(estado, index)
    @gramatica.regras.each do |regra|
      if regra.esquerda == estado.next_symbol
        novo_estado = Estado.new(regra, 0, index, "Predito de #{estado}")
        @tabela[index] << novo_estado
        puts pastel.green("[Predict] Adicionando regra #{novo_estado} de Esquerda: #{regra.esquerda} e próximo símbolo: #{estado.next_symbol}")
      end
    end
  end

  def scan(estado, index)
    prox_estado = estado.advance(index, estado)
    puts "[Scan] Proximo estado: #{prox_estado} em S(#{index+1})"
    @tabela[index + 1] << prox_estado
  end

  def complete(estado, index)
    @tabela[estado.inicio].estados.each do |estado_candidato|
      if estado_candidato.next_symbol == estado.regra.esquerda
        puts "[Complete] Estado Candidato: #{estado_candidato}"
        @tabela[index] << estado_candidato.complete(index-1,estado, estado_candidato)
      end
    end
  end
end