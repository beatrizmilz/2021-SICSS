
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Day 3: Automated Text Analysis

## Pre-arrival

-   Materiais disponíveis em: <https://sicss.io/curriculum>

### An Introduction to Text Analysis

-   Análise de texto quantitativa; de forma automatizada e usando uma
    grande quantidade de dados.

-   História: registros mais antigos indicam que foi usado para estudar
    propaganda na primeira guerra mundial. Foi similar ao que conhecemos
    como uma análise de conteúdo.

-   Leituras recomendadas:

    -   [ ] [Text as Data: The Promise and Pitfalls of Automatic Content
        Analysis Methods for Political
        Texts](https://www.cambridge.org/core/journals/political-analysis/article/text-as-data-the-promise-and-pitfalls-of-automatic-content-analysis-methods-for-political-texts/F7AAC8B2909441603FEB25C156448F20)

    -   [ ] [Machine Translation: Mining Text for Social
        Theory](https://www.annualreviews.org/doi/abs/10.1146/annurev-soc-081715-074206)

### Text Analysis Basics

-   Encoding dos caracteres: o uso de diferentes encodings muda com o
    tempo, entre os sistemas operacionais, etc. O uso de UTF-8 tem
    crescido!

-   GREP: Globally search a regular expression and print

-   Expressões regulares (Regular expressions, ou RegEx): padrões que
    descrevem um conjunto de strings

``` r
duke_web_scrape <- "Duke Experts: A Trusted Source for Policymakers\n\n\t\t\t\t\t\t"

# verificar se uma palavra está no texto
# R base
grepl("Experts", duke_web_scrape)
#> [1] TRUE
# tidyverse
stringr::str_detect(duke_web_scrape, "Experts")
#> [1] TRUE

# Substituir \t por nada
# R base
gsub("\t", "", duke_web_scrape)
#> [1] "Duke Experts: A Trusted Source for Policymakers\n\n"
# tidyverse
stringr::str_replace_all(duke_web_scrape, "\t", "")
#> [1] "Duke Experts: A Trusted Source for Policymakers\n\n"

# Substituir \t e \n por nada
# R base
gsub("\t|\n", "", duke_web_scrape)
#> [1] "Duke Experts: A Trusted Source for Policymakers"
# tidyverse
stringr::str_replace_all(duke_web_scrape, "\t|\n", "")
#> [1] "Duke Experts: A Trusted Source for Policymakers"
```

-   More GREP!

``` r
library(magrittr, include.only = "%>%")
some_text <- c("Friends", "don't", "let", "friends", "make", "wordclouds")

# buscar todas as palavras que iniciam com
# F maiúsculo
# R Base
some_text[grep("^[F]", some_text)]
#> [1] "Friends"
# tidyverse (é melhor se for trabalhar com dfs)
some_text %>%
  tibble::as_tibble() %>%
  dplyr::filter(stringr::str_detect(value, "^[F]"))
#> # A tibble: 1 x 1
#>   value  
#>   <chr>  
#> 1 Friends
```

-   [Cheat sheet
    RegEx](https://github.com/rstudio/cheatsheets/raw/master/regex.pdf)

-   [Cheat sheet
    stringr](https://evoldyn.gitlab.io/evomics-2018/ref-sheets/R_strings.pdf)

-   Escaping text - com a barra invertida!

``` r
text_chunk <- c("[This Professor is not so Great]")

# não funciona
# gsub("[", "", text_chunk)

# funciona - base R
gsub("\\[|\\]", "", text_chunk)
#> [1] "This Professor is not so Great"

# versão tidyverse
stringr::str_replace_all(text_chunk,"\\[|\\]", "")
#> [1] "This Professor is not so Great"
```

-   **Unidades de análise**: o que vai contar como uma palavra?

-   Tokenization: o mais comum é tokenizar por palavras. Também é
    possível tokenizar por N-grams: sequências de palavras de
    comprimento N. Exemplos:

    -   N = 1 - Unigrams - this, is, a, sentence

    -   N = 2 - Bigrams - this is, is a, a sentence

    -   N = 3 - Trigrams - this is a, is a sentence

-   Criando bases de dados textuais: costumamos trabalhar com um grande
    grupo de documentos (como livros, artigos de jornais, tweets, etc)

``` r
load(url("https://cbail.github.io/Trump_Tweets.Rdata"))

trumptweets$text[1]
#> [1] "Just met with UN Secretary-General António Guterres who is working hard to “Make the United Nations Great Again.” When the UN does more to solve conflicts around the world, it means the U.S. has less to do and we save money. @NikkiHaley is doing a fantastic job! https://t.co/pqUv6cyH2z"
```

-   Criar um “corpus style document”: preservar o conteúdo e os
    metadados.

``` r
# install.packages("tm")

trump_corpus <- tm::Corpus(tm::VectorSource(as.vector(trumptweets$text)))

trump_corpus
#> <<SimpleCorpus>>
#> Metadata:  corpus specific: 1, document level (indexed): 0
#> Content:  documents: 3196
```

-   Outra abordagem: tidytext!

``` r
tidy_trump_tweets <- trumptweets %>% 
  dplyr::select(created_at, text) %>% 
  tidytext::unnest_tokens("word", text)

tidy_trump_tweets %>% 
  head() %>% 
  knitr::kable()
```

| created\_at         | word      |
|:--------------------|:----------|
| 2018-05-18 20:41:21 | just      |
| 2018-05-18 20:41:21 | met       |
| 2018-05-18 20:41:21 | with      |
| 2018-05-18 20:41:21 | un        |
| 2018-05-18 20:41:21 | secretary |
| 2018-05-18 20:41:21 | general   |

``` r
tidy_trump_tweets %>% 
  dplyr::count(word, sort = TRUE)
#> # A tibble: 8,690 x 2
#>    word      n
#>    <chr> <int>
#>  1 the    3671
#>  2 to     2216
#>  3 and    1959
#>  4 of     1606
#>  5 https  1281
#>  6 t.co   1258
#>  7 a      1248
#>  8 in     1213
#>  9 is     1045
#> 10 for     886
#> # … with 8,680 more rows
```

-   **Pré-processamento de texto**

-   Stopwords: palavras que não adicionam significado para o texto. É
    comum remover as stopwords das análises.

``` r
tidy_trump_tweets_without_stop_words <- 
  tidy_trump_tweets %>% 
  dplyr::anti_join(tidytext::stop_words)
#> Joining, by = "word"

tidy_trump_tweets_without_stop_words  %>% 
  dplyr::count(word, sort = TRUE)
#> # A tibble: 8,121 x 2
#>    word          n
#>    <chr>     <int>
#>  1 https      1281
#>  2 t.co       1258
#>  3 amp         562
#>  4 rt          351
#>  5 people      302
#>  6 news        271
#>  7 president   235
#>  8 fake        234
#>  9 trump       218
#> 10 country     213
#> # … with 8,111 more rows
```

-   Limpar o texto: ele mostrou com R Base, estou fazendo com tidyverse

``` r
tidy_trump_tweets_filtered <-
  tidy_trump_tweets_without_stop_words %>%
  dplyr::mutate(
    # remover números
    word = tm::removeNumbers(word),
    
    # substituir vírgula e ponto por nada
    word = stringr::str_replace_all(word, ",|\\.", ""),
    
    # transformar em minusculas
    word = stringr::str_to_lower(word),
    
    # Remover espaços desnecessários
    word = stringr::str_trim(word),
    
    # transformar strings vazias em NA
    word = dplyr::if_else(word == "", NA_character_, word)
    
  ) %>%
  tidyr::drop_na(word)
```

-   Stemização: reduzir cada palavra para sua forma mais básica, para
    fazer a análise

``` r
tidy_trump_tweets_stem <- tidy_trump_tweets_filtered %>%
  dplyr::mutate(word = SnowballC::wordStem(words = word, language = "en"))

tidy_trump_tweets_stem  %>% 
  dplyr::count(word, sort = TRUE)
#> # A tibble: 6,193 x 2
#>    word        n
#>    <chr>   <int>
#>  1 https    1281
#>  2 tco      1258
#>  3 amp       562
#>  4 rt        351
#>  5 peopl     303
#>  6 news      271
#>  7 job       261
#>  8 presid    251
#>  9 countri   247
#> 10 tax       241
#> # … with 6,183 more rows
```

-   Matriz: document-term matrix

``` r
tidy_trump_tweets_stem %>% 
  dplyr::count(created_at, word) %>% 
  tidytext::cast_dtm(created_at, word, n)
#> <<DocumentTermMatrix (documents: 3191, terms: 6193)>>
#> Non-/sparse entries: 36583/19725280
#> Sparsity           : 100%
#> Maximal term length: 29
#> Weighting          : term frequency (tf)
```

> Livro [Text Mining with R - A Tidy
> approach](https://www.tidytextmining.com/)

> Livro [Speech and Language
> Processing](https://web.stanford.edu/~jurafsky/slp3/)

### Dictionary-Based Text Analysis

### Topic Models

### Text Networks
