require 'thread'

fila_de_pedidos = []
pedidos_prontos = []
num_cozinheiros = 5
num_pedidos = 100
cozinheiros = []

# Criação do mutex para proteger as regiões críticas
mutex = Mutex.new

# Criando os pedidos
num_pedidos.times do |i|
  fila_de_pedidos << i
  puts "Pedido #{i} recebido..."
end

# Função que representa o trabalho de um cozinheiro
def cozinheiro(num, fila, prontos, mutex)
  puts "Cozinheiro #{num} pronto para receber pedidos!"

  loop do
    pedido = nil

    # Região crítica: leitura e retirada segura da fila de pedidos
    mutex.synchronize do
      break if fila.empty?
      pedido = fila.shift
    end

    break unless pedido

    puts "Cozinheiro #{num} preparando pedido #{pedido}"
    sleep(rand)  # Simula o tempo de preparo
    puts "Cozinheiro #{num} terminou pedido #{pedido}"

    # Região crítica: escrita segura na lista de pedidos prontos
    mutex.synchronize do
      prontos << pedido
    end
  end
end

# Criando as threads para os cozinheiros
num_cozinheiros.times do |i|
  t = Thread.new { cozinheiro(i, fila_de_pedidos, pedidos_prontos, mutex) }
  cozinheiros << t
end

# Aguardando os cozinheiros terminarem
cozinheiros.each(&:join)

# Resultados finais
puts "\n--- Fim do processamento ---"
puts "Pedidos restantes na fila: #{fila_de_pedidos.size}"         # Deve ser 0
puts "Total de pedidos prontos: #{pedidos_prontos.size}"          # Deve ser 100
puts "Pedidos únicos processados: #{pedidos_prontos.uniq.size}"   # Deve ser 100
puts "Pedidos duplicados: #{pedidos_prontos.size - pedidos_prontos.uniq.size}"  # Deve ser 0
