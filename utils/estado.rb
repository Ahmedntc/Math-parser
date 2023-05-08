class Estado
  attr_accessor :regra, :ponto, :inicio

  def initialize(regra, ponto, inicio)
    @regra = regra
    @ponto = ponto
    @inicio = inicio
  end

  def completo?
    ponto == regra.direita.length
  end

  def next_symbol
    regra.direita[ponto]
  end

  def advance
    Estado.new(regra, ponto + 1, inicio)
  end

  def ==(other)
    regra.to_s == other.regra.to_s && ponto == other.ponto && inicio == other.inicio
  end

  def eql?(other)
    regra.to_s == other.regra.to_s && ponto == other.ponto && inicio == other.inicio
  end

  def hash
    [regra.to_s, ponto, inicio].hash
  end

  def to_s
    direita = @regra.direita.join.insert(ponto, ".")
    "Estado: #{@regra.esquerda} -> #{direita}"
  end
end

class S
  attr_reader :estados, :estados_visitados

  def initialize(index)
    @index = index
    @estados = Set.new
    @estados_visitados = Set.new
  end

  def <<(element)
    estados << element unless estados_visitados.include?(element)
  end

  def take!
    taken = (estados - estados_visitados).take(1)
    estados_visitados << taken[0]
    taken[0]
  end

  def empty?
    (estados - estados_visitados).empty?
  end

  def to_s
    output = "==== Tabela #{@index} ====\n"
    estados.each do |regra|
      output << regra.to_s + "\n"
    end
    output + "==================\n" 
  end
end