### USANDO API PARA PEGAR DADOS DO SPLINK
### 
### 
## site aqui: https://api.splink.org.br/

## formato da busca por nome cientifico: https://api.splink.org.br/records/ScientificName/Dioclea%20violacea/json

library(httr)


##### buscando dados de ocorr�ncias das esp�cies no SPLink #######
SPLink = "https://api.splink.org.br/"
Records= "records/"
Genero= "Genus/"
Species= "ScientificName/"
json= "/json"
tab= "/tab"
xml= "/xml"
csv= "/csv"
Coordenadas= "/Coordinates/yes" ## pegando s� o que tem coordenadas


nomesCientificos= c('Dioclea violacea, Mabea fistulifera, Hancornia speciosa') ## exemplo: rode essa linha
## sem alterar


Nomes= function (Nomes) {
  Nomes= gsub(",", "/", Nomes, perl = TRUE)
  Nomes= gsub(" ", "%20", Nomes, perl = TRUE)
  
} ## arrumando os nomes para montar a url

vetorNomes= Nomes(nomesCientificos)


urlSPLink= paste0(SPLink,Records,Species,vetorNomes,Coordenadas,csv) ## criando a URL
siteSPLink= httr::POST(urlSPLink, inherits=FALSE) ## fazendo o pedido
informacoesSPLink2 = httr::content(siteSPLink, encoding = "UTF-8",
                                   type = 'text/tab-separated-values') ## retornando os dados


write.table(informacoesSPLink2, "C:/Users/HP/Desktop/SPlinkTeste.txt", sep= "\t",
            fileEncoding = "UTF-16LE", row.names = FALSE, col.names = TRUE)

