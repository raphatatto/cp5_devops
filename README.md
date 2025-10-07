# Aquaguard
#### API REST de monitoramento de eventos extremos 

## Integrates

Nome   | RM
------- | ------
Raphaela Oliveira Tatto | 554983
Tiago Ribeiro Capela | 558021

## Links
[Projeto de Java](https://github.com/raphatatto/cp5_devops_java_aquaguard) 

[Link do deploy](https://aquaguard-java-app-rm554983.azurewebsites.net/swagger-ui/index.html)

[Link do vídeo](https://youtube.com)

## How To
### Configurações de repositório
#### Primeiro passo é clonar o repositorio do seu projeto

```
git clone https://github.com/<SEU_USER_GITHUB>/<SEU_REPO>.git
cd <SEU_REPO>
```

#### Segundo passo remover a pasta .git do projeto

```
#Windows powershell
Remove-Item -Recurse -Force .git

#bash
rm -rf .git
```

#### Terceiro passo Criar um novo repositório para o projeto ser deployado por esse repositório
https://github.com/new

#### Quarto passo fazer o commit  e trazer as informações do outro repo para esse novo 

```
cd <SEU_REPO>

git init

git add .

git commit -m "first commit"

git remote add origin https://github.com/<SEU_USER_GITHUB>/<SEU_REPOSITORIO>.git
git branch -M main
git push -u origin main
```
#### Quinto passo baixar esse repositorio e descompactar a pasta
![baixando]()

### Azure CLI

#### No portal da azure entre no cloud shell 
![cloud_shell]()
##### Faça o upload do arquivo .sh 
![upload]()

```
#Instale essa extensão
az extension add --name application-insights

#Conceda o privilégio de execução do script
chmod +x aquaguard-deploy.sh

#Execute o script baixado com esse comando
./aquaguard-deploy.sh
```
#### Com isso o repositório vai iniciar o deploy e build no github actions (Com Falha)
###
