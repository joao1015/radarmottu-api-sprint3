# Projeto Radar Mottu - API de Gerenciamento
## Disciplina: DEVOPS TOOLS & CLOUD COMPUTING - 3ª Sprint

Este repositório contém o código-fonte e os scripts de deploy para a API de gerenciamento de pátios, motos e geolocalização da Mottu. A solução foi desenvolvida em .NET 8 e implantada na nuvem da Microsoft Azure, utilizando os serviços de Aplicativo (App Service) e Banco de Dados SQL.

Todo o processo de provisionamento da infraestrutura e o deploy da aplicação foram automatizados via scripts do Azure CLI, conforme os requisitos da disciplina.

### Tabela de Conteúdos
1.  [Visão Geral do Projeto](#1-visão-geral-do-projeto)
2.  [Arquitetura da Solução](#2-arquitetura-da-solução)
3.  [Tecnologias Utilizadas](#3-tecnologias-utilizadas)
4.  [Estrutura do Repositório](#4-estrutura-do-repositório)
5.  [Passo a Passo para o Deploy (Obrigatório - App Service)](#5-passo-a-passo-para-o-deploy-obrigatório---app-service)
6.  [Testando a API via Swagger](#6-testando-a-api-via-swagger-exemplos-de-testes)
7.  [Critérios de Avaliação Atendidos](#7-critérios-de-avaliação-atendidos)
8.  [Autores](#8-autores)

---

## 1. Visão Geral do Projeto
A API **Radar Mottu** permite o gerenciamento completo de entidades essenciais para a operação da empresa:
-   **Estacionamentos (Pátios):** Cadastro, consulta, atualização e remoção de pátios operacionais.
-   **Motos:** Gerenciamento da frota de motos, associando cada uma a um pátio.
-   **Posicionamentos:** Registro de dados de geolocalização (latitude/longitude) das motos em tempo real.

A aplicação segue a arquitetura RESTful, expondo endpoints CRUD para cada uma das entidades.

## 2. Arquitetura da Solução

A solução foi desenhada com foco em simplicidade, escalabilidade e automação, utilizando recursos PaaS (Platform as a Service) do Azure.

*(**Instrução:** Insira aqui o seu diagrama da arquitetura. Abaixo, uma descrição textual que pode acompanhá-lo.)*

![Arquitetura da Solução](placeholder_para_seu_diagrama.png)

**Fluxo de Funcionamento:**
1.  **Repositório:** O código-fonte da aplicação e os scripts de automação (`.sh`, `.sql`) residem no GitHub.
2.  **Provisionamento via CLI:** a partir do  terminal, executa um único script (`criar_e_deployar_tudo.sh`) que se comunica com o Azure.
3.  **Criação de Recursos:** O script utiliza o Azure CLI para criar todos os recursos necessários de forma automatizada:
    * Grupo de Recursos (para agrupar os serviços).
    * Servidor SQL do Azure.
    * Banco de Dados SQL.
    * Plano de Serviço de Aplicativo (define a capacidade computacional).
    * Serviço de Aplicativo (hospeda a API).
4.  **Configuração e Deploy:** O mesmo script configura a Connection String do banco de dados no App Service e realiza o deploy do código-fonte da aplicação a partir do repositório local.
5.  **Criação das Tabelas:** Após o deploy, execute o script `script_bd.sql` no banco de dados recém-criado para gerar o schema (tabelas, chaves, etc).
6.  **Acesso do Usuário:** Com a infraestrutura e o banco prontos, a aplicação se torna totalmente funcional. Os usuários (ou outras aplicações) podem interagir com a API através de seus endpoints públicos.

---

## 3. Tecnologias Utilizadas
-   **Backend:** .NET 8, ASP.NET Core Web API
-   **Banco de Dados:** SQL Server (Azure SQL Database)
-   **Cloud Provider:** Microsoft Azure
    -   Azure App Service
    -   Azure SQL Database
-   **Automação/CLI:** Azure CLI

## 4. Estrutura do Repositório
O repositório está organizado da seguinte forma:
-   `/src`: Contém o código-fonte da aplicação .NET.
-   `criar_e_deployar_tudo.sh`: Script principal que automatiza a criação de toda a infraestrutura no Azure e realiza o deploy da aplicação.
-   `script_bd.sql`: Script DDL (Data Definition Language) contendo os comandos `CREATE TABLE` e `INSERT` para inicializar o banco de dados.
-   `README.md`: Este documento.

---

## 5. Passo a Passo para o Deploy (Obrigatório - App Service)

Siga estas etapas para provisionar a infraestrutura e implantar a aplicação do zero.

### Pré-requisitos
-   [Git](https://git-scm.com/downloads) instalado.
-   [.NET SDK 8.0](https://dotnet.microsoft.com/en-us/download/dotnet/8.0) ou superior instalado.
-   [Azure CLI](https://docs.microsoft.com/pt-br/cli/azure/install-azure-cli) instalado e configurado.

### Passo 1: Clonar o Repositório
```bash
git clone [https://github.com/joao1015/radarmottu-api-sprint3.git](https://github.com/joao1015/radarmottu-api-sprint3.git)
cd radarmottu-api-sprint3
```

### Passo 2: Login no Azure CLI
Abra um terminal (bash, zsh, ou Git Bash no Windows) e execute o comando abaixo. Uma janela do navegador será aberta para você realizar o login na sua conta do Azure.

Bash

az login

### Passo 3: Executar o Script de Provisionamento e Deploy

Este script fará todo o trabalho pesado: criar a infraestrutura, configurar e publicar a aplicação.

Importante: O script está localizado no repositório, ele está na raiz. Execute o comando a partir da raiz do projeto clonado.

Bash
./criar_e_deployar_tudo.sh

### Passo 4: Criar e Popular as Tabelas do Banco de Dados

Neste ponto, a infraestrutura está no ar e o código foi publicado. No entanto, a aplicação apresentará uma falha inicial, pois as tabelas do banco de dados ainda não existem.

Precisamos executar o script script_bd.sql no banco de dados que acabamos de criar.

Vá para o Portal do Azure.

Navegue até o banco de dados SQL que foi criado pelo script.

No menu esquerdo do banco de dados, encontre e clique em Editor de consultas (versão prévia).

Faça o login com as credenciais de administrador que foram definidas no script.

Abra o arquivo script_bd.sql no seu computador, copie todo o conteúdo.

Cole o conteúdo na janela do editor de consultas e clique em Executar.

Após a execução bem-sucedida, as tabelas e os dados de teste iniciais estarão no banco.

### Passo 5: Reiniciar o App Service (Recomendado)

Para garantir que a aplicação se reconecte ao banco de dados agora com as tabelas criadas, é uma boa prática reiniciar o App Service.

No Portal do Azure, navegue até o Serviço de Aplicativo criado.

Na página de Visão Geral, clique no botão Reiniciar.