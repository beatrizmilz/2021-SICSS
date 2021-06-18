# instalar o pacote do fragile families
# devtools::install_github("fragilefamilieschallenge/ffmetadata")
# ffmetadata::search_metadata(background_raw)

background_raw <- haven::read_dta("atividades/day_5/ffchallenge_SICSS_2021/FFChallenge_v5/background.dta")

train <- readr::read_csv("atividades/day_5/ffchallenge_SICSS_2021/FFChallenge_v5/train.csv")

naniar::miss_var_summary(train)

> naniar::miss_var_summary(train)
# # A tibble: 7 x 3
# variable           n_miss    pct_miss
# <chr>                <int>    <dbl>
# 1 gpa                 956     45.1
# 2 layoff              844     39.8
# 3 grit                703     33.1
# 4 materialHardship    662     31.2
# 5 eviction            662     31.2
# 6 jobTraining         660     31.1
# 7 challengeID           0      0  
  
dados_unidos <- dplyr::left_join(train, background_raw, by = "challengeID")

library(magrittr)

# correlacao ------------

corr <- round(cor(expl, use = "complete.obs"), 2)

p.mat <- ggcorrplot::cor_pmat(corr)


corr.plot <- ggcorrplot::ggcorrplot(
  corr, hc.order = TRUE, type = "lower", outline.col = "white",
  p.mat = p.mat
)
corr.plot




# qual variavel Y queremos? qual variavel queremos prever?
# gpa !

# qual variaveis X queremos?






# selecionar variaveis

dados_unidos %>% 
  dplyr::select(challengeID, gpa) %>% 
  tidyr::drop_na(gpa)




