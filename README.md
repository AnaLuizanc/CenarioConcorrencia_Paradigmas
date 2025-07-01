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

*  Pedidos preparados mais de uma vez
*  Pedidos desaparecendo
*  Lista de pedidos prontos incompleta
*  Fila de pedidos não esvaziava ao final

Esses erros ocorreram porque o acesso às variáveis globais **fila_de_pedidos** e **pedidos_prontos** não era sincronizado.

## Solução:
Controle de Concorrência com Mutex
Na versão corrigida, utilizamos a classe Mutex do Ruby para proteger as regiões críticas. Exemplo:

```ruby
fila_mutex.synchronize do
  break if fila_de_pedidos.empty?
  pedido = fila_de_pedidos.shift
end
```

Dessa forma, garantimos que apenas uma thread por vez possa acessar e modificar a fila de pedidos.

Também protegemos a lista **pedidos_prontos** durante inserção, evitando sobrescritas e perda de dados.

### Explicação detalhada do uso do Mutex

O `Mutex` (Mutual Exclusion) é um mecanismo de sincronização que garante que apenas uma thread execute um bloco de código crítico por vez. No contexto do código Ruby deste projeto, o Mutex é utilizado para proteger duas regiões críticas:

1. **Retirada de pedidos da fila**:  
   O acesso à fila de pedidos (`fila_de_pedidos`) é protegido por um Mutex. Isso impede que duas threads retirem o mesmo pedido simultaneamente ou que uma thread tente acessar a fila enquanto outra está modificando-a.  
   O bloco protegido por `mutex.synchronize` garante que a verificação se a fila está vazia e a retirada do pedido (`shift`) ocorram de forma atômica, evitando condições de corrida.

2. **Inserção de pedidos prontos**:  
   A lista de pedidos prontos (`pedidos_prontos`) também é compartilhada entre as threads. Ao adicionar um pedido pronto, o Mutex garante que não haja sobrescrita ou perda de pedidos, mantendo a integridade dos dados.

#### Como o problema de concorrência foi resolvido

Sem o Mutex, múltiplas threads poderiam acessar e modificar as estruturas compartilhadas ao mesmo tempo, resultando em:
- Pedidos processados mais de uma vez (duplicados)
- Pedidos perdidos (não processados)
- Fila de pedidos não esvaziada corretamente

Com o uso do Mutex:
- Apenas uma thread por vez pode acessar as regiões críticas.
- Cada pedido é retirado e processado exatamente uma vez.
- A lista de pedidos prontos contém todos os pedidos, sem duplicatas ou perdas.
- A fila de pedidos fica vazia ao final do processamento.

O Mutex, portanto, elimina as condições de corrida e garante a consistência dos dados em ambientes multithread.

## Como rodar o código para testes

Este projeto possui dois arquivos Ruby e um de Python independentes e não conectados:

1. Um arquivo Ruby que reproduz o problema de concorrência (com erros).
2. Outro arquivo que contém a versão corrigida com controle de concorrência.
3. E um arquivo Python que também simula o mesmo cenário com erros.

Para testar o funcionamento da concorrência, siga:
1. Abra o terminal no diretório do projeto.
2. Execute cada arquivo separadamente, assim poderá observar o comportamento de cada um.
````
ruby cozinha_com_concorrencia.rb
ruby cozinha_com_tratamento_de_concorrencia.rb
``````

Durante a execução do _cozinha_com_concorrencia.rb_, você verá que alguns pedidos podem ser processados mais de uma vez ou desaparecer.

O arquivo _cozinha_com_tratamento_de_concorrencia.rb_ possui o controle de concorrência implementado (Mutex).

Todos os pedidos são processados exatamente uma vez e a fila fica vazia ao final.

#### Observações importantes:
Os arquivos não são conectados, por isso devem ser executados isoladamente.

Rodar um após o outro não gera integração, apenas testes separados.

Use as saídas para comparar e entender os efeitos da concorrência e sua correção.

A versão do código com concorrência também está disponível em python.

## Dicas de Git

Para cancelar um commit local (antes de fazer push), utilize:

```
git reset --soft HEAD~1
```

Se quiser descartar também as alterações feitas no commit:

```
git reset --hard HEAD~1
```

## Conclusão
Este exercício demonstrou na prática como race conditions podem surgir em ambientes concorrentes e como mecanismos como Mutex são essenciais para garantir segurança e consistência em programas multithread.
