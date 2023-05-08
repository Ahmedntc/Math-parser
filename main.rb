require_relative 'utils/cyk'
require_relative 'utils/gramatica'
require_relative 'utils/earley'

regras = [
  # Chomsky
  # SOMA OU DIFERENÇA
  Regra.new('S',   %w[D SD]),
  #DIVISÃO OU MULTIPLICAÇÃO
  Regra.new('S',   %w[D MD]),
  #EXPONECIAÇÃO
  Regra.new('S',   %w[D EXP]),
  #abre parenteses
  Regra.new('S',   %w[LPAR P]),
  #numero negativo
  Regra.new('S',   %w[NEG S]),
  #SD = SOMA/DIFERENÇA MD = MULTIPLICAÇÃO/DIVISÃO EXP = EXPONENCIAÇÃO
  Regra.new('SD', %w[SUMDIF S]),
  Regra.new('MD', %w[MULDIV S]),
  Regra.new('EXP', %w[POW S]),

  # PARENTESES 
  #( S = num ou operaçao  e dpois rpar = fecha parenteses, P -> S PAR= fecha parenteses e operação depois
  Regra.new('P',   %w[S RPAR]),
  Regra.new('P',   %w[S PAROP]),
  Regra.new('LPAR',  %w[(]),
  Regra.new('RPAR',  %w[)]),

  # PARENTESES PAR = PARENTESES LPAR = LEFT PARENTESES RPAR = RIGHT PARENTESES
  Regra.new('PAROP',  %w[RPAR S1]),
  Regra.new('PAROP',  %w[RPAR M1]),
  Regra.new('PAROP',  %w[RPAR E1]),

  # OPERAÇÕES
  Regra.new('SUMDIF',  %w[+]),
  Regra.new('SUMDIF',  %w[-]),
  Regra.new('MULDIV',  %w[*]),
  Regra.new('MULDIV',  %w[/]),
  Regra.new('POW',  %w[^]),
  Regra.new('NEG',  %w[-]),
  #N + S = Número + S  E S SENDO OUTRO NUMERO
  Regra.new('S',   %w[0]),
  Regra.new('S',   %w[1]),
  Regra.new('S',   %w[2]),
  Regra.new('S',   %w[3]),
  Regra.new('S',   %w[4]),
  Regra.new('S',   %w[5]),
  Regra.new('S',   %w[6]),
  Regra.new('S',   %w[7]),
  Regra.new('S',   %w[8]),
  Regra.new('S',   %w[9]),

  Regra.new('D',   %w[0]),
  Regra.new('D',   %w[1]),
  Regra.new('D',   %w[2]),
  Regra.new('D',   %w[3]),
  Regra.new('D',   %w[4]),
  Regra.new('D',   %w[5]),
  Regra.new('D',   %w[6]),
  Regra.new('D',   %w[7]),
  Regra.new('D',   %w[8]),
  Regra.new('D',   %w[9])
]


gramatica = Gramatica.new(regras, 'S')

parser = CYKParser.new(gramatica)

# DEVEM SER ACEITAS
conta = '(1+4)*2^4'
parser.parse(conta).inspect
puts conta
puts parser.aceito? ? 'Aceito' : 'Não aceito'
puts "\n"

conta = '7/(1-3)'

puts conta
puts parser.aceito? ? 'Aceito' : 'Não aceito'
puts "\n"

conta = '9^(1*6/2+4)'
parser.parse(conta).inspect
puts conta
puts parser.aceito? ? 'Aceito' : 'Não aceito'
puts "\n"

conta = '2+4^-4/4'
parser.parse(conta).inspect
puts conta
puts parser.aceito? ? 'Aceito' : 'Não aceito'
puts "\n"

# DEVEM SER REJEITADAS
conta = '^2+4'
parser.parse(conta).inspect
puts conta
puts parser.aceito? ? 'Aceito' : 'Não aceito'
puts "\n"

conta = '9*2+'
parser.parse(conta).inspect
puts conta
puts parser.aceito? ? 'Aceito' : 'Não aceito'
puts "\n"

conta = '9++3'
parser.parse(conta).inspect
puts conta
puts parser.aceito? ? 'Aceito' : 'Não aceito'
puts "\n"

conta = '()*3'
parser.parse(conta).inspect
puts conta
puts parser.aceito? ? 'Aceito' : 'Não aceito'
puts "\n"

conta = '(3+3'
parser.parse(conta).inspect
puts conta
puts parser.aceito? ? 'Aceito' : 'Não aceito'
