# Bem-Vindo ao RefeiTech!

## Oque é o RefeiTech?
RefeiTech é um aplicativo para a compra de fichas da cantina de forma remota, idealizado para a matéria de Engenharia de Software - UTFPR 

## Getting Started
### Para o funcionamento da aplicação é necessário que seja instalado previamente a Linguagem Ruby na versão 3.3.4, framework Rails na versão 6.1.7 e PostgreSQL.

1. Faça o clone do repositório caso não tenha feito ainda.
```
$ git clone https://github.com/Goosyx/RefeiTech.git
```

2. Com a pasta RefeiTech aberta no VSCODE (ou editor de sua preferencia) digite os seguintes comandos no terminal.

   2.1 Instalação das dependencias do projeto:
    ```
    bundle install
    ```
    2.2 Atualize as Dependencias:
    ```
    bundle update
    ```

3. Navegue até RefeiTech/config/database.yml e insira seu username postgreSQL e senha.
   
4. Ainda com a pasta RefeiTech aberta no editor de sua preferencia digite os seguintes comandos no terminal.
   
    4.1 Gerando o banco de dados da aplicação:
    ```
    rails db:create
    ```
    4.2 Faça a migração do banco de dados da aplicação:
    ```
    rails db:migrate
    ```
5. Inicialize a aplicação utilizando o comando:
   ```
   rails s
   ```


## COMO RODAR OS TESTES:

 Subir o docker do backend (em segundo plano para ainda conseguir usar o terminal):
docker-compose up -d —build

 Acessar o container do backend:
```
docker-compose exec backend bash
```

 Verificar se todas as gemas estão instaladas no container:

```
bundle install
```

 Rodar os testes de unidade:

```
bundle exec rspec --format documentation
```

### Caso haja migrações pendentes:

saia do container bash e entre no /bin/bash

```
exit
```
```
docker-compose run backend /bin/bash
```

Adicionar as permissões necessárias para /bin/bash (caso ainda não possuam):

```
chmod +x bin/rails
```

 Verificar se o ruby está corretamente instalado:

```
ruby -v 
```

Verificar caminho da pasta env ruby:

```
head -n 1 bin/rails
```

Atualizar possiveis discrepâncias nas gemas:

```
bundle install
```

Rodar as migrações:

```
bin/rails db:migrate
```

Voltar para o bash do backend:

```
docker-compose exec backend bash
```

Realizar os testes novamente:

```
bundle exec rspec --format documentation
```

(feito isso os testes serão exibidos)

Caso deseje visualizar os códigos de teste via container (necessário instalar editor de texto):

Dentro do container backend bash (Usando o exemplo do nano):

```
apt-get update
```
```
apt-get install nano
```
```
nano (arquivo_de_teste_spec.rb)
```
