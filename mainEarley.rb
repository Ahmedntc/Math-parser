require_relative 'utils/gramatica'
require_relative 'utils/earley'



regras = [
    #SOMA E SUBTRAÇÃO
    Regra.new('S',   %w[S SUMDIF S]),
    Regra.new('S',   %w[M]),
    #MULTIPLICAÇÃO E DIVISÃO
    Regra.new('M',   %w[M MULDIV M]),
    Regra.new('M',   %w[E]),
    #EXPONENCIAÇÃO
    Regra.new('E',   %w[E POW E]),
    Regra.new('E',   %w[NEG]),
    #NEGATIVO
    Regra.new('N',   %w[NEG N]),
    Regra.new('N',   %w[P]),
    #PARÊNTESES
    Regra.new('P',   %w[( S )]),
    Regra.new('P',   %w[D]),

    #OPERAÇÕES
    Regra.new('POW',   %w[^]),	
    Regra.new('MULDIV',   %w[*]),
    Regra.new('MULDIV',   %w[/]),
    Regra.new('SUMDIF',   %w[+]),
    Regra.new('SUMDIF',   %w[-]),
    Regra.new('NEG',   %w[-]),
    #ALGARISMOS
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

parser = EarleyParser.new(gramatica)



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