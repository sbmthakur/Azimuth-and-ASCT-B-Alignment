library(dplyr)

json <- jsonlite::fromJSON("./Data/config.json")
organ_name<-json$references$name

aligned_path<-'./Data/Aligned Data/'


if (!file.exists(paste(aligned_path,'lung_aligned.csv',sep='')))
{
    for (organ in organ_name){
      var_as_name<-paste(organ,"_asctb",sep='')
      df_as<-read_csv(paste('./Data/Asctb/',paste(organ,"_asctb.csv",sep=''),sep=''))
      
      
      var_az_name<-paste(organ,"_az",sep='')
      df_az<-read_csv(paste('./Data/Az/',paste(organ,"_az.csv",sep=''),sep=''))
      
      assign(var_as_name,df_as)
      assign(var_az_name,df_az)
      
      var_az_uq_name<-paste(var_az_name,"_unique",sep='')
      assign(var_az_uq_name,unique(df_az))
      
      #var_as_uq_name<-paste(var_as_name,"_unique",sep='')
      #assign(var_as_uq_name,unique(df_as))
    }
    rm(json)
    
    for (organ in organ_name){
      tmp<-paste(organ,'_aligned',sep='')
      
      df_1<-get(paste(organ,'_asctb',sep=''))
      df_2<-get(paste(organ,'_az',sep=''))
      
      assign(tmp,setdiff(df_1,df_2))
    }
    
    for (organ in organ_name){
      df<-get(paste(organ,'_aligned',sep=''))
      write.csv(df, file=paste(aligned_path,paste(organ,'_aligned.csv',sep=''),sep=''),row.names = FALSE)
    }
    
    summary<-data.frame(Organ=c(),Count_Missing_in_AZ=c())
    
    for (organ in organ_name){
      tmp<-paste(organ,'_aligned',sep='')
      t<-c(organ,nrow(get(tmp)))
      summary<-rbind(summary,t)
    }
    colnames(summary)=c('Organ','Count_CT_Missing_in_AZ')
    write.csv(summary, file=paste(aligned_path,'summary.csv',sep=''),row.names = FALSE)
    
}
