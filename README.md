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

