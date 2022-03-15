### USANDO API PARA PEGAR DADOS DO SPLINK
### 
### 
## site aqui: https://api.splink.org.br/

## formato da busca por nome cientifico: https://api.splink.org.br/records/ScientificName/Dioclea%20violacea/json

library(httr)
library(readxl)

##### buscando dados de ocorrências das espécies no SPLink #######


tabelaNomes= read_excel("C:/Users/HP/Google Drive/R/NomesCientificos.xlsx") 
## tabela do excel que tenha uma coluna com nomes cientificos de interesse

caminho= "C:/Users/HP/Desktop/" ## colocar o caminho do diretorio onde quer salvar a tabela do SPlink
nomeTabela= "BuscaAPIsplink.txt" ## colocar o nome que a tabela tera


###### NAO MEXER DAQUI PARA BAIXO 
###### SERÁ AVISADO QUANDO FOR PARA MEXER NOVAMENTE
###### 
###### 
###### 
###### 
###### 

EspeciesSPlink= function(tabela, NomesCientificos){

SPLink = "https://api.splink.org.br/"
Species= "ScientificName/"
csv= "/csv"
Coordenadas= "/Coordinates/yes" ## pegando só o que tem coordenadas
  
Nomes= tabela[[NomesCientificos]]
  

vetorNomes= Nomes %>% 
  gsub(",", "/", ., perl = TRUE) %>% 
  gsub(" ", "%20", ., perl = TRUE)

vetorNomes= paste(vetorNomes, collapse= ",") ## arrumando os nomes para montar a url


urlSPLink= paste0(SPLink,Records,Species,vetorNomes,Coordenadas,csv) ## criando a URL

siteSPLink= httr::POST(urlSPLink, inherits=FALSE) ## fazendo o pedido
informacoesSPLink = httr::content(siteSPLink, encoding = "UTF-8",
                                   type = 'text/tab-separated-values') ## retornando os dados

write.table(informacoesSPLink, paste0(caminho, nomeTabela), sep= "\t",
            fileEncoding = "UTF-16LE", row.names = FALSE, col.names = TRUE) ## salvando o resultado da busca
## no diretorio indicado no começo do script, usando o nome indicado tambem


return(informacoesSPLink)

}


InfoEspecies= EspeciesSPlink(tabelaNomes, "nomeCientifico") 
## substituir "tabelaNomes" pela tabela em que existe a coluna com as especies de interesse (SEM ASPAS)
## substituir "nomeCientifico" com o nome da coluna da tabela em que estão os nomes (COM ASPAS)



