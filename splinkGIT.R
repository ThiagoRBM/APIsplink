library(httr)
library(dplyr)
library(readxl)

sp=c("Aristolochia gigantea", "Hedyosmum brasiliense")

buscaSpLink= function(vetorNomes, caminho= getwd()){
  especies= vetorNomes
  SPLink = "https://api.splink.org.br/"
  Species= "ScientificName/"
  Records= "records/"
  Coordenadas= "/Coordinates/yes" 
  
  vetorNomes= vetorNomes %>% 
    gsub(",", "/", ., perl = TRUE) %>% 
    gsub(" ", "%20", ., perl = TRUE)
  
  urlSPLink= paste0(SPLink,Records,Species,vetorNomes,Coordenadas) ## criando a URL
  
  listaBusca=vector("list", length=length(urlSPLink))
  for(i in 1:length(urlSPLink)){
    print(paste0("Buscando informações para: ", especies[i]))
    
  siteSPLink= httr::POST(urlSPLink[i], inherits=FALSE) ## fazendo o pedido
  
  if(siteSPLink[["status_code"]] != 200){informacoesSPLink= siteSPLink[["status_code"]]}
  informacoesSPLink = httr::content(siteSPLink, encoding = "UTF-8",
                                    type = 'text/tab-separated-values') ## retornando os dados
  
  listaBusca[[i]]=informacoesSPLink
  
  if(i%%5==0){
    Sys.sleep(3)
    print(paste0("espenrando 3 segundos para a próxima requisição"))}
  if(i == length(urlSPLink)){
    listaBusca2= do.call("rbind", listaBusca)
    
    if(!missing(caminho)){
      nomeTabela= paste0("buscaSplink_",format(Sys.time(), "%Y_%m_%d"),".txt")
      write.table(listaBusca2, paste0(caminho,"/", nomeTabela), sep= "\t",
                  fileEncoding = "UTF-8", row.names = FALSE, col.names = TRUE)
      
      print(paste0("tabela com informações salva em: ", caminho))
      } ## salvando o resultado da busca
    ## no diretorio indicado no come?o do script, usando o nome indicado tambem
    
    }
  }
  print(paste0("tabela com informações NÃO FORAM SALVAS"))
  return(listaBusca2)
}

testeVetor=buscaSpLink(sp,caminho="/home/thiagorbm/Documents/testeMover")

NomesCientificos <- read_excel("NomesCientificos.xlsx")
testeTabExcel= buscaSpLink(NomesCientificos$nomeCientifico)
