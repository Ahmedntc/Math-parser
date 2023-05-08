class Regra
  attr_reader :esquerda, :direita

  def initialize(esquerda, direita)
    @esquerda = esquerda
    @direita = direita
  end

  def to_s
    @esquerda + '->' + @direita.join
  end
end

class Gramatica
  attr_reader :regras, :simbolo_inicial

  def initialize(regras, simbolo_inicial)
    @regras = regras
    @simbolo_inicial = simbolo_inicial
  end
end