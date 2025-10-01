#!/bin/bash

# --- Variáveis Iniciais ---
RESOURCE_GROUP="rg-radarmottu"
LOCATION="brazilsouth"
ADMIN_USER="admradar"
ADMIN_PASSWORD='RadarMottu@2025'
REPO_URL="https://github.com/joao1015/radarmottu-api-sprint3"

# --- Execução Única ---
echo "INFO: Iniciando a criação completa do ambiente..."

# 1. Criar Grupo de Recursos
az group create --name $RESOURCE_GROUP --location $LOCATION

# 2. Criar o SQL Server e capturar o nome
echo "INFO: Criando o SQL Server..."
SQL_SERVER_NAME=$(az sql server create \
  --name "srv-radarmottu-$(openssl rand -hex 3)" \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --admin-user $ADMIN_USER \
  --admin-password "$ADMIN_PASSWORD" \
  --query name -o tsv)

# Verifica se o servidor foi criado antes de continuar
if [ -z "$SQL_SERVER_NAME" ]; then
    echo "ERRO CRÍTICO: Falha ao criar o SQL Server. Verifique a senha ou outras configurações. Abortando."
    exit 1
fi

echo "SUCESSO: Servidor SQL criado com o nome: $SQL_SERVER_NAME"

# 3. Criar Regra de Firewall genérica para serviços Azure
# ... (o resto do script continua igual ao anterior) ...
az sql server firewall-rule create \
  --resource-group $RESOURCE_GROUP \
  --server $SQL_SERVER_NAME \
  --name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0

# 4. Criar o Banco de Dados
az sql db create \
  --name "db-radarmottu" \
  --server $SQL_SERVER_NAME \
  --resource-group $RESOURCE_GROUP \
  --service-objective S0

# 5. Criar o Plano do App Service
az appservice plan create \
  --name "plan-radarmottu" \
  --resource-group $RESOURCE_GROUP \
  --sku F1 \
  --is-linux

# 6. Criar o App Service (Web App)
WEB_APP_NAME="app-radarmottu-$(openssl rand -hex 3)"
echo "INFO: Criando o App Service com o nome: $WEB_APP_NAME"
az webapp create \
  --resource-group $RESOURCE_GROUP \
  --plan "plan-radarmottu" \
  --name $WEB_APP_NAME \
  --runtime "DOTNETCORE|8.0"

# 7. Montar e Configurar a Connection String
DB_CONNECTION_STRING="Server=tcp:${SQL_SERVER_NAME}.database.windows.net,1433;Initial Catalog=db-radarmottu;User ID=${ADMIN_USER};Password=${ADMIN_PASSWORD};Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
az webapp config connection-string set \
  --resource-group $RESOURCE_GROUP \
  --name $WEB_APP_NAME \
  --settings DefaultConnection="$DB_CONNECTION_STRING" \
  --connection-string-type SQLAzure

# 8. Configurar o Deploy via GitHub
az webapp deployment source config \
  --name $WEB_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --repo-url $REPO_URL \
  --branch main \
  --manual-integration

# 9. Adicionar regras de firewall específicas para os IPs de saída do App Service
echo "INFO: Adicionando regras de firewall para os IPs do App Service..."
OUTBOUND_IPS=$(az webapp show --resource-group $RESOURCE_GROUP --name $WEB_APP_NAME --query outboundIpAddresses --output tsv)
OUTBOUND_IPS=${OUTBOUND_IPS//,/ }
for IP in $OUTBOUND_IPS
do
  RULE_NAME="AllowApp_$(echo $IP | tr . _)"
  echo "INFO: Criando regra '$RULE_NAME' para o IP: $IP"
  az sql server firewall-rule create \
    --resource-group $RESOURCE_GROUP \
    --server $SQL_SERVER_NAME \
    --name $RULE_NAME \
    --start-ip-address $IP \
    --end-ip-address $IP
done

# 10. Reiniciar o App Service para aplicar todas as configurações
echo "INFO: Reiniciando o App Service..."
az webapp restart --name $WEB_APP_NAME --resource-group $RESOURCE_GROUP

# --- Fim ---
echo "----------------------------------------------------------------"
echo "PROCESSO COMPLETO!"
echo "Tudo foi criado e configurado."
echo "Acesse sua API em: http://$WEB_APP_NAME.azurewebsites.net"
echo "Lembre-se de sincronizar o código no Centro de Implantação do Portal."
echo "----------------------------------------------------------------"