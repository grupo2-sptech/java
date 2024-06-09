# Instruções de Instalação

Este é um guia simples para instalar o aplicativo usando o script de instalação fornecido.

# Passos de Instalação

## 1. **Baixe o Script de Instalação:**

Você pode baixar o script de instalação executando o seguinte comando no seu terminal:
   
**Linux:**
```bash
curl -O https://raw.githubusercontent.com/grupo2-sptech/script-instalacao/main/instalacao.sh
```
    
## 2. **Execute o Script:**

Após baixar o script, você pode executá-lo para iniciar o processo de instalação. Certifique-se de ter as permissões necessárias para executar scripts no seu sistema operacional. Você pode executar o script com o seguinte comando:
   
**Linux:**
 ```bash
 bash instalacao.sh
 ```
    
Isso iniciará o processo de instalação e seguirá as instruções fornecidas.

## 3. **Executando a Aplicação:**

Após a conclusão da instalação, utilize o comando abaixo para iniciar a aplicação e inserir suas credenciais de acesso:
   
**Linux:**
```bash
sudo docker exec -it java-app java -jar /app-cliente.jar
```

## 4. **Nota Importante:**

Certifique-se de revisar o script de instalação antes de executá-lo em seu sistema. Sempre é recomendável entender o que um script faz antes de permitir que ele faça alterações em seu sistema. Para visualizar o arquivo, use o seguinte comando:

**Linux:**
```bash
nano instalacao.sh
```

Se você tiver alguma dúvida ou encontrar problemas durante o processo de instalação, sinta-se à vontade para [abrir um problema](https://github.com/grupo2-sptech/script-instalacao/issues) no repositório.

## 5. **Outras Versões**

Pensando em resolver diversos tipos de problemas, nós, como empresa, decidimos criar novas versões da nossa aplicação.

# 5.1 **Relatório Seguro**

Essa versão tem como objetivo aumentar a interação do usuário com a aplicação, fornecendo dados em tempo real da máquina, relatórios de uso diário e relatórios de acesso do usuário.

**Linux:**
```bash
curl -O https://raw.githubusercontent.com/grupo2-sptech/script-instalacao/main/instalacao-relatorio.sh
bash instalacao-relatorio.sh
sudo docker exec -it java-app-relatorio java -jar /app-cliente-relatorio-seguro.jar
```

### 5.2 **Rede**

### 5.3 **USB**

### 5.4 **Histórico de Bloqueios**

### 5.5 **Reinicialização**

