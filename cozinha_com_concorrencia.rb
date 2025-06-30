require 'thread'

fila_de_pedidos = []
pedidos_prontos = []
num_cozinheiros = 5
num_pedidos = 100
cozinheiros = []


num_pedidos.times do |i|
  fila_de_pedidos << i
  puts "Pedido #{i} recebido..."
end


def cozinheiro(num, fila, prontos)
  puts "Cozinheiro #{num} pronto para receber pedidos!"

  while !fila.empty?
   
    pedido = fila[0] 
    puts "Cozinheiro #{num} preparando pedido #{pedido}"
    sleep(rand) 
    puts "Cozinheiro #{num} terminou pedido #{pedido}"

    prontos << pedido
    fila.delete(pedido) 
  end
end


num_cozinheiros.times do |i|
  t = Thread.new { cozinheiro(i, fila_de_pedidos, pedidos_prontos) }
  cozinheiros << t
end


cozinheiros.each(&:join)

puts "\n--- Fim do processamento ---"
puts "Pedidos restantes na fila: #{fila_de_pedidos.size}"
puts "Total de pedidos prontos: #{pedidos_prontos.uniq.size} (esperado: #{num_pedidos})"
puts "Pedidos duplicados: #{pedidos_prontos.size - pedidos_prontos.uniq.size}"
#código do Ruby com o erro mantido