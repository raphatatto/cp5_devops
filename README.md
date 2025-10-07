# 🌊 AquaGuard
### Projeto de Monitoramento de Eventos Naturais Extremos

O **AquaGuard** é um sistema desenvolvido para monitorar e gerenciar eventos naturais extremos, fornecendo alertas e dados em tempo real para auxiliar na tomada de decisão e na prevenção de desastres.

---

## 👥 Integrantes
| Nome | RM |
|------|----|
| Raphaela Oliveira Tatto | 554983 |
| Tiago Ribeiro Capela     | 558021 |

---

## 🔗 Links Importantes
- [📦 Repositório Java (API)](https://github.com/raphatatto/cp5_devops_java_aquaguard)  
- [🎥 Vídeo de Apresentação](https://youtu.be/CUi5ZMLO6xM)

---

## ⚙️ Como Configurar

### 1. Clone do Repositório
Baixe o projeto em sua máquina local:

```bash
git clone https://github.com/<SEU_USER_GITHUB>/<SEU_REPO>.git
cd <SEU_REPO>
```

---

### 2. Remover Histórico Git Antigo
Caso queira utilizar outro repositório para deploy:

```bash
# Windows PowerShell
Remove-Item -Recurse -Force .git

# Linux/Mac (bash)
rm -rf .git
```

---

### 3. Criar um Novo Repositório
Crie um novo repositório no GitHub:  
👉 [Criar Repositório](https://github.com/new)

---

### 4. Inicializar e Enviar o Código para o Novo Repo

```bash
cd <SEU_REPO>

git init
git add .
git commit -m "first commit"

git remote add origin https://github.com/<SEU_USER_GITHUB>/<SEU_REPOSITORIO>.git
git branch -M main
git push -u origin main
```

---

### 5. Baixar e Descompactar
Baixe o repositório compactado diretamente do GitHub:

![Baixando o Projeto](https://github.com/raphatatto/cp5_devops/blob/main/img/baixando.png)

---

## ☁️ Deploy na Azure

### 1. Acessando o Cloud Shell
No portal da Azure, abra o **Cloud Shell**:

![Cloud Shell](https://github.com/raphatatto/cp5_devops/blob/main/img/cloud_shell.png)

---

### 2. Fazer Upload do Script `.sh`
Carregue o arquivo de script para automação do deploy:

![Upload do Script](https://github.com/raphatatto/cp5_devops/blob/main/img/upload.png)

---

### 3. Executando os Comandos

```bash
# Instale a extensão necessária
az extension add --name application-insights

# Conceda permissão de execução ao script
chmod +x aquaguard-deploy.sh

# Execute o script
./aquaguard-deploy.sh
```

---

## ⚠️ Ajustes Pós-Deploy
O deploy inicial será disparado pelo **GitHub Actions**, porém, pode falhar caso as variáveis de ambiente do banco não estejam configuradas.

### 1. Configurar Secrets no GitHub
Adicione as variáveis de ambiente referentes ao banco de dados:

![Configuração de Secrets](https://github.com/raphatatto/cp5_devops/blob/main/img/secret.png)

---

### 2. Ajustar o Workflow YAML
Edite o arquivo YAML gerado automaticamente com as variaveis de ambientes

```
name: 'Build and deploy JAR app to Azure Web App: aquaguard-java-app-rm554983'

on:
  push:
    branches:
    - main
  workflow_dispatch:

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Set up Java version
      uses: actions/setup-java@v1
      with:
        java-version: '17'
    
    - name: Build with Maven
      env:
        SPRING_DATASOURCE_URL: ${{ secrets.SPRING_DATASOURCE_URL }}
        SPRING_DATASOURCE_USERNAME: ${{ secrets.SPRING_DATASOURCE_USERNAME }}
        SPRING_DATASOURCE_PASSWORD: ${{ secrets.SPRING_DATASOURCE_PASSWORD }}
      run: mvn clean install

    - name: Deploy to Azure Web App
      uses: azure/webapps-deploy@v2
      with: 
        app-name: 'aquaguard-java-app-rm554983'
        slot-name: 'production'
        publish-profile: ${{ secrets.AzureAppService_PublishProfile_378974c47651401ea1a483ff15f17322 }}
        package: '${{ github.workspace }}/target/*.jar'
```
