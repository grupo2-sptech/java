#!/bin/bash

clear

echo "
      __  __                       __
     / / / /  ____ _   _____  ____/ / _      __  ____ _   _____  _____
    / /_/ /  / __  /  / ___/ / __  / | | /| / / / __  /  / ___/ / _  /
   / __  /  / /_/ /  / /    / /_/ /  | |/ |/ / / /_/ /  / /    /  __/
  /_/ /_/   |____/  /_/     |____/   |__/|__/  |____/  /_/     |___/

            _____                                  _    __
           / ___/  ___    _____  __  __   _____   (_)  / /_   __  __
           |__ |  / _ |  / ___/ / / / /  / ___/  / /  / __/  / / / /
          ___/ / /  __/ / /__  / /_/ /  / /     / /  / /_   / /_/ /
         /____/  |___/  |___/  |____/  /_/     /_/   |__/   |___ /
                                                           /____/ "




echo "                       BEM-VINDO"
echo ""
echo "Vamos preparar essa máquina para que a aplicação seja executada!"


# Verificar se Docker está instalado
if ! which docker &> /dev/null
then
    echo "-----------------------------------------------------"
    echo "|               Instalando Docker...                |"
    echo "-----------------------------------------------------"

    # Atualizar pacotes existentes
    sudo apt-get update

    # Remover versões antigas do Docker
    sudo apt-get remove -y docker docker-engine docker.io containerd runc

    # Instalar pacotes necessários para usar o repositório APT sobre HTTPS
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

    # Adicionar a chave GPG oficial do Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    # Adicionar o repositório do Docker às fontes do APT
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Atualizar pacotes do APT novamente para incluir pacotes do Docker
    sudo apt-get update

    # Instalar Docker CE
    sudo apt-get install -y docker-ce

    # Adicionar o usuário atual ao grupo Docker
    sudo usermod -aG docker $USER


    echo "Docker Compose foi instalado com sucesso."

    sudo systemctl restart docker

else
    echo "Docker Compose já está instalado."
fi


# Verificar se Docker Compose está instalado
if ! which docker-compose &> /dev/null
then

    clear
    echo "-----------------------------------------------------"
    echo "|           Instalando Docker Compose...             |"
    echo "-----------------------------------------------------"

    # Instalar Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    # Aplicar permissões corretas ao binário do Docker Compose
    sudo chmod +x /usr/local/bin/docker-compose

    # Criar um link simbólico para Docker Compose em /usr/bin se não existir
    if [ ! -f /usr/bin/docker-compose ]; then
        sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    fi

    echo "Docker Compose foi instalado com sucesso."
else
    echo "Docker Compose já está instalado."
fi

# Verificar instalação
echo "Docker version:"
docker --version

echo "Docker Compose version:"
docker-compose --version

# Criar o arquivo docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3.8'

services:
  mysql-server:
    container_name: mysql-server
    image: joaogalhardo/mysql-server:5.7
    restart: always
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: urubu100
    network_mode: host
    command: --init-file /data/application/init.sql
    volumes:
      - ./init.sql:/data/application/init.sql

  java-app-rede:
    container_name: java-app-rede
    image: joaogalhardo/java-app-rede:17
    restart: always
    depends_on:
      - mysql-server
    ports:
      - "8080:8080"
    command: java -jar /app-cliente-rede.jar
    network_mode: host

EOF

# Criar o arquivo init.sql para configurar o usuário e as permissões
cat <<EOF > init.sql
CREATE USER 'aluno1'@'%' IDENTIFIED BY '123';
GRANT ALL PRIVILEGES ON *.* TO 'aluno1'@'%';
FLUSH PRIVILEGES;
EOF

# Iniciar os contêineres
echo "-----------------------------------------------------"
echo "|                 Baixando imagens...                |"
echo "-----------------------------------------------------"

sudo docker-compose up -d

echo "Os contêineres foram iniciados com sucesso."

# Perguntar se o usuário deseja executar o .jar no contêiner java-app
echo ""
echo ""
read -p "Você deseja executar a aplicação(s/n): " resposta

if [[ "$resposta" =~ ^[Ss]$ ]]
then
    sudo docker exec -it java-app-rede java -jar /app-cliente-rede.jar
else
    echo "Para inicializar a aplicação use esse comando: docker exec -it java-app java -jar /app-cliente-rede"
fi

rm docker-compose.yml
rm init.sql