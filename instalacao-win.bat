@echo off
cls

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

REM Verificar se Docker está instalado
where docker > nul 2>&1
if %errorlevel% neq 0 (
    echo "-----------------------------------------------------"
    echo "|               Instalando Docker...                |"
    echo "-----------------------------------------------------"

    REM Baixar e instalar o Docker Desktop para Windows
    REM Substitua esta seção com o comando de instalação apropriado para o Docker no Windows

    echo "Docker foi instalado com sucesso."
) else (
    echo "Docker já está instalado."
)

REM Verificar se Docker Compose está instalado
where docker-compose > nul 2>&1
if %errorlevel% neq 0 (
    echo "-----------------------------------------------------"
    echo "|           Instalando Docker Compose...             |"
    echo "-----------------------------------------------------"

    REM Baixar e instalar o Docker Compose
    REM Substitua esta seção com o comando de instalação apropriado para o Docker Compose no Windows

    echo "Docker Compose foi instalado com sucesso."
) else (
    echo "Docker Compose já está instalado."
)

REM Verificar instalação
echo "Docker version:"
docker --version

echo "Docker Compose version:"
docker-compose --version

REM Criar o arquivo docker-compose.yml
echo version: '3.8' > docker-compose.yml
echo services: >> docker-compose.yml
echo   mysql-server: >> docker-compose.yml
echo     container_name: mysql-server >> docker-compose.yml
echo     image: jonathancarvalho039/mysql-server:5.7 >> docker-compose.yml
echo     restart: always >> docker-compose.yml
echo     ports: >> docker-compose.yml
echo       - "3306:3306" >> docker-compose.yml
echo     environment: >> docker-compose.yml
echo       MYSQL_ROOT_PASSWORD: urubu100 >> docker-compose.yml
echo     command: --init-file /data/application/init.sql >> docker-compose.yml
echo     volumes: >> docker-compose.yml
echo       - ./init.sql:/data/application/init.sql >> docker-compose.yml
echo   java-app: >> docker-compose.yml
echo     container_name: java-app >> docker-compose.yml
echo     image: jonathancarvalho039/java-app:17 >> docker-compose.yml
echo     restart: always >> docker-compose.yml
echo     depends_on: >> docker-compose.yml
echo       - mysql-server >> docker-compose.yml
echo     ports: >> docker-compose.yml
echo       - "8080:8080" >> docker-compose.yml
echo     command: java -jar /app-cliente.jar >> docker-compose.yml
echo     network_mode: host >> docker-compose.yml

REM Criar o arquivo init.sql para configurar o usuário e as permissões
echo CREATE USER 'aluno1'@'%' IDENTIFIED BY '123'; > init.sql
echo GRANT ALL PRIVILEGES ON *.* TO 'aluno1'@'%'; >> init.sql
echo FLUSH PRIVILEGES; >> init.sql

REM Iniciar os contêineres
echo "-----------------------------------------------------"
echo "|                 Baixando imagens...                |"
echo "-----------------------------------------------------"

REM Substitua este comando pelo comando apropriado para iniciar os contêineres no Docker Desktop para Windows
REM Exemplo: docker-compose up -d

echo "Os contêineres foram iniciados com sucesso."

REM Perguntar se o usuário deseja executar o .jar no contêiner java-app
echo ""
echo ""
set /p resposta="Você deseja executar a aplicação(s/n): "
if /i "%resposta%"=="s" (
    REM Substitua este comando pelo comando apropriado para executar o .jar no contêiner java-app no Docker Desktop para Windows
    REM Exemplo: docker exec -it java-app java -jar /app-cliente.jar
) else (
    echo "Para inicializar a aplicação use esse comando: docker exec -it java-app java -jar /app-cliente.jar"
)

del docker-compose.yml
del init.sql
