library(jsonlite)
library(tidyverse)


json <- jsonlite::fromJSON("./Data/config.json")
urls<-json$references$url
file_name<-json$references$file_name
organ_name<-json$references$name


ct=1
list_organ_var<-c()

for (config in file_name){
  
  if (!file.exists(paste('./Data/Original/',file_name[ct],sep='')))
  {
    temp_name=paste(organ_name[ct])
    assign(temp_name,read_csv(urls[ct],skip=10))
    
    list_organ_var=c(list_organ_var,temp_name)
    
    temp_ct_name=paste(organ_name[ct],'_az_id',sep='')
    assign(temp_ct_name,get(temp_name)[grepl("ID", c(colnames(get(temp_name))), ignore.case = T)])
    assign(temp_ct_name,data.frame(ID = c(t(get(temp_ct_name))), stringsAsFactors=FALSE))
    
    
    onto_id<-paste(organ_name[ct],'_az_name',sep='')
    assign(onto_id,get(temp_name)[grepl("^AS/[0-9]$", c(colnames(get(temp_name))), ignore.case = T)])
    assign(onto_id,data.frame(name = c(t(get(onto_id))), stringsAsFactors=FALSE))
    
  }
  else{
    
    temp_name=paste(organ_name[ct])
    assign(temp_name,read_csv(paste('./Data/Original/',file_name[ct],sep=''),skip=10))
    
    list_organ_var=c(list_organ_var,temp_name)
    
    temp_ct_name=paste(organ_name[ct],'_az',sep='')
    assign(temp_ct_name,get(temp_name)[grepl("ID", c(colnames(get(temp_name))), ignore.case = T)])
    assign(temp_ct_name,data.frame(ID = c(t(get(temp_ct_name))), stringsAsFactors=FALSE))
    
    onto_id<-paste(organ_name[ct],'_az_name',sep='')
    assign(onto_id,get(temp_name)[grepl("^AS/[0-9]$", c(colnames(get(temp_name))), ignore.case = T)])
    assign(onto_id,data.frame(name = c(t(get(onto_id))), stringsAsFactors=FALSE))
    
  }
  ct=ct+1
}
rm(ct)
if (!file.exists('./Data/Az/lung_az.csv')){
  for (organ in list_organ_var[1:6]){
    df_1<-get(paste(organ,'_az_id',sep=''))
    df_2<-get(paste(organ,'_az_name',sep=''))
    df<-cbind(df_1,df_2)
    #print(organ)
    write.csv(df, file=paste('./Data/Az/',organ,'_az.csv',sep=''),row.names = FALSE)
  }
  spleen_az_id<-data.frame(ID=rep(NA,times=(nrow(spleen_az_name)-nrow(spleen_az_id))))
  df<-cbind(spleen_az_id,spleen_az_name)
  write.csv(df, file=paste('./Data/Az/spleen_az.csv',sep=''),row.names = FALSE)
}

sid<-json$references$asctb_sid[1]
gid<-json$references$asctb_gid


#sid<-"1tK916JyG5ZSXW_cXfsyZnzXfjyoN-8B2GXLbYD6_vF0"
#gid<-c("1824552484","1044871154","2137043090","1379088218","1845311048","1315753355","984946629")
library(rjson)
list_organ_var<-c("lung","pancreas","kidney","brain","bone_marrow","blood_pmbc","spleen")
val=1

if (!file.exists('./Data/Asctb/lung_asctb.csv')){
      for (val in 1:length(gid)){
      
      BASE_API_URL <- 'https://asctb-api.herokuapp.com/v2/'
      response <- httr::GET(url=paste(paste(BASE_API_URL, sid[1],sep=''),gid[val],sep='/'))
      df<-rawToChar(response$content) %>% jsonlite::fromJSON() %>% with(data) %>% with(cell_types) %>% toJSON() %>% jsonlite::fromJSON() %>% with(id) %>% list()  %>% unlist() %>% as.data.frame
      
      df_2<-rawToChar(response$content) %>% jsonlite::fromJSON() %>% with(data) %>% with(cell_types) %>% toJSON() %>% jsonlite::fromJSON() %>% with(name) %>% list()  %>% unlist() %>% as.data.frame
      
      temp_name=paste(list_organ_var[val],'_ct_asctb',sep='')
      assign(temp_name,df)
      
      temp_name_1=paste(list_organ_var[val],'_name_asctb',sep='')
      assign(temp_name_1,df_2)
      }
      rm(response)
      rm(df)
      

      for (organ in list_organ_var){
        df_1<-get(paste(organ,'_ct_asctb',sep=''))
        df_2<-get(paste(organ,'_name_asctb',sep=''))
        df<-cbind(df_1,df_2)
        colnames(df)<-c("ID", "name")
        write.csv(df, file=paste('./Data/Asctb/',organ,'_asctb.csv',sep=''),row.names = FALSE)
      }
}


