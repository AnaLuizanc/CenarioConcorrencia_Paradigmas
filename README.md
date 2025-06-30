# Restaurante Sim – Concorrência com Threads em Ruby

## Cenário: Concorrência

O Restaurante **Sim** precisa processar rapidamente um grande número de pedidos. Para isso, decidiu escalar o preparo utilizando **vários cozinheiros (threads)** que atuam simultaneamente, retirando pedidos de uma **fila compartilhada** e marcando-os como prontos.

### Objetivo

- Simular o cenário com múltiplas threads.
- Reproduzir e explicar os **erros de concorrência**.
- Corrigir o problema utilizando mecanismos de **controle de concorrência** da linguagem Ruby.

---

## Problema Inicial: Condições de Corrida

Na primeira versão do código, os cozinheiros acessavam a fila assim:

```ruby
pedido = fila_de_pedidos.first
fila_de_pedidos.delete_at(0)
```

Essas operações não são atômicas. Como múltiplas threads podem executar esse trecho ao mesmo tempo, observamos:

 Pedidos preparados mais de uma vez

 Pedidos desaparecendo

 Lista de pedidos prontos incompleta

 Fila de pedidos não esvaziava ao final

Esses erros ocorreram porque o acesso às variáveis globais fila_de_pedidos e pedidos_prontos não era sincronizado.

## Solução:
Controle de Concorrência com Mutex
Na versão corrigida, utilizamos a classe Mutex do Ruby para proteger as regiões críticas. Exemplo:

```ruby
Copiar
Editar
fila_mutex.synchronize do
  break if fila_de_pedidos.empty?
  pedido = fila_de_pedidos.shift
end
```

Dessa forma, garantimos que apenas uma thread por vez possa acessar e modificar a fila de pedidos.

Também protegemos a lista pedidos_prontos durante inserção, evitando sobrescritas e perda de dados.

## Como rodar o código para testes

Este projeto possui dois arquivos Ruby independentes e não conectados:

Um arquivo que reproduz o problema de concorrência (com erros).

Outro arquivo que contém a versão corrigida com controle de concorrência.

Para testar o funcionamento da concorrência, siga:
Abra o terminal no diretório do projeto.

Execute cada arquivo separadamente, assim poderá observar o comportamento de cada um.

Durante a execução do _cozinha_com_concorrencia.rb_, você verá que alguns pedidos podem ser processados mais de uma vez ou desaparecer.

O arquivo _cozinha_com_tratamento_de_concorrencia.rb_ possui o controle de concorrência implementado (Mutex).

Todos os pedidos são processados exatamente uma vez e a fila fica vazia ao final.

#### Observações importantes:
Os arquivos não são conectados, por isso devem ser executados isoladamente.

Rodar um após o outro não gera integração, apenas testes separados.

Use as saídas para comparar e entender os efeitos da concorrência e sua correção.

A versão do codígo com concorrencia também está disponivel em python.

## Conclusão
Este exercício demonstrou na prática como race conditions podem surgir em ambientes concorrentes e como mecanismos como Mutex são essenciais para garantir segurança e consistência em programas multithread.