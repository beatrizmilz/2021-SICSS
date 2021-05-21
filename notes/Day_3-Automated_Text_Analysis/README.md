
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
  dplyr::anti_join(tidytext::stop_words) %>% 
  dplyr::filter(!word %in% c("https", "rt", "t.co", "amp"))
#> Joining, by = "word"

tidy_trump_tweets_without_stop_words  %>% 
  dplyr::count(word, sort = TRUE)
#> # A tibble: 8,117 x 2
#>    word          n
#>    <chr>     <int>
#>  1 people      302
#>  2 news        271
#>  3 president   235
#>  4 fake        234
#>  5 trump       218
#>  6 country     213
#>  7 america     204
#>  8 tax         190
#>  9 u.s         186
#> 10 time        173
#> # … with 8,107 more rows
```

-   Limpar o texto: ele mostrou com R Base, estou fazendo com tidyverse

``` r
tidy_trump_tweets_filtered <-
  tidy_trump_tweets_without_stop_words %>% 
  dplyr::mutate(
    # remover números
    word = tm::removeNumbers(word), 
    # word =  gsub("\\d+", "", word), #opcao sem tm
    
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
#> # A tibble: 6,189 x 2
#>    word         n
#>    <chr>    <int>
#>  1 peopl      303
#>  2 news       271
#>  3 job        261
#>  4 presid     251
#>  5 countri    247
#>  6 tax        241
#>  7 fake       234
#>  8 trump      227
#>  9 american   222
#> 10 america    214
#> # … with 6,179 more rows
```

-   Matriz: document-term matrix

``` r
tidy_trump_tweets_stem %>% 
  dplyr::count(created_at, word) %>% 
  tidytext::cast_dtm(created_at, word, n)
#> <<DocumentTermMatrix (documents: 3191, terms: 6189)>>
#> Non-/sparse entries: 33678/19715421
#> Sparsity           : 100%
#> Maximal term length: 29
#> Weighting          : term frequency (tf)
```

> Livro [Text Mining with R - A Tidy
> approach](https://www.tidytextmining.com/)

> Livro [Speech and Language
> Processing](https://web.stanford.edu/~jurafsky/slp3/)

### Dictionary-Based Text Analysis

-   Formas sofisticadas de contagem de palavras, associadas com algum
    lexicon (ou grupo de palavras) que contém algum tipo de significado.

``` r
top_words <- tidy_trump_tweets_filtered %>% 
    dplyr::count(word, sort = TRUE)


# EDIT: MOMENTO EM QUE INSTALEI O R 4.1.0!
# a partir deste ponto pode ser que o pipe nativo seja usado.



top_words |>
  dplyr::slice(1:20) |>
  dplyr::mutate(word = forcats::fct_reorder(word, n)) |> 
  ggplot2::ggplot() +
  ggplot2::geom_col(ggplot2::aes(
    x = word,
    y = n,
    fill = word
  )) +
  ggplot2::scale_fill_viridis_d(direction = -1) +
  ggplot2::coord_flip() +
  ggplot2::theme_minimal() +
  ggplot2::guides(fill = FALSE) +
  ggplot2::labs(y = "Frequência", x = "Palavras", title = "Palavras mais frequentes nos tweets do Trump") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5, size = 18))
```

<img src="README_files/figure-gfm/unnamed-chunk-13-1.png" style="display: block; margin: auto;" />

-   Term frequency inverse document frequency (tf-idf) (isso não tá
    claro pra mim ainda)
    -   Inverse document frequency (IDF): Give more weight to a term
        occurring in less documents.
    -   Função `bind_ft_idf()`

``` r
trump_tf_idf <- tidy_trump_tweets_filtered |> 
  dplyr::count(word, created_at) |>
  tidytext::bind_tf_idf(word, created_at, n) |>
  dplyr::arrange(desc(tf_idf))

trump_tf_idf |> head(10) |> knitr::kable()
```

| word              | created\_at         |   n |  tf |      idf |  tf\_idf |
|:------------------|:--------------------|----:|----:|---------:|---------:|
| eqmwvxbim         | 2017-11-15 10:58:18 |   1 |   1 | 8.068090 | 8.068090 |
| hlzrlkif          | 2017-09-22 10:30:06 |   1 |   1 | 8.068090 | 8.068090 |
| tdrycwnc          | 2017-11-12 14:29:22 |   1 |   1 | 8.068090 | 8.068090 |
| umyjluid          | 2018-03-30 20:24:56 |   1 |   1 | 8.068090 | 8.068090 |
| vlqyalcto         | 2018-04-14 01:31:56 |   1 |   1 | 8.068090 | 8.068090 |
| vsmnwxtei         | 2017-09-17 11:57:20 |   1 |   1 | 8.068090 | 8.068090 |
| ymuqsvvtsb        | 2017-10-05 10:46:02 |   1 |   1 | 8.068090 | 8.068090 |
| yqxoaufd          | 2018-03-06 13:05:34 |   1 |   1 | 8.068090 | 8.068090 |
| standforouranthem | 2017-09-25 13:02:27 |   1 |   1 | 6.969477 | 6.969477 |
| karen             | 2017-06-21 02:21:36 |   1 |   1 | 6.122179 | 6.122179 |

Criando um dicionário relacionado a um tema. Ex:

``` r
economic_dictionary <- c("economy", "unemployment", "trade", "tariffs")

economic_tweets <- trumptweets |> 
  dplyr::filter(stringr::str_detect(string = text, pattern =  economic_dictionary))

head(economic_tweets$text, 2)
#> [1] "Great talk with my friend President Mauricio Macri of Argentina this week. He is doing such a good job for Argentina. I support his vision for transforming his country’s economy and unleashing its potential!"                                                         
#> [2] "The Washington Post and CNN have typically written false stories about our trade negotiations with China. Nothing has happened with ZTE except as it pertains to the larger trade deal. Our country has been losing hundreds of billions of dollars a year with China..."
```

-   Análise de sentimento: porcentagem de palavras negativas e
    positivas.

``` r
head(tidytext::get_sentiments(lexicon = "bing"))
#> # A tibble: 6 x 2
#>   word       sentiment
#>   <chr>      <chr>    
#> 1 2-faces    negative 
#> 2 abnormal   negative 
#> 3 abolish    negative 
#> 4 abominable negative 
#> 5 abominably negative 
#> 6 abominate  negative
```

``` r
trump_tweet_sentiment <- tidy_trump_tweets_filtered |> 
  dplyr::inner_join(tidytext::get_sentiments(lexicon = "bing")) |> 
  dplyr::count(created_at, sentiment)
#> Joining, by = "word"

head(trump_tweet_sentiment)
#> # A tibble: 6 x 3
#>   created_at          sentiment     n
#>   <dttm>              <chr>     <int>
#> 1 2017-02-05 22:49:42 positive      1
#> 2 2017-02-06 03:36:54 positive      4
#> 3 2017-02-06 12:01:53 negative      2
#> 4 2017-02-06 12:07:55 negative      2
#> 5 2017-02-06 16:32:24 negative      3
#> 6 2017-02-06 23:33:52 positive      2
```

``` r
trump_tweet_sentiment |> 
  dplyr::mutate(date = lubridate::floor_date(created_at, "day"))   |> 
  dplyr::filter(sentiment == "negative") |> 
  dplyr::count(date, sentiment) |> 
  ggplot2::ggplot() +
  ggplot2::geom_line(ggplot2::aes(x = date, y = n), color = "red", size = 0.5) +
  ggplot2::theme_minimal() + 
  ggplot2::labs(x = "Data", y = "Número de palavras negativas", title = "Sentimentos negativos nos tweets do Trump") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5, size = 18))
```

<img src="README_files/figure-gfm/unnamed-chunk-18-1.png" style="display: block; margin: auto;" />

-   Quem decide o que é uma palavra negativa ou positiva? Quem criou o
    dicionário!

-   Coisas como sarcasmo, ironia: são difíceis de detectar nesse tipo de
    análise.

-   Quando escolher um dicionário, escolher algo que tenha entendimentos
    similares ao meu. Diferentes dicionários tem melhores performances
    em diferentes contextos.

-   B: Em português, conheço esse pacote de análise de sentimentos:

``` r
# devtools::install_github("sillasgonzaga/lexiconPT")
library(lexiconPT)
# carregando os dicionários
data("sentiLex_lem_PT02")
data("oplexicon_v2.1")
data("oplexicon_v3.0")

lexiconPT::get_word_sentiment("temer")
#> $oplexicon_v2.1
#>        term type polarity
#> 28711 temer   vb        1
#> 
#> $oplexicon_v3.0
#>        term type polarity polarity_revision
#> 30160 temer   vb        1                 A
#> 
#> $sentilex
#>       term grammar_category polarity polarity_target polarity_classification
#> 6546 temer                V       -1           N0:N1                     MAN

lexiconPT::get_word_sentiment("bolsonaro")
#> $oplexicon_v2.1
#> [1] "Word not present in dataset"
#> 
#> $oplexicon_v3.0
#> [1] "Word not present in dataset"
#> 
#> $sentilex
#> [1] "Word not present in dataset"
```

-   Linguistic inquiry word count (LIWC) - é popular, mas imperfeito.

-   Quando usar dictionary-based analises? depende! Se sabemos
    concretamente o que vamos procurar nos dados, e temos uma lista de
    palavras, pode ser uma boa idea. Se não, podemos usar os métodos não
    supervisionados. Também é possível fazer com métodos híbridos :)

EDIT: Fernando Correa comentou desse pacote:
[spacyr](https://cran.r-project.org/web/packages/spacyr/vignettes/using_spacyr.html).
Julio Trecenti comentou sobre o
[BERT](https://github.com/neuralmind-ai/portuguese-bert) (em Python).

### Topic Models

-   Técnicas para identificar temas latentes em um corpus (grupo de
    arquivos de texto que estamos usando).

    -   Leituras amplificadas!

    -   A técnica não diz para nós quantos tópicos estão presentes no
        corpus, nós precisamos informar isso para a técnica.

    -   O resultado da técnica é: 1) uma lista de cada palavra associada
        a um tópico, e 2) relação de cada documento para cada tópico.

    -   Document-term matrix: representação de um corpus em formato de
        matriz, as linhas representam documentos, e as colunas são
        qualquer palavra que aparece no corpus. As células da matrix
        contam quantas vezes cada palavra aparece em cada documento.

``` r
library(topicmodels)
library(tm)
#> Loading required package: NLP
data("AssociatedPress")
tm::inspect(AssociatedPress[1:5,1:5])
#> <<DocumentTermMatrix (documents: 5, terms: 5)>>
#> Non-/sparse entries: 0/25
#> Sparsity           : 100%
#> Maximal term length: 10
#> Weighting          : term frequency (tf)
#> Sample             :
#>       Terms
#> Docs   aaron abandon abandoned abandoning abbott
#>   [1,]     0       0         0          0      0
#>   [2,]     0       0         0          0      0
#>   [3,]     0       0         0          0      0
#>   [4,]     0       0         0          0      0
#>   [5,]     0       0         0          0      0

dim(AssociatedPress)[1] # número de linhas (neste caso, representam documentos)
#> [1] 2246
dim(AssociatedPress)[2] # número de colunas (neste caso, representam palavras)
#> [1] 10473
```

-   A primeira vez que realizamos o topic model, costuma estar errado.
    Vamos testar com 10 tópicos! Depois podemos repetir e testar. Nada
    substitui a validação feita por seres humanos.

``` r
ap_topic_model <- topicmodels::LDA(AssociatedPress, # mariz que usaremos
                                   k = 10, # numero de topicos  
                                   control = list(seed = 321) # isso é importante para que a análise seja reprodutível 
                                   # (obtenha o mesmo resultado cada vez que executar a função)
                                    )
```

``` r
ap_topis <- tidytext::tidy(ap_topic_model, matrix = "beta")

ap_top_terms <- ap_topis |> 
  dplyr::group_by(topic) |> 
  dplyr::top_n(10, beta) |> 
  dplyr::ungroup() |> 
  dplyr::arrange(topic, -beta)

ap_top_terms |> 
  dplyr::mutate(term = forcats::fct_reorder(term, beta),
                topic = paste("Topic #", topic)) |> 
  ggplot2::ggplot() +
  ggplot2::geom_col(ggplot2::aes(x = term, y = beta, fill = factor(topic)), show.legend = FALSE) + 
  ggplot2::facet_wrap(~ topic, scales = "free") + 
  ggplot2::theme_minimal() + 
  ggplot2::coord_flip() +
  ggplot2::labs(title = "Topic Model of AP News Articles",
                caption = "Top terms by topic (betas)",
                y = "Betas", x = "Term")+
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5, size = 18),
                 axis.text.x =  ggplot2::element_text(size = 6),
                 axis.text.y =  ggplot2::element_text(size = 6))
```

<img src="README_files/figure-gfm/unnamed-chunk-22-1.png" style="display: block; margin: auto;" />

-   O que pode ser um tópico?? Depende em como definimos as coisas.

-   Resistir à denteção de deixar a técnica fazer tudo.

-   Structural topic modeling: similar ao LDA, mas explora metadados de
    um arquivo para melhorar a classificação de tópicos em um corpus.
    Ajuda a entender melhor o resultado.

``` r
google_doc_id <- "1LcX-JnpGB0lU1iDnXnxB6WFqBywUKpew" # google file ID
poliblogs <-
  read.csv(
    sprintf(
      "https://docs.google.com/uc?id=%s&export=download",
      google_doc_id 
    ),
    stringsAsFactors = FALSE
  )

head(poliblogs)
#>   X
#> 1 1
#> 2 2
#> 3 3
#> 4 4
#> 5 5
#> 6 6
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           documents
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             After a week of false statements, lies, and dismissive apologies, Pakistani President Pervez Musharraf now says that he is disatisfied with the probe into former Prime Minister Benazir Bhutto's death and is asking Scotland Yard for help:"One should not give a statement that's 100 percent final. That's the flaw that we suffer from," Musharraf said at a news conference, noting that more evidence was emerging about the attack. "We needed more experience, maybe more forensic and technical experience that our people don't have. Therefore I thought Scotland Yard may be more helpful." Musharraf said he also reached out to British investigators for assistance to dispel accusations that Pakistan's military or intelligence services were involved. "We don't mind going to any extent, as nobody is involved from the government or agency side," he said. Speaking a week after Bhutto's assassination in a shooting and suicide bombing, Musharraf denied there had been a security lapse and implied that Bhutto, who was greeting supporters through the sunroof of her armored vehicle at the time of the attack, was partly responsible. "Who is to be blamed for her coming out (of) her vehicle?" he asked, adding that others in the vehicle had not been hurt in the attack.When in doubt, blame the victim.Reports in the immediate aftermath of the bombing said that as far back as November, Bhutto believed Musharraf was deliberately withholding security forces that could have made her safer. Unless he feared Bhutto more than the street riotors, I doubt whether that was really true. More likely, he didn't trust the army to protect her. And when she requested that Musharraf allow her to use western private security firms, he refused.I don't think Musharraf wanted Bhutto dead. But I think he is just too weak and indecisive to have done what was needed to protect her.
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       I honestly don't know how either party's caucus results will play out tonight. Usually, you can get a good idea of perhaps not a winner but at least you can figure out who's up, who's down, and who's on life support.Not with the Iowa Caucuses. Races in both parties are just too close to call. So many variables. So much volatility among the voters. And the polls are whacky.As an example, here are the final two polls out on Iowa. First, ARG:Mike Huckabee 29% (23%) Mitt Romney 24% (32%) Fred Thompson 13% (7%) John McCain 11% (11%) Rudy Giuliani 8% (6%) Ron Paul 6% (6%) Duncan Hunter 4% (2%) Undecided 4% (11%) (Number in parentheses is from ARG survey taken last week)The spread between Huckabee and Romney is the margin of error which means they are virtually tied. Note Thompson's huge bump. Is he surging? Many think so although he probably doesn't have enough juice to catch either front runner for second place. But a strong third sends him along the campaign trail - despite what you might have heard about him dropping out. (Fred and his staff are denying the filthy rumor every chance they get.)Meanwhile, Zogby's daily tracking poll (three day rolling average) tells a little different story:* Huckabee - 31%* Romney - 25%* Thompson - 11%*McCain -10%Here the Huckster opens up a slight lead on Romney with Thompson and McCain far back in the pack.On the Democratic side, Obama has sprinted into the lead:Democrat Barack Obama continued his upward momentum through the evening before the Iowa caucuses, capturing the lead ahead of rivals John Edwards and Hillary Clinton.. Meanwhile, Republican Mike Hucakbee widened his lead over Mitt Romney down the stretch, the newest and last Reuters/C–SPAN/Zogby daily telephone tracking poll in Iowa shows. Obama broke through the 30% barrier for the first time, gaining 31% support after another strong day leading up to the caucuses. But more dramatic was Clinton’s four-point drop in this last day of tracking. Edwards moved into second place by himself after another day where he steadily gained ground. This fifth and final daily tracking poll was conducted using live telephone operators in the Zogby call center in Upstate New York. Edwards finished this Zogby daily tracking in Iowa in the same place as four years ago, when Zogby correctly identified the finishing order of the candidates in that caucus.Hillary Clinton has been playing down her chances the last 48 hours and could very well finish 3rd.All of this matters little in the end. The process of caucusing is complicated for the Democrats and it is possible for any of the top three candidates to win or come in third.We'll see by midnight tonight central time.
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                While we stand in awe of the willingness of our troops in Iraq to sacrifice themselves for the Nation, the fewer that are required to do so, the better.  And the news on that front is good.  As can be seen in the chart below, our military deaths in December dropped to 23 from 37 in November.  December deaths are down over 80% (82%) from May's peak this year of 126.  Assuming this reflects a permanent change in the correlation of forces in Iraq - and it is likely that it does, although we cannot be certain of it - it reflects a tremendous achievement on the part of General Petraeus, since this is the result not of retreating from our objectives in Iraq but of advancing toward them - of executing the mission.What of Iraqi deaths?  Iraqi security forces and civilian fatalities are also down in December from November. Iraqi deaths are down only by a small amount - from 560 in November to 534 in December, although that difference is not small if you are one of the ones who are now still alive.  And the decline from this year's peak in February of 3,014 is a drop of 82%(!).Are we out of the woods in Iraq?  It would seem not.  We have General Odierno's estremely disturbing cri de coeur  at the end of November, which we can assume was endorsed by his chief, General Petraeus.  So far as we know, General Odierno's point "A window of opportunity has opened for the government to reach out to its former foes, said Army Lt. Gen. Raymond T. Odierno, the commander of day-to-day U.S. military operations in Iraq, but ‘it's unclear how long that window is going to be open.'"has not been resolved.  While some economic indicators, such as the Iraq Stock Exchange and the value of the Iraqi dinar, are showing real strength, the status of the estimated 4 million internal and external refugees remains open, as does the high unemployment rate, estimated at over 40%.  But the fatalities figures are good news on the war-fighting front and we don't want to miss them.  Success doesn't always announce itself.   It's important not to miss it when it is achieved.
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      These pages recently said goodbye to global warming.  Ironically, the current spell of global warming, such as it is, can be expected to end just as the Kyoto treaty ends in 2012, but having nothing to do with reduced emissions from fossil fuels.  For the remainder of this century, it will be global cooling we'll have to worry about, according to highly credentialed Russian scientist, Dr. Oleg Sorokhtin.Dr. Sorokhtin, Merited Scientist of Russia and fellow of the Russian Academy of Natural Sciences, is staff researcher of the Oceanology Institute.  He explains the recent warming as a natural trend."Earth is now at the peak of one of its passing warm spells. It started in the 17th century when there was no industrial influence on the climate to speak of and no such thing as the hothouse effect. The current warming is evidently a natural process and utterly independent of hothouse gases."So what will happen in the future?"Astrophysics knows two solar activity cycles, of 11 and 200 years. Both are caused by changes in the radius and area of the irradiating solar surface. The latest data, obtained by Habibullah Abdusamatov, head of the Pulkovo Observatory space research laboratory, say that Earth has passed the peak of its warmer period, and a fairly cold spell will set in quite soon, by 2012. Real cold will come when solar activity reaches its minimum, by 2041, and will last for 50-60 years or even longer."Physical and mathematical calculations predict a new Ice Age. It will come in 100,000 years, at the earliest, and will be much worse than the previous. Europe will be ice-bound, with glaciers reaching south of Moscow."The high standing of Dr. Sorkhtin and the inherent plausibility of his argument that climate will continue to follow the same basic causal factor, solar activity, make this another heavy blow to the heavy breathing of the global warming alarmists, who insist there is no argument at all.
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             A US report shows how the enemy controlled the information on the battlefield in Fallujah and used this to force the US and Iraqi forces out, in the first battle there. The Belmont Club points out UPI coverage of the report by Shaun Waterman. Here is how the enemy worked: First they kidnapped reporters from major Western news sources, driving them out of the city, and leaving only Al Jazeera, Al Arabiya and local stringers controlled by the enemy as the sole sources of news. When the US returned with many embedded journalists and cut the enemy's information monopoly we won.These figures demonstrate how the insurgency purposely drove the press from the field to recreate the information monopoly they found so advantageous in the opening days of the First Fallujah, when only journalists from Al Jazeera and Al Arabiya were reporting from the scene. The kidnapping campaign compelled news outlets to rely on stringers who could then be controlled by the insurgency and who could be counted on to miraculously stumble on photo opportunities showing insurgents in action, such as the Pulitzer Prize winning photograph of an Iraqi election worker being killed on Haifa Street. The effective riposte again turned out to be finding ways to break the reportorial stranglehold the enemy had established. The information blockade runners turned out to be bloggers and journalists embedded in the military, of whom Michael Yon is perhaps the most famous. The Iraqi bloggers were protected by their anonymity and the embedded journalists were protected by coalition troops. These reporters outflanked the wall of "access journalism" which was gradually restricting the majors and created alternative sources of reportage. Although few in number these blockade runners played a pivotal role in penetrating the "bodyguard of lies" with which al-Qaeda and the Sunni insurgency had surrounded itself.
#> 6 Mike Huckabee is pretty slick. He's the one Republican who's been boosted by the big media. Those media headlines got him off to a fast start. But a couple of days ago he got the press laughing at his shenanigans with his "I'm NOT negative!" press conference. "Mike Huckabee said Monday he wouldn't run a TV ad he'd prepared blistering Republican rival Mitt Romney as dishonest. Then he showed it to a room packed with reporters and cameramen."  So Huckabee is talking to a giant media fest with dozens of TV cameras, surrounded by five anti-Mitt posters.  But he's very come-to-Jesus about it. You see, he's not actually going to run that negative ad on Mitt, because he's a good person. And just to show the press that he had the negative ad all ready to run, he'll tell them all the Mitt criticisms he's not going to put on TV. "We have run it positive. We have gotten here by being positive."   Even the reporters laughed it up.  So Huckabee tried to get his negative ad out for free, and still got to claim that he was being positive. Is that slick or what? It's like the guy whose wife tells him he sounds angry, and he screams at her, "I'm NOT MAD!!" A lot of people like Huckabee in person, but he looks like a basically angry man to me. At his pheasant hunting press show he ended up shooting his 20-gauge shotgun over the heads of the onlookers. That's just lousy firearms safety, as any hunter knows.  But Huck wasn't sorry. He said it was his way of telling Mitt Romney just "don't get in my way." The press asked him if he really meant to say that, and he just said it again. He did mean it. You just don't do that in a presidential primary. This isn't High Noon in Dodge City. Blasting your shotgun over the heads of the press looks like an impulsive action, by a man who allows his anger to take over his judgment. This is the same guy who's written a book called, "Kids who kill: Confronting Our Culture of Violence."  But he didn't set a good example by shooting off his shotgun over people's heads. Huck's not a conservative but a populist politician, like Bill Clinton and Jimmy Carter.  "I'm out to change the Republican Party" is his way of saying it. But then he calls himself a  conservative.  Huckabee isn't good on foreign policy, so he makes really basic mistakes. His advisors just say "he wasn't briefed" on things like Pakistan and the assassination of Bhutto. The trouble is that a president can't just brush up on this dangerous world when some headline story comes up. He's got to be ahead of the curve. A US president should know that Pakistan has been at the center of the war on terror since before 9/11/01, when  the Taliban  sheltered Osama Bin Laden. Pakistan's intelligence service set up the Taliban in the first place. Today it looks like the same AQ-Taliban goons killed Benazir Bhutto.  This can't be news to a presidential candidate. And that's only Pakistan: What about Russia, China, the Middle East? It's just not good enough. America can't settle for a politician who's not up to speed, and who violates firearms safety rules to send a political message. We can't afford a politician who plays the liberal media against the conservative base. Let's leave the slicksters to the Democrats. We have better candidates. James Lewis blogs at dangeroustimes.wordpress.com/
#>            docname       rating day blog
#> 1 at0800300_1.text Conservative   3   at
#> 2 at0800300_2.text Conservative   3   at
#> 3 at0800300_3.text Conservative   3   at
#> 4 at0800300_4.text Conservative   3   at
#> 5 at0800300_5.text Conservative   3   at
#> 6 at0800300_6.text Conservative   3   at
```

``` r
# estou com problema com esse pacote no R 4.1.0
# library(stm)
# processed <- stm::textProcessor(poliblogs$documents, metadata = poliblogs)
# out <-  stm::prepDocuments(processed$documents, processed$vocab, processed$meta)
# docs <- out$documents
# vocab <- out$vocab
# meta <-out$meta

# First_STM <- stm::stm(documents = out$documents, vocab = out$vocab,
#               K = 10, prevalence =~ rating + s(day) ,
#               max.em.its = 75, data = out$meta,
#               init.type = "Spectral", verbose = FALSE)

# plot(First_STM)

# stm::findThoughts(First_STM, texts = poliblogs$documents,
#      n = 2, topics = 3)

# findingk <- stm::searchK(out$documents, out$vocab, K = c(10:30),
#  prevalence =~ rating + s(day), data = meta, verbose=FALSE)

# plot(findingk)
```

-   Trabalhando com metadados: não é porque temos algum metadado, que
    significa que ele deva ser incluido na stm.

``` r
# predict_topics<-estimateEffect(formula = 1:10 ~ rating + s(day), stmobj = First_STM, metadata = out$meta, uncertainty = "Global")
# 
# plot(predict_topics, covariate = "rating", topics = c(3, 5, 9),
#  model = First_STM, method = "difference",
#  cov.value1 = "Liberal", cov.value2 = "Conservative",
#  xlab = "More Conservative ... More Liberal",
#  main = "Effect of Liberal vs. Conservative",
#  xlim = c(-.1, .1), labeltype = "custom",
#  custom.labels = c('Topic 3', 'Topic 5','Topic 9'))
```

-   LDAviz - possibilida criar visualizações interessantes

-   Topic models para textos pequenos (como tweets). O LDA não funciona
    bem com tweets. Tem outra técnica que tem sido usada: stLDA-C,
    presume que cada tweet só pode conter um tópico.

-   Estar ciente das limitações, em alguns casos a análise dictionary
    based seria o suficiente.

### Text Networks

-   O que é uma rede? É formado por nodes, e tem edges que são as
    conexões entre eles.

-   Redes de textos: tem mais de uma forma de pensar o que são os nodes.
    Exemplos: nodes sendo pessoas; ou nodes sendo palavras.

``` r
# devtools::install_github("cbail/textnets")
library(textnets)
#> Loading required package: dplyr
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
#> Loading required package: udpipe
#> Loading required package: ggraph
#> Loading required package: ggplot2
#> 
#> Attaching package: 'ggplot2'
#> The following object is masked from 'package:NLP':
#> 
#>     annotate
#> Loading required package: networkD3
#> Warning: replacing previous import 'dplyr::union' by 'igraph::union' when
#> loading 'textnets'
#> Warning: replacing previous import 'dplyr::as_data_frame' by
#> 'igraph::as_data_frame' when loading 'textnets'
#> Warning: replacing previous import 'dplyr::groups' by 'igraph::groups' when
#> loading 'textnets'
data(sotu)
head(sotu)
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              sotu_text
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Fellow-Citizens of the Senate and House of Representatives: \n\nI embrace with great satisfaction the opportunity which now presents itself of congratulating you on the present favorable prospects of our public affairs. The recent accession of the important state of North Carolina to the Constitution of the United States (of which official information has been received), the rising credit and respectability of our country, the general and increasing good will toward the government of the Union, and the concord, peace, and plenty with which we are blessed are circumstances auspicious in an eminent degree to our national prosperity.\n\nIn resuming your consultations for the general good you can not but derive encouragement from the reflection that the measures of the last session have been as satisfactory to your constituents as the novelty and difficulty of the work allowed you to hope. Still further to realize their expectations and to secure the blessings which a gracious Providence has placed within our reach will in the course of the present important session call for the cool and deliberate exertion of your patriotism, firmness, and wisdom.\n\nAmong the many interesting objects which will engage your attention that of providing for the common defense will merit particular regard. To be prepared for war is one of the most effectual means of preserving peace.\n\nA free people ought not only to be armed, but disciplined; to which end a uniform and well-digested plan is requisite; and their safety and interest require that they should promote such manufactories as tend to render them independent of others for essential, particularly military, supplies.\n\nThe proper establishment of the troops which may be deemed indispensable will be entitled to mature consideration. In the arrangements which may be made respecting it it will be of importance to conciliate the comfortable support of the officers and soldiers with a due regard to economy.\n\nThere was reason to hope that the pacific measures adopted with regard to certain hostile tribes of Indians would have relieved the inhabitants of our southern and western frontiers from their depredations, but you will perceive from the information contained in the papers which I shall direct to be laid before you (comprehending a communication from the Commonwealth of Virginia) that we ought to be prepared to afford protection to those parts of the Union, and, if necessary, to punish aggressors.\n\nThe interests of the United States require that our intercourse with other nations should be facilitated by such provisions as will enable me to fulfill my duty in that respect in the manner which circumstances may render most conducive to the public good, and to this end that the compensation to be made to the persons who may be employed should, according to the nature of their appointments, be defined by law, and a competent fund designated for defraying the expenses incident to the conduct of foreign affairs.\n\nVarious considerations also render it expedient that the terms on which foreigners may be admitted to the rights of citizens should be speedily ascertained by a uniform rule of naturalization.\n\nUniformity in the currency, weights, and measures of the United States is an object of great importance, and will, I am persuaded, be duly attended to.\n\nThe advancement of agriculture, commerce, and manufactures by all proper means will not, I trust, need recommendation; but I can not forbear intimating to you the expediency of giving effectual encouragement as well to the introduction of new and useful inventions from abroad as to the exertions of skill and genius in producing them at home, and of facilitating the intercourse between the distant parts of our country by a due attention to the post-office and post-roads.\n\nNor am I less persuaded that you will agree with me in opinion that there is nothing which can better deserve your patronage than the promotion of science and literature. Knowledge is in every country the surest basis of public happiness. In one in which the measures of government receive their impressions so immediately from the sense of the community as in ours it is proportionably essential.\n\nTo the security of a free constitution it contributes in various ways - by convincing those who are intrusted with the public administration that every valuable end of government is best answered by the enlightened confidence of the people, and by teaching the people themselves to know and to value their own rights; to discern and provide against invasions of them; to distinguish between oppression and the necessary exercise of lawful authority; between burthens proceeding from a disregard to their convenience and those resulting from the inevitable exigencies of society; to discriminate the spirit of liberty from that of licentiousness - cherishing the first, avoiding the last - and uniting a speedy but temperate vigilance against encroachments, with an inviolable respect to the laws.\n\nWhether this desirable object will be best promoted by affording aids to seminaries of learning already established, by the institution of a national university, or by any other expedients will be well worthy of a place in the deliberations of the legislature.\n\nGentlemen of the House of Representatives: \n\nI saw with peculiar pleasure at the close of the last session the resolution entered into by you expressive of your opinion that an adequate provision for the support of the public credit is a matter of high importance to the national honor and prosperity. In this sentiment I entirely concur; and to a perfect confidence in your best endeavors to devise such a provision as will be truly with the end I add an equal reliance on the cheerful cooperation of the other branch of the legislature.\n\nIt would be superfluous to specify inducements to a measure in which the character and interests of the United States are so obviously so deeply concerned, and which has received so explicit a sanction from your declaration. \n\nGentlemen of the Senate and House of Representatives: \n\nI have directed the proper officers to lay before you, respectively, such papers and estimates as regard the affairs particularly recommended to your consideration, and necessary to convey to you that information of the state of the Union which it is my duty to afford.\n\nThe welfare of our country is the great object to which our cares and efforts ought to be directed, and I shall derive great satisfaction from a cooperation with you in the pleasing though arduous task of insuring to our fellow citizens the blessings which they have a right to expect from a free, efficient, and equal government. GEORGE WASHINGTON\n
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       \n\n Fellow-Citizens of the Senate and House of Representatives: \n\nIn meeting you again I feel much satisfaction in being able to repeat my congratulations on the favorable prospects which continue to distinguish our public affairs. The abundant fruits of another year have blessed our country with plenty and with the means of a flourishing commerce.\n\nThe progress of public credit is witnessed by a considerable rise of American stock abroad as well as at home, and the revenues allotted for this and other national purposes have been productive beyond the calculations by which they were regulated. This latter circumstance is the more pleasing, as it is not only a proof of the fertility of our resources, but as it assures us of a further increase of the national respectability and credit, and, let me add, as it bears an honorable testimony to the patriotism and integrity of the mercantile and marine part of our citizens. The punctuality of the former in discharging their engagements has been exemplary.\n\nIn conformity to the powers vested in me by acts of the last session, a loan of 3,000,000 florins, toward which some provisional measures had previously taken place, has been completed in Holland. As well the celerity with which it has been filled as the nature of the terms (considering the more than ordinary demand for borrowing created by the situation of Europe) give a reasonable hope that the further execution of those powers may proceed with advantage and success. The Secretary of the Treasury has my directions to communicate such further particulars as may be requisite for more precise information.\n\nSince your last sessions I have received communications by which it appears that the district of Kentucky, at present a part of Virginia, has concurred in certain propositions contained in a law of that State, in consequence of which the district is to become a distinct member of the Union, in case the requisite sanction of Congress be added. For this sanction application is now made. I shall cause the papers on this very transaction to be laid before you.\n\nThe liberality and harmony with which it has been conducted will be found to do great honor to both the parties, and the sentiments of warm attachment to the Union and its present Government expressed by our fellow citizens of Kentucky can not fail to add an affectionate concern for their particular welfare to the great national impressions under which you will decide on the case submitted to you.\n\nIt has been heretofore known to Congress that frequent incursion have been made on our frontier settlements by certain banditti of Indians from the northwest side of the Ohio. These, with some of the tribes dwelling on and near the Wabash, have of late been particularly active in their depredations, and being emboldened by the impunity of their crimes and aided by such parts of the neighboring tribes as could be seduced to join in their hostilities or afford them a retreat for their prisoners and plunder, they have, instead of listening to the humane invitations and overtures made on the part of the United States, renewed their violences with fresh alacrity and greater effect. The lives of a number of valuable citizens have thus been sacrificed, and some of them under circumstances peculiarly shocking, whilst others have been carried into a deplorable captivity.\n\nThese aggravated provocations rendered it essential to the safety of the Western settlements that the aggressors should be made sensible that the Government of the Union is not less capable of punishing their crimes than it is disposed to respect their rights and reward their attachments. As this object could not be effected by defensive measures, it became necessary to put in force the act which empowers the President to call out the militia for the protection of the frontiers, and I have accordingly authorized an expedition in which the regular troops in that quarter are combined with such drafts of militia as were deemed sufficient. The event of the measure is yet unknown to me. The Secretary of War is directed to lay before you a statement of the information on which it is founded, as well as an estimate of the expense with which it will be attended.\n\nThe disturbed situation of Europe, and particularly the critical posture of the great maritime powers, whilst it ought to make us the more thankful for the general peace and security enjoyed by the United States, reminds us at the same time of the circumspection with which it becomes us to preserve these blessings. It requires also that we should not overlook the tendency of a war, and even of preparations for a war, among the nations most concerned in active commerce with this country to abridge the means, and thereby at least enhance the price, of transporting its valuable productions to their markets. I recommend it to your serious reflections how far and in what mode it may be expedient to guard against embarrassments from these contingencies by such encouragements to our own navigation as will render our commerce and agriculture less dependent on foreign bottoms, which may fail us in the very moments most interesting to both of these great objects. Our fisheries and the transportation of our own produce offer us abundant means for guarding ourselves against this evil.\n\nYour attention seems to be not less due to that particular branch of our trade which belongs to the Mediterranean. So many circumstances unite in rendering the present state of it distressful to us that you will not think any deliberations misemployed which may lead to its relief and protection.\n\nThe laws you have already passed for the establishment of a judiciary system have opened the doors of justice to all descriptions of persons. You will consider in your wisdom whether improvements in that system may yet be made, and particularly whether an uniform process of execution on sentences issuing from the Federal courts be not desirable through all the States.\n\nThe patronage of our commerce, of our merchants and sea men, has called for the appointment of consuls in foreign countries. It seems expedient to regulate by law the exercise of that jurisdiction and those functions which are permitted them, either by express convention or by a friendly indulgence, in the places of their residence. The consular convention, too, with His Most Christian Majesty has stipulated in certain cases the aid of the national authority to his consuls established here. Some legislative provision is requisite to carry these stipulations into full effect.\n\nThe establishment of the militia, of a mint, of standards of weights and measures, of the post office and post roads are subjects which I presume you will resume of course, and which are abundantly urged by their own importance.\n\n Gentlemen of the House of Representatives: \n\nThe sufficiency of the revenues you have established for the objects to which they are appropriated leaves no doubt that the residuary provisions will be commensurate to the other objects for which the public faith stands now pledged. Allow me, moreover, to hope that it will be a favorite policy with you, not merely to secure a payment of the interest of the debt funded, but as far and as fast as the growing resources of the country will permit to exonerate it of the principal itself. The appropriation you have made of the Western land explains your dispositions on this subject, and I am persuaded that the sooner that valuable fund can be made to contribute, along with the other means, to the actual reduction of the public debt the more salutary will the measure be to every public interest, as well as the more satisfactory to our constituents.\n\n Gentlemen of the Senate and House of Representatives: \n\nin pursuing the various and weighty business of the present session I indulge the fullest persuasion that your consultation will be equally marked with wisdom and animated by the love of your country. In whatever belongs to my duty you shall have all the cooperation which an undiminished zeal for its welfare can inspire. It will be happy for us both, and our best reward, if, by a successful administration of our respective trusts, we can make the established Government more and more instrumental in promoting the good of our fellow citizens, and more and more the object of their attachment and confidence. GO. WASHINGTON\n
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               \n\n Fellow-Citizens of the Senate and House of Representatives: \n\n "In vain may we expect peace with the Indians on our frontiers so long as a lawless set of unprincipled wretches can violate the rights of hospitality, or infringe the most solemn treaties, without receiving the punishment they so justly merit." \n\nI meet you upon the present occasion with the feelings which are naturally inspired by a strong impression of the prosperous situations of our common country, and by a persuasion equally strong that the labors of the session which has just commenced will, under the guidance of a spirit no less prudent than patriotic, issue in measures conducive to the stability and increase of national prosperity.\n\nNumerous as are the providential blessings which demand our grateful acknowledgments, the abundance with which another year has again rewarded the industry of the husbandman is too important to escape recollection.\n\nYour own observations in your respective situations will have satisfied you of the progressive state of agriculture, manufactures, commerce, and navigation. In tracing their causes you will have remarked with particular pleasure the happy effects of that revival of confidence, public as well as private, to which the Constitution and laws of the United States have so eminently contributed; and you will have observed with no less interest new and decisive proofs of the increasing reputation and credit of the nation. But you nevertheless can not fail to derive satisfaction from the confirmation of these circumstances which will be disclosed in the several official communications that will be made to you in the course of your deliberations.\n\nThe rapid subscriptions to the Bank of the United States, which completed the sum allowed to be subscribed in a single day, is among the striking and pleasing evidences which present themselves, not only of confidence in the Government, but of resource in the community.\n\nIn the interval of your recess due attention has been paid to the execution of the different objects which were specially provided for by the laws and resolutions of the last session.\n\nAmong the most important of these is the defense and security of the western frontiers. To accomplish it on the most humane principles was a primary wish.\n\nAccordingly, at the same time the treaties have been provisionally concluded and other proper means used to attach the wavering and to confirm in their friendship the well-disposed tribes of Indians, effectual measures have been adopted to make those of a hostile description sensible that a pacification was desired upon terms of moderation and justice.\n\nThose measures having proved unsuccessful, it became necessary to convince the refractory of the power of the United States to punish their depredations. Offensive operations have therefore been directed, to be conducted, however, as consistently as possible with the dictates of humanity.\n\nSome of these have been crowned with full success and others are yet depending. The expeditions which have been completed were carried on under the authority and at the expense of the United States by the militia of Kentucky, whose enterprise, intrepidity, and good conduct are entitled of peculiar commendation.\n\nOvertures of peace are still continued to the deluded tribes, and considerable numbers of individuals belonging to them have lately renounced all further opposition, removed from their former situations, and placed themselves under the immediate protection of the United States.\n\nIt is sincerely to be desired that all need of coercion in future may cease and that an intimate intercourse may succeed, calculated to advance the happiness of the Indians and to attach them firmly to the United States.\n\nIn order to this it seems necessary -  That they should experience the benefits of an impartial dispensation of justice.  That the mode of alienating their lands, the main source of discontent and war, should be so defined and regulated as to obviate imposition and as far as may be practicable controversy concerning the reality and extent of the alienations which are made.  That commerce with them should be promoted under regulations tending to secure an equitable deportment toward them, and that such rational experiments should be made for imparting to them the blessings of civilization as may from time to time suit their condition.  That the Executive of the United States should be enabled to employ the means to which the Indians have been long accustomed for uniting their immediate interests with the preservation of peace.  And that efficacious provision should be made for inflicting adequate penalties upon all those who, by violating their rights, shall infringe the treaties and endanger the peace of the Union.  A system corresponding with the mild principles of religion and philanthropy toward an unenlightened race of men, whose happiness materially depends on the conduct of the United States, would be as honorable to the national character as conformable to the dictates of sound policy.\n\nThe powers specially vested in me by the act laying certain duties on distilled spirits, which respect the subdivisions of the districts into surveys, the appointment of officers, and the assignment of compensations, have likewise carried into effect. In a manner in which both materials and experience were wanting to guide the calculation it will be readily conceived that there must have been difficulty in such an adjustment of the rates of compensation as would conciliate a reasonable competency with a proper regard to the limits prescribed by the law. It is hoped that the circumspection which has been used will be found in the result to have secured that last two objects; but it is probable that with a view to the first in some instances a revision of the provision will be found advisable.\n\nThe impressions with which this law has been received by the community have been upon the whole such as were to be expected among enlightened and well-disposed citizens from the propriety and necessity of the measure. The novelty, however, of the tax in a considerable part of the United States and a misconception of some of its provisions have given occasion in particular places to some degree of discontent; but it is satisfactory to know that this disposition yields to proper explanations and more just apprehensions of the true nature of the law, and I entertain a full confidence that it will in all give way to motives which arise out of a just sense of duty and a virtuous regard to the public welfare.\n\nIf there are any circumstances in the law which consistently with its main design may be so varied as to remove any well-intentioned objections that may happen to exist, it will consist with a wise moderation to make the proper variations. It is desirable on all occasions to unite with a steady and firm adherence to constitutional and necessary acts of Government the fullest evidence of a disposition as far as may be practicable to consult the wishes of every part of the community and to lay the foundations of the public administration in the affections of the people.\n\nPursuant to the authority contained in the several acts on that subject, a district of 10 miles square for the permanent seat of the Government of the United State has been fixed and announced by proclamation, which district will comprehend lands on both sides of the river Potomac and the towns of Alexandria and Georgetown. A city has also been laid out agreeably to a plan which will be placed before Congress, and as there is a prospect, favored by the rate of sales which have already taken place, of ample funds for carrying on the necessary public buildings, there is every expectation of their due progress.\n\nThe completion of the census of the inhabitants, for which provision was made by law, has been duly notified (excepting one instance in which the return has been informal, and another in which it has been omitted or miscarried), and the returns of the officers who were charged with this duty, which will be laid before you, will give you the pleasing assurance that the present population of the United States borders on 4,000,000 persons.\n\nIt is proper also to inform you that a further loan of 2,500,000 florins has been completed in Holland, the terms of which are similar to those of the one last announced, except as to a small reduction of charges. Another, on like terms, for 6,000,000 florins, had been set on foot under circumstances that assured an immediate completion.\n\n Gentlemen of the Senate: \n\nTwo treaties which have been provisionally concluded with the Cherokees and Six Nations of Indians will be laid before you for your consideration and ratification.\n\n Gentlemen of the House of Representatives: \n\nIn entering upon the discharge of your legislative trust you must anticipate with pleasure that many of the difficulties necessarily incident to the first arrangements of a new government for an extensive country have been happily surmounted by the zealous and judicious exertions of your predecessors in cooperation with the other branch of the Legislature. The important objects which remain to be accomplished will, I am persuaded, be conducted upon principles equally comprehensive and equally well calculated of the advancement of the general weal.\n\nThe time limited for receiving subscriptions to the loans proposed by the act making provision for the debt of the United States having expired, statements from the proper department will as soon as possible apprise you of the exact result. Enough, however, is known already to afford an assurance that the views of that act have been substantially fulfilled. The subscription in the domestic debt of the United States has embraced by far the greatest proportion of that debt, affording at the same time proof of the general satisfaction of the public creditors with the system which has been proposed to their acceptance and of the spirit of accommodation to the convenience of the Government with which they are actuated. The subscriptions in the debts of the respective States as far as the provisions of the law have permitted may be said to be yet more general. The part of the debt of the United States which remains unsubscribed will naturally engage your further deliberations.\n\nIt is particularly pleasing to me to be able to announce to you that the revenues which have been established promise to be adequate to their objects, and may be permitted, if no unforeseen exigency occurs, to supersede for the present the necessity of any new burthens upon our constituents.\n\nAn object which will claim your early attention is a provision for the current service of the ensuing year, together with such ascertained demands upon the Treasury as require to be immediately discharged, and such casualties as may have arisen in the execution of the public business, for which no specific appropriation may have yet been made; of all which a proper estimate will be laid before you.\n\n Gentlemen of the Senate and of the House of Representatives: \n\nI shall content myself with a general reference to former communications for several objects upon which the urgency of other affairs has hitherto postponed any definitive resolution. Their importance will recall them to your attention, and I trust that the progress already made in the most arduous arrangements of the Government will afford you leisure to resume them to advantage.\n\nThese are, however, some of them of which I can not forbear a more particular mention. These are the militia, the post office and post roads, the mint, weights and measures, a provision for the sale of the vacant lands of the United States.\n\nThe first is certainly an object of primary importance whether viewed in reference to the national security to the satisfaction of the community or to the preservation of order. In connection with this the establishment of competent magazines and arsenals and the fortification of such places as are peculiarly important and vulnerable naturally present themselves to consideration. The safety of the United States under divine protection ought to rest on the basis of systematic and solid arrangements, exposed as little as possible to the hazards of fortuitous circumstances.\n\nThe importance of the post office and post roads on a plan sufficiently liberal and comprehensive, as they respect the expedition, safety, and facility of communication, is increased by their instrumentality in diffusing a knowledge of the laws and proceedings of the Government, which, while it contributes to the security of the people, serves also to guard them against the effects of misrepresentation and misconception. The establishment of additional cross posts, especially to some of the important points in the Western and Northern parts of the Union, can not fail to be of material utility.\n\nThe disorders in the existing currency, and especially the scarcity of small change, a scarcity so peculiarly distressing to the poorer classes, strongly recommend the carrying into immediate effect the resolution already entered into concerning the establishment of a mint. Measures have been taken pursuant to that resolution for procuring some of the most necessary artists, together with the requisite apparatus.\n\nAn uniformity in the weights and measures of the country is among the important objects submitted to you by the Constitution, and if it can be derived from a standard at once invariable and universal, must be no less honorable to the public councils than conducive to the public convenience.\n\nA provision for the sale of the vacant lands of the United States is particularly urged, among other reasons, by the important considerations that they are pledged as a fund for reimbursing the public debt; that if timely and judiciously applied they may save the necessity of burthening our citizens with new taxes for the extinguishment of the principal; and that being free to discharge the principal but in a limited proportion, no opportunity ought to be lost for availing the public of its right. GO. WASHINGTON\n
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       Fellow-Citizens of the Senate and House of Representatives: \n\nIt is some abatement of the satisfaction with which I meet you on the present occasion that, in felicitating you on a continuance of the national prosperity generally, I am not able to add to it information that the Indian hostilities which have for some time past distressed our Northwestern frontier have terminated.\n\nYou will, I am persuaded, learn with no less concern than I communicate it that reiterated endeavors toward effecting a pacification have hitherto issued only in new and outrageous proofs of persevering hostility on the part of the tribes with whom we are in contest. An earnest desire to procure tranquillity to the frontier, to stop the further effusion of blood, to arrest the progress of expense, to forward the prevalent wish of the nation for peace has led to strenuous efforts through various channels to accomplish these desirable purposes; in making which efforts I consulted less my own anticipations of the event, or the scruples which some considerations were calculated to inspire, than the wish to find the object attainable, or if not attainable, to ascertain unequivocally that such is the case.\n\nA detail of the measures which have been pursued and of their consequences, which will be laid before you, while it will confirm to you the want of success thus far, will, I trust, evince that means as proper and as efficacious as could have been devised have been employed. The issue of some of them, indeed, is still depending, but a favorable one, though not to be despaired of, is not promised by anything that has yet happened.\n\nIn the course of the attempts which have been made some valuable citizens have fallen victims to their zeal for the public service. A sanction commonly respected even among savages has been found in this instance insufficient to protect from massacre the emissaries of peace. It will, I presume, be duly considered whether the occasion does not call for an exercise of liberality toward the families of the deceased.\n\nIt must add to your concern to be informed that, besides the continuation of hostile appearances among the tribes north of the Ohio, some threatening symptoms have of late been revived among some of those south of it.\n\nA part of the Cherokees, known by the name of Chickamaugas, inhabiting five villages on the Tennessee River, have long been in the practice of committing depredations on the neighboring settlements.\n\nIt was hoped that the treaty of Holston, made with the Cherokee Nation in July, 1791, would have prevented a repetition of such depredations; but the event has not answered this hope. The Chickamaugas, aided by some banditti of another tribe in their vicinity, have recently perpetrated wanton and unprovoked hostilities upon the citizens of the United States in that quarter. The information which has been received on this subject will be laid before you. Hitherto defensive precautions only have been strictly enjoined and observed.\n\nIt is not understood that any breach of treaty or aggression whatsoever on the part of the United States or their citizens is even alleged as a pretext for the spirit of hostility in this quarter.\n\nI have reason to believe that every practicable exertion has been made (pursuant to the provision by law for that purpose) to be prepared for the alternative of a prosecution of the war in the event of a failure of pacific overtures. A large proportion of the troops authorized to be raised have been recruited, though the number is still incomplete, and pains have been taken to discipline and put them in condition for the particular kind of service to be performed. A delay of operations (besides being dictated by the measures which were pursuing toward a pacific termination of the war) has been in itself deemed preferable to immature efforts. A statement from the proper department with regard to the number of troops raised, and some other points which have been suggested, will afford more precise information as a guide to the legislative consultations, and among other things will enable Congress to judge whether some additional stimulus to the recruiting service may not be advisable.\n\nIn looking forward to the future expense of the operations which may be found inevitable I derive consolation from the information I receive that the product of the revenues for the present year is likely to supersede the necessity of additional burthens on the community for the service of the ensuing year. This, however, will be better ascertained in the course of the session, and it is proper to add that the information alluded to proceeds upon the supposition of no material extension of the spirit of hostility.\n\nI can not dismiss the subject of Indian affairs without again recommending to your consideration the expediency of more adequate provision for giving energy to the laws throughout our interior frontier and for restraining the commission of outrages upon the Indians, without which all pacific plans must prove nugatory. To enable, by competent rewards, the employment of qualified and trusty persons to reside among them as agents would also contribute to the preservation of peace and good neighborhood. If in addition to these expedients an eligible plan could be devised for promoting civilization among the friendly tribes and for carrying on trade with them upon a scale equal to their wants and under regulations calculated to protect them from imposition and extortion, its influence in cementing their interest with ours could not but be considerable.\n\nThe prosperous state of our revenue has been intimated. This would be still more the case were it not for the impediments which in some places continue to embarrass the collection of the duties on spirits distilled within the United States. These impediments have lessened and are lessening in local extent, and, as applied to the community at large, the contentment with the law appears to be progressive.\n\nBut symptoms of increased opposition having lately manifested themselves in certain quarters, I judged a special interposition on my part proper and advisable, and under this impression have issued a proclamation warning against all unlawful combinations and proceedings having for their object or tending to obstruct the operation of the law in question, and announcing that all lawful ways and means would be strictly put in execution for bringing to justice the infractors thereof and securing obedience thereto.\n\nMeasures have also been taken for the prosecution of offenders, and Congress may be assured that nothing within constitutional and legal limits which may depend upon me shall be wanting to assert and maintain the just authority of the laws. In fulfilling this trust I shall count entirely upon the full cooperation of the other departments of the Government and upon the zealous support of all good citizens.\n\nI can not forbear to bring again into the view of the Legislature the subject of a revision of the judiciary system. A representation from the judges of the Supreme Court, which will be laid before you, points out some of the inconveniences that are experienced. In the course of the execution of the laws considerations arise out of the structure of the system which in some cases tend to relax their efficacy. As connected with this subject, provisions to facilitate the taking of bail upon processes out of the courts of the United States and a supplementary definition of offenses against the Constitution and laws of the Union and of the punishment for such offenses will, it is presumed, be found worthy of particular attention.\n\nObservations on the value of peace with other nations are unnecessary. It would be wise, however, by timely provisions to guard against those acts of our own citizens which might tend to disturb it, and to put ourselves in a condition to give that satisfaction to foreign nations which we may sometimes have occasion to require from them. I particularly recommend to your consideration the means of preventing those aggressions by our citizens on the territory of other nations, and other infractions of the law of nations, which, furnishing just subject of complaint, might endanger our peace with them; and, in general, the maintenance of a friendly intercourse with foreign powers will be presented to your attention by the expiration of the law for that purpose, which takes place, if not renewed, at the close of the present session.\n\nIn execution of the authority given by the Legislature measures have been taken for engaging some artists from abroad to aid in the establishment of our mint. Others have been employed at home. Provision has been made of the requisite buildings, and these are now putting into proper condition for the purposes of the establishment. There has also been a small beginning in the coinage of half dimes, the want of small coins in circulation calling the first attention to them.\n\nThe regulation of foreign coins in correspondency with the principles of our national coinage, as being essential to their due operation and to order in our money concerns, will, I doubt not, be resumed and completed.\n\nIt is represented that some provisions in the law which establishes the post office operate, in experiment, against the transmission of news papers to distant parts of the country. Should this, upon due inquiry, be found to be the fact, a full conviction of the importance of facilitating the circulation of political intelligence and information will, I doubt not, lead to the application of a remedy.\n\nThe adoption of a constitution for the State of Kentucky has been notified to me. The Legislature will share with me in the satisfaction which arises from an event interesting to the happiness of the part of the nation to which it relates and conducive to the general order.\n\nIt is proper likewise to inform you that since my last communication on the subject, and in further execution of the acts severally making provision for the public debt and for the reduction thereof, three new loans have been effected, each for 3,000,000 florins - one at Antwerp, at the annual interest of 4.5%, with an allowance of 4% in lieu of all charges, in the other 2 at Amsterdam, at the annual interest of 4%, with an allowance of 5.5% in one case and of 5% in the other in lieu of all charges. The rates of these loans and the circumstances under which they have been made are confirmations of the high state of our credit abroad.\n\nAmong the objects to which these funds have been directed to be applied, the payment of the debts due to certain foreign officers, according to the provision made during the last session, has been embraced.\n\n Gentlemen of the House of Representatives: \n\nI entertain a strong hope that the state of the national finances is now sufficiently matured to enable you to enter upon a systematic and effectual arrangement for the regular redemption and discharge of the public debt, according to the right which has been reserved to the Government. No measure can be more desirable, whether viewed with an eye to its intrinsic importance or to the general sentiment and wish of the nation.\n\nProvision is likewise requisite for the reimbursement of the loan which has been made of the Bank of the United States, pursuant to the eleventh section of the act by which it is incorporated. In fulfilling the public stipulations in this particular it is expected a valuable saving will be made.\n\nAppropriations for the current service of the ensuing year and for such extraordinaries as may require provision will demand, and I doubt not will engage, your early attention.\n\n Gentlemen of the Senate and of the House of Representatives: \n\nI content myself with recalling your attention generally to such objects, not particularized in my present, as have been suggested in my former communications to you.\n\nVarious temporary laws will expire during the present session. Among these, that which regulates trade and intercourse with the Indian tribes will merit particular notice.\n\nThe results of your common deliberations hitherto will, I trust, be productive of solid and durable advantages to our constituents, such as, by conciliating more and more their ultimate suffrage, will tend to strengthen and confirm their attachment to that Constitution of Government upon which, under Divine Providence, materially depend their union, their safety, and their happiness.\n\nStill further to promote and secure these inestimable ends there is nothing which can have a more powerful tendency than the careful cultivation of harmony, combined with a due regard to stability, in the public councils. GO. WASHINGTON\n
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               \n\n Fellow-Citizens of the Senate and House of Representatives: \n\nSince the commencement of the term for which I have been again called into office no fit occasion has arisen for expressing to me fellow citizens at large the deep and respectful sense which I feel of the renewed testimony of public approbation. While on the one hand it awakened my gratitude for all those instances of affectionate partiality with which I have been honored by my country, on the other it could not prevent an earnest wish for that retirement from which no private consideration should ever have torn me. But influenced by the belief that my conduct would be estimated according to its real motives, and that the people, and the authorities derived from them, would support exertions having nothing personal for their object, I have obeyed the suffrage which commanded me to resume the Executive power; and I humbly implore that Being on whose will the fate of nations depends to crown with success our mutual endeavors for the general happiness.\n\nAs soon as the war in Europe had embraced those powers with whom the United States have the most extensive relations there was reason to apprehend that our intercourse with them might be interrupted and our disposition for peace drawn into question by the suspicions too often entertained by belligerent nations. It seemed, therefore, to be my duty to admonish our citizens of the consequences of a contraband trade and of hostile acts to any of the parties, and to obtain by a declaration of the existing legal state of things an easier admission of our right to the immunities belonging to our situation. Under these impressions the proclamation which will be laid before you was issued.\n\nIn this posture of affairs, both new and delicate, I resolved to adopt general rules which should conform to the treaties and assert the privileges of the United States. These were reduced into a system, which will be communicated to you. Although I have not thought of myself at liberty to forbid the sale of the prizes permitted by our treaty of commerce with France to be brought into our ports, I have not refused to cause them to be restored when they were taken within the protection of our territory, or by vessels commissioned or equipped in a warlike form within the limits of the United States.\n\nIt rests with the wisdom of Congress to correct, improve, or enforce this plan of procedure; and it will probably be found expedient to extend the legal code and the jurisdiction of the courts of the United States to many cases which, though dependent on principles already recognized, demand some further provisions.\n\nWhere individuals shall, within the United States, array themselves in hostility against any of the powers at war, or enter upon military expeditions or enterprises within the jurisdiction of the United States, or usurp and exercise judicial authority within the United States, or where the penalties on violations of the law of nations may have been indistinctly marked, or are inadequate - these offenses can not receive too early and close an attention, and require prompt and decisive remedies.\n\nWhatsoever those remedies may be, they will be well administered by the judiciary, who possess a long-established course of investigation, effectual process, and officers in the habit of executing it.\n\nIn like manner, as several of the courts have doubted, under particular circumstances, their power to liberate the vessels of a nation at peace, and even of a citizen of the United States, although seized under a false color of being hostile property, and have denied their power to liberate certain captures within the protection of our territory, it would seem proper to regulate their jurisdiction in these points. But if the Executive is to be the resort in either of the two last-mentioned cases, it is hoped that he will be authorized by law to have facts ascertained by the courts when for his own information he shall request it.\n\nI can not recommend to your notice measures for the fulfillment of our duties to the rest of the world without again pressing upon you the necessity of placing ourselves in a condition of complete defense and of exacting from them the fulfillment of their duties toward us. The United States ought not to indulge a persuasion that, contrary to the order of human events, they will forever keep at a distance those painful appeals to arms with which the history of every other nation abounds. There is a rank due to the United States among nations which will be withheld, if not absolutely lost, by the reputation of weakness. If we desire to avoid insult, we must be able to repel it; if we desire to secure peace, one of the most powerful instruments of our rising prosperity, it must be known that we are at all times ready for war. The documents which will be presented to you will shew the amount and kinds of arms and military stores now in our magazines and arsenals; and yet an addition even to these supplies can not with prudence be neglected, as it would leave nothing to the uncertainty of procuring warlike apparatus in the moment of public danger.\n\nNor can such arrangements, with such objects, be exposed to the censure or jealousy of the warmest friends of republican government. They are incapable of abuse in the hands of the militia, who ought to possess a pride in being the depository of the force of the Republic, and may be trained to a degree of energy equal to every military exigency of the United States. But it is an inquiry which can not be too solemnly pursued, whether the act "more effectually to provide for the national defense by establishing an uniform militia throughout the United States" has organized them so as to produce their full effect; whether your own experience in the several States has not detected some imperfections in the scheme, and whether a material feature in an improvement of it ought not to be to afford an opportunity for the study of those branches of the military art which can scarcely ever be attained by practice alone.\n\nThe connection of the United States with Europe has become extremely interesting. The occurrences which relate to it and have passed under the knowledge of the Executive will be exhibited to Congress in a subsequent communication.\n\nWhen we contemplate the war on our frontiers, it may be truly affirmed that every reasonable effort has been made to adjust the causes of dissension with the Indians north of the Ohio. The instructions given to the commissioners evince a moderation and equity proceeding from a sincere love of peace, and a liberality having no restriction but the essential interests and dignity of the United States. The attempt, however, of an amicable negotiation having been frustrated, the troops have marched to act offensively. Although the proposed treaty did not arrest the progress of military preparation, it is doubtful how far the advance of the season, before good faith justified active movements, may retard them during the remainder of the year. From the papers and intelligence which relate to this important subject you will determine whether the deficiency in the number of troops granted by law shall be compensated by succors of militia, or additional encouragements shall be proposed to recruits.\n\nAn anxiety has been also demonstrated by the Executive for peace with the Creeks and the Cherokees. The former have been relieved with corn and with clothing, and offensive measures against them prohibited during the recess of Congress. To satisfy the complaints of the latter, prosecutions have been instituted for the violences committed upon them. But the papers which will be delivered to you disclose the critical footing on which we stand in regard to both those tribes, and it is with Congress to pronounce what shall be done.\n\nAfter they shall have provided for the present emergency, it will merit their most serious labors to render tranquillity with the savages permanent by creating ties of interest. Next to a rigorous execution of justice on the violators of peace, the establishment of commerce with the Indian nations in behalf of the United States is most likely to conciliate their attachment. But it ought to be conducted without fraud, without extortion, with constant and plentiful supplies, with a ready market for the commodities of the Indians and a stated price for what they give in payment and receive in exchange. Individuals will not pursue such a traffic unless they be allured by the hope of profit; but it will be enough for the United States to be reimbursed only. Should this recommendation accord with the opinion of Congress, they will recollect that it can not be accomplished by any means yet in the hands of the Executive.\n\n Gentlemen of the House of Representatives: \n\nThe commissioners charged with the settlement of accounts between the United States and individual States concluded their important function within the time limited by law, and the balances struck in their report, which will be laid before Congress, have been placed on the books of the Treasury.\n\nOn the first day of June last an installment of 1,000,000 florins became payable on the loans of the United States in Holland. This was adjusted by a prolongation of the period of reimbursement in nature of a new loan at an interest of 5% for the term of ten years, and the expenses of this operation were a commission of 3%.\n\nThe first installment of the loan of $2,000,000 from the Bank of the United States has been paid, as was directed by law. For the second it is necessary that provision be made.\n\nNo pecuniary consideration is more urgent than the regular redemption and discharge of the public debt. On none can delay be more injurious or an economy of time more valuable.\n\nThe productiveness of the public revenues hitherto has continued to equal the anticipations which were formed of it, but it is not expected to prove commensurate with all the objects which have been suggested. Some auxiliary provisions will therefore, it is presumed, be requisite, and it is hoped that these may be made consistently with a due regard to the convenience of our citizens, who can not but be sensible of the true wisdom of encountering a small present addition to their contributions to obviate a future accumulation of burthens.\n\nBut here I can not forbear to recommend a repeal of the tax on the transportation of public prints. There is no resource so firm for the Government of the United States as the affections of the people, guided by an enlightened policy; and to this primary good nothing can conduce more than a faithful representation of public proceedings, diffused without restraint throughout the United States.\n\nAn estimate of the appropriations necessary for the current service of the ensuing year and a statement of a purchase of arms and military stores made during the recess will be presented to Congress.\n\n Gentlemen of the Senate and of the House of Representatives: \n\nThe several subjects to which I have now referred open a wide range to your deliberations and involve some of the choicest interests of our common country. Permit me to bring to your remembrance the magnitude of your task. Without an unprejudiced coolness the welfare of the Government may be hazarded; without harmony as far as consists with freedom of sentiment its dignity may be lost. But as the legislative proceedings of the United States will never, I trust, be reproached for the want of temper or of candor, so shall not the public happiness languish from the want of my strenuous and warmest cooperation GO. WASHINGTON\n
#> 6 \n\n Fellow-Citizens of the Senate and House of Representatives: \n\nWhen we call to mind the gracious indulgence of Heaven by which the American people became a nation; when we survey the general prosperity of our country, and look forward to the riches, power, and happiness to which it seems destined, with the deepest regret do I announce to you that during your recess some of the citizens of the United States have been found capable of insurrection. It is due, however, to the character of our Government and to its stability, which can not be shaken by the enemies of order, freely to unfold the course of this event.\n\nDuring the session of the year 1790 it was expedient to exercise the legislative power granted by the Constitution of the United States "to lay and collect excises". In a majority of the States scarcely an objection was heard to this mode of taxation. In some, indeed, alarms were at first conceived, until they were banished by reason and patriotism. In the four western counties of Pennsylvania a prejudice, fostered and imbittered by the artifice of men who labored for an ascendency over the will of others by the guidance of their passions, produced symptoms of riot and violence.\n\nIt is well known that Congress did not hesitate to examine the complaints which were presented, and to relieve them as far as justice dictated or general convenience would permit. But the impression which this moderation made on the discontented did not correspond with what it deserved. The arts of delusion were no longer confined to the efforts of designing individuals. The very forbearance to press prosecutions was misinterpreted into a fear of urging the execution of the laws, and associations of men began to denounce threats against the officers employed. From a belief that by a more formal concert their operation might be defeated, certain self-created societies assumed the tone of condemnation. Hence, while the greater part of Pennsylvania itself were conforming themselves to the acts of excise, a few counties were resolved to frustrate them. It is now perceived that every expectation from the tenderness which had been hitherto pursued was unavailing, and that further delay could only create an opinion of impotency or irresolution in the Government. Legal process was therefore delivered to the marshal against the rioters and delinquent distillers.\n\nNo sooner was he understood to be engaged in this duty than the vengeance of armed men was aimed at his person and the person and property of the inspector of the revenue. They fired upon the marshal, arrested him, and detained him for some time as a prisoner. He was obliged, by the jeopardy of his life, to renounce the service of other process on the west side of the Allegheny Mountain, and a deputation was afterwards sent to him to demand a surrender of that which he had served. A numerous body repeatedly attacked the house of the inspector, seized his papers of office, and finally destroyed by fire his buildings and whatsoever they contained. Both of these officers, from a just regard to their safety, fled to the seat of Government, it being avowed that the motives to such outrages were to compel the resignation of the inspector, to withstand by force of arms the authority of the United States, and thereby to extort a repeal of the laws of excise and an alteration in the conduct of Government.\n\nUpon testimony of these facts an associate justice of the Supreme Court of the United States notified to me that "in the counties of Washington and Allegheny, in Pennsylvania, laws of the United States were opposed, and the execution thereof obstructed, by combinations too powerful to be suppressed by the ordinary course of judicial proceedings or by the powers vested in the marshal of that district".\n\nOn this call, momentous in the extreme, I sought and weighted what might best subdue the crisis. On the one hand the judiciary was pronounced to be stripped of its capacity to enforce the laws; crimes which reached the very existence of social order were perpetrated without control; the friends of Government were insulted, abused, and overawed into silence or an apparent acquiescence; and to yield to the treasonable fury of so small a portion of the United States would be to violate the fundamental principle of our Constitution, which enjoins that the will of the majority shall prevail. On the other, to array citizen against citizen, to publish the dishonor of such excesses, to encounter the expense and other embarrassments of so distant an expedition, were steps too delicate, too closely interwoven with many affecting considerations, to be lightly adopted.\n\nI postponed, therefore, the summoning of the militia immediately into the field, but I required them to be held in readiness, that if my anxious endeavors to reclaim the deluded and to convince the malignant of their danger should be fruitless, military force might be prepared to act before the season should be too far advanced.\n\nMy proclamation of the 7th of August last [1794-08-07] was accordingly issued, and accompanied by the appointment of commissioners, who were charged to repair to the scene of insurrection. They were authorized to confer with any bodies of men or individuals. They were instructed to be candid and explicit in stating the sensations which had been excited in the Executive, and his earnest wish to avoid a resort to coercion; to represent, however, that, without submission, coercion must be the resort; but to invite them, at the same time, to return to the demeanor of faithful citizens, by such accommodations as lay within the sphere of Executive power. Pardon, too, was tendered to them by the Government of the United States and that of Pennsylvania, upon no other condition than a satisfactory assurance of obedience to the laws.\n\nAlthough the report of the commissioners marks their firmness and abilities, and must unite all virtuous men, by shewing that the means of conciliation have been exhausted, all of those who had committed or abetted the tumults did not subscribe the mild form which was proposed as the atonement, and the indications of a peaceable temper were neither sufficiently general nor conclusive to recommend or warrant the further suspension of the march of the militia.\n\nThus the painful alternative could not be discarded. I ordered the militia to march, after once more admonishing the insurgents in my proclamation of the 25th of September last [1794-09-25].\n\nIt was a task too difficult to ascertain with precision the lowest degree of force competent to the quelling of the insurrection. From a respect, indeed, to economy and the ease of my fellow citizens belonging to the militia, it would have gratified me to accomplish such an estimate. My very reluctance to ascribe too much importance to the opposition, had its extent been accurately seen, would have been a decided inducement to the smallest efficient numbers. In this uncertainty, therefore, I put into motion 15K men, as being an army which, according to all human calculation, would be prompt and adequate in every view, and might, perhaps, by rendering resistance desperate, prevent the effusion of blood. Quotas had been assigned to the States of New Jersey, Pennsylvania, Maryland, and Virginia, the governor of Pennsylvania having declared on this occasion an opinion which justified a requisition to the other States.\n\nAs commander in chief of the militia when called into the actual service of the United States, I have visited the places of general rendezvous to obtain more exact information and to direct a plan for ulterior movements. Had there been room for a persuasion that the laws were secure from obstruction; that the civil magistrate was able to bring to justice such of the most culpable as have not embraced the proffered terms of amnesty, and may be deemed fit objects of example; that the friends to peace and good government were not in need of that aid and countenance which they ought always to receive, and, I trust, ever will receive, against the vicious and turbulent, I should have caught with avidity the opportunity of restoring the militia to their families and homes. But succeeding intelligence has tended to manifest the necessity of what has been done, it being now confessed by those who were not inclined to exaggerate the ill conduct of the insurgents that their malevolence was not pointed merely to a particular law, but that a spirit inimical to all order has actuated many of the offenders. If the state of things had afforded reason for the continuance of my presence with the army, it would not have been withholden. But every appearance assuring such an issue as will redound to the reputation and strength of the United States, I have judged it most proper to resume my duties at the seat of Government, leaving the chief command with the governor of Virginia.\n\nStill, however, as it is probable that in a commotion like the present, whatsoever may be the pretense, the purposes of mischief and revenge may not be laid aside, the stationing of a small force for a certain period in the four western counties of Pennsylvania will be indispensable, whether we contemplate the situation of those who are connected with the execution of the laws or of others who may have exposed themselves by an honorable attachment to them. Thirty days from the commencement of this session being the legal limitation of the employment of the militia, Congress can not be too early occupied with this subject.\n\nAmong the discussions which may arise from this aspect of our affairs, and from the documents which will be submitted to Congress, it will not escape their observation that not only the inspector of the revenue, but other officers of the United States in Pennsylvania have, from their fidelity in the discharge of their functions, sustained material injuries to their property. The obligation and policy of indemnifying them are strong and obvious. It may also merit attention whether policy will not enlarge this provision to the retribution of other citizens who, though not under the ties of office, may have suffered damage by their generous exertions for upholding the Constitution and the laws. The amount, even if all the injured were included, would not be great, and on future emergencies the Government would be amply repaid by the influence of an example that he who incurs a loss in its defense shall find a recompense in its liberality.\n\nWhile there is cause to lament that occurrences of this nature should have disgraced the name or interrupted the tranquillity of any part of our community, or should have diverted to a new application any portion of the public resources, there are not wanting real and substantial consolations for the misfortune. It has demonstrated that our prosperity rests on solid foundations, by furnishing an additional that my fellow citizens understand the true principles of government and liberty; that they feel their inseparable union; that notwithstanding all the devices which have been used to sway them from their interest and duty, they are not as ready to maintain the authority of the laws against licentious invasions as they were to defend their rights against usurpation. It has been a spectacle displaying to the highest advantage of republican government to behold the most and the least wealthy of our citizens standing in the same ranks as private soldiers, preeminently distinguished by being the army of the Constitution - undeterred by a march of 300 miles over rugged mountains, by approach of an inclement season, or by any other discouragement. Nor ought I to omit to acknowledge the efficacious and patriotic cooperation which I have experienced from the chief magistrates of the States to which my requisitions have been addressed.\n\nTo every description of citizens, let praise be given. but let them persevere in their affectionate vigilance over that precious depository of American happiness, the Constitution of the United States. Let them cherish it, too, for the sake of those who, from every clime, are daily seeking a dwelling in our land. And when in the calm moments of reflection they shall have retraced the origin and progress of the insurrection, let them determine whether it has not been fomented by combinations of men who, careless of consequences and disregarding the unerring truth that those who rouse can not always appease a civil convulsion, have disseminated, from an ignorance or perversion of facts, suspicions, jealousies, and accusations of the whole Government.\n\nHaving thus fulfilled the engagement which I took when I entered into office, "to the best of my ability to preserve, protect, and defend the Constitution of the United States", on you, gentlemen, and the people by whom you are deputed, I rely for support.\n\nIn the arrangement to which the possibility of a similar contingency will naturally draw your attention it ought not to be forgotten that the militia laws have exhibited such striking defects as could not have been supplied by the zeal of our citizens. Besides the extraordinary expense and waste, which are not the least of the defects, every appeal to those laws is attended with a doubt on its success.\n\nThe devising and establishing of a well regulated militia would be a genuine source of legislative honor and a perfect title to public gratitude. I therefore entertain a hope that the present session will not pass without carrying to its full energy the power of organizing, arming, and disciplining the militia, and thus providing, in the language of the Constitution, for calling them forth to execute the laws of the Union, suppress insurrections, and repel invasions.\n\nAs auxiliary to the state of our defense, to which Congress can never too frequently recur, they will not omit to inquire whether the fortifications which have been already licensed by law be commensurate with our exigencies.\n\nThe intelligence from the army under the command of General Wayne is a happy presage to our military operations against the hostile Indians north of the Ohio. From the advices which have been forwarded, the advance which he has made must have damped the ardor of the savages and weakened their obstinacy in waging war against the United States. And yet, even at this late hour, when our power to punish them can not be questioned, we shall not be unwilling to cement a lasting peace upon terms of candor, equity, and good neighborhood.\n\nToward none of the Indian tribes have overtures of friendship been spared. The Creeks in particular are covered from encroachment by the imposition of the General Government and that of Georgia. From a desire also to remove the discontents of the Six nations, a settlement mediated at Presque Isle, on Lake Erie, has been suspended, and an agent is now endeavoring to rectify any misconception into which they may have fallen. But I can not refrain from again pressing upon your deliberations the plan which I recommended at the last session for the improvement of harmony with all the Indians within our limits by the fixing and conducting of trading houses upon the principles then expressed.\n\n Gentlemen of the House of Representatives: \n\nThe time which has elapsed since the commencement of our fiscal measures has developed our pecuniary resources so as to open the way for a definite plan for the redemption of the public debt. It is believed that the result is such as to encourage Congress to consummate this work without delay. Nothing can more promote the permanent welfare of the nation and nothing would be more grateful to our constituents. Indeed, whatsoever is unfinished of our system of public credit can not be benefited by procrastination; and as far as may be practicable we ought to place that credit on grounds which can not be disturbed, and to prevent that progressive accumulation of debt which must ultimately endanger all governments.\n\nAn estimate of the necessary appropriations, including the expenditures into which we have been driven by the insurrection, will be submitted to Congress.\n\n Gentlemen of the Senate and of the House of Representatives: \n\nThe Mint of the United States has entered upon the coinage of the precious metals, and considerable sums of defective coins and bullion have been lodged with the Director by individuals. There is a pleasing prospect that the institution will at no remote day realize the expectation which was originally formed of its utility.\n\nIn subsequent communications certain circumstances of our intercourse with foreign nations will be transmitted to Congress. However, it may not be unseasonable to announce that my policy in our foreign transactions has been to cultivate peace with all the world; to observe the treaties with pure and absolute faith; to check every deviation from the line of impartiality; to explain what may have been misapprehended and correct what may have been injurious to any nation, and having thus acquired the right, to lose no time in acquiring the ability to insist upon justice being done to ourselves.\n\nLet us unite, therefore, in imploring the Supreme Ruler of Nations to spread his holy protection over these United States; to turn the machinations of the wicked to the confirming of our Constitution; to enable us at all times to root out internal sedition and put invasion to flight; to perpetuate to our country that prosperity which his goodness has already conferred, and to verify the anticipations of this Government being a safeguard of human rights. GO. WASHINGTON\n
#>           president year years_active       party sotu_type
#> 1 George Washington 1790    1789-1793 Nonpartisan    speech
#> 2 George Washington 1790    1789-1793 Nonpartisan    speech
#> 3 George Washington 1791    1789-1793 Nonpartisan    speech
#> 4 George Washington 1792    1789-1793 Nonpartisan    speech
#> 5 George Washington 1793    1793-1797 Nonpartisan    speech
#> 6 George Washington 1794    1793-1797 Nonpartisan    speech

sotu_first_speeches <- sotu %>%
  dplyr::group_by(president) %>%
  dplyr::slice(1)

prepped_sotu <- textnets::PrepText(
  sotu_first_speeches,
  groupvar = "president",
  textvar = "sotu_text",
  node_type = "groups",
  tokenizer = "words",
  pos = "nouns",
  remove_stop_words = TRUE,
  compound_nouns = TRUE
)
#> Downloading udpipe model from https://raw.githubusercontent.com/jwijffels/udpipe.models.ud.2.5/master/inst/udpipe-ud-2.5-191206/english-ewt-ud-2.5-191206.udpipe to /Users/beatrizmilz/GitHub/Pesquisa/2021-SICSS/notes/Day_3-Automated_Text_Analysis/english-ewt-ud-2.5-191206.udpipe
#>  - This model has been trained on version 2.5 of data from https://universaldependencies.org
#>  - The model is distributed under the CC-BY-SA-NC license: https://creativecommons.org/licenses/by-nc-sa/4.0
#>  - Visit https://github.com/jwijffels/udpipe.models.ud.2.5 for model license details.
#>  - For a list of all models and their licenses (most models you can download with this package have either a CC-BY-SA or a CC-BY-SA-NC license) read the documentation at ?udpipe_download_model. For building your own models: visit the documentation by typing vignette('udpipe-train', package = 'udpipe')
#> Downloading finished, model stored at '/Users/beatrizmilz/GitHub/Pesquisa/2021-SICSS/notes/Day_3-Automated_Text_Analysis/english-ewt-ud-2.5-191206.udpipe'
#> Warning: `group_by_()` was deprecated in dplyr 0.7.0.
#> Please use `group_by()` instead.
#> See vignette('programming') for more help

sotu_text_network <- textnets::CreateTextnet(prepped_sotu)

textnets::VisTextNet(sotu_text_network,
                     alpha = .1,
                     label_degree_cut = 3)
#> Using `stress` as default layout
```

<img src="README_files/figure-gfm/unnamed-chunk-26-1.png" style="display: block; margin: auto;" />

## Informações da sessão

``` r
sessioninfo::session_info()
#> ─ Session info ───────────────────────────────────────────────────────────────
#>  setting  value                                      
#>  version  R version 4.1.0 Patched (2021-05-19 r80340)
#>  os       macOS Big Sur 11.3.1                       
#>  system   aarch64, darwin20                          
#>  ui       X11                                        
#>  language (EN)                                       
#>  collate  en_US.UTF-8                                
#>  ctype    en_US.UTF-8                                
#>  tz       America/Sao_Paulo                          
#>  date     2021-05-21                                 
#> 
#> ─ Packages ───────────────────────────────────────────────────────────────────
#>  ! package      * version    date       lib
#>    assertthat     0.2.1      2019-03-21 [3]
#>  P cli            2.5.0      2021-04-26 [?]
#>  P colorspace     2.0-1      2021-05-04 [?]
#>  P crayon         1.4.1      2021-02-08 [?]
#>  P data.table     1.14.0     2021-02-21 [?]
#>    DBI            1.1.1      2021-01-15 [3]
#>  P digest         0.6.27     2020-10-24 [?]
#>  P dplyr        * 1.0.6      2021-05-05 [?]
#>  P ellipsis       0.3.2      2021-04-29 [?]
#>  P evaluate       0.14       2019-05-28 [?]
#>  P fansi          0.4.2      2021-01-15 [?]
#>  P farver         2.1.0      2021-02-28 [?]
#>  P forcats        0.5.1      2021-01-27 [?]
#>  P generics       0.1.0      2020-10-31 [?]
#>    ggforce        0.3.3      2021-03-05 [1]
#>  P ggplot2      * 3.3.3      2020-12-30 [?]
#>    ggraph       * 2.0.5      2021-02-23 [1]
#>    ggrepel        0.9.1      2021-01-15 [1]
#>  P glue           1.4.2      2020-08-27 [?]
#>    graphlayouts   0.7.1      2020-10-26 [1]
#>    gridExtra      2.3        2017-09-09 [1]
#>  P gtable         0.3.0      2019-03-25 [?]
#>  P highr          0.9        2021-04-16 [?]
#>  P htmltools      0.5.1.1    2021-01-22 [?]
#>    htmlwidgets    1.5.3      2020-12-10 [1]
#>    igraph         1.2.6      2020-10-06 [1]
#>  P ISOcodes       2021.02.24 2021-02-24 [?]
#>  P janeaustenr    0.1.5      2017-06-10 [?]
#>  P knitr          1.33       2021-04-24 [?]
#>  P labeling       0.4.2      2020-10-20 [?]
#>  P lattice        0.20-44    2021-05-02 [?]
#>  P lexiconPT    * 0.1.0      2021-05-19 [?]
#>  P lifecycle      1.0.0      2021-02-15 [?]
#>  P lubridate      1.7.10     2021-02-26 [?]
#>  P magrittr     * 2.0.1      2020-11-17 [?]
#>  P MASS           7.3-54     2021-05-03 [?]
#>  P Matrix         1.3-3      2021-05-04 [?]
#>  P modeltools     0.2-23     2020-03-05 [?]
#>  P munsell        0.5.0      2018-06-12 [?]
#>    networkD3    * 0.4        2017-03-18 [1]
#>  P NLP          * 0.2-1      2020-10-14 [?]
#>  P pillar         1.6.1      2021-05-16 [?]
#>  P pkgconfig      2.0.3      2019-09-22 [?]
#>  P plyr           1.8.6      2020-03-03 [?]
#>    polyclip       1.10-0     2019-03-14 [1]
#>  P purrr          0.3.4      2020-04-17 [?]
#>  P R6             2.5.0      2020-10-28 [?]
#>  P Rcpp           1.0.6      2021-01-15 [?]
#>  P reshape2       1.4.4      2020-04-09 [?]
#>  P rlang          0.4.11     2021-04-30 [?]
#>  P rmarkdown      2.8.3      2021-05-20 [?]
#>  P rstudioapi     0.13       2020-11-12 [?]
#>  P scales         1.1.1      2020-05-11 [?]
#>  P sessioninfo    1.1.1      2018-11-05 [?]
#>  P slam           0.1-48     2020-12-03 [?]
#>  P SnowballC      0.7.0      2020-04-01 [?]
#>  P stopwords      2.2        2021-02-10 [?]
#>  P stringi        1.6.2      2021-05-17 [?]
#>  P stringr        1.4.0      2019-02-10 [?]
#>    textnets     * 0.1.1      2021-05-21 [1]
#>  P tibble         3.1.2      2021-05-16 [?]
#>    tidygraph      1.2.0      2020-05-12 [1]
#>  P tidyr          1.1.3      2021-03-03 [?]
#>  P tidyselect     1.1.1      2021-04-30 [?]
#>  P tidytext       0.3.1      2021-04-10 [?]
#>  P tm           * 0.7-8      2020-11-18 [?]
#>  P tokenizers     0.2.1      2018-03-29 [?]
#>  P topicmodels  * 0.2-12     2021-01-29 [?]
#>    tweenr         1.0.2      2021-03-23 [1]
#>    udpipe       * 0.8.5      2020-12-10 [1]
#>  P utf8           1.2.1      2021-03-12 [?]
#>  P vctrs          0.3.8      2021-04-29 [?]
#>    viridis        0.6.1      2021-05-11 [1]
#>  P viridisLite    0.4.0      2021-04-13 [?]
#>  P withr          2.4.2      2021-04-18 [?]
#>  P xfun           0.23       2021-05-15 [?]
#>  P xml2           1.3.2      2020-04-23 [?]
#>  P yaml           2.2.1      2020-02-01 [?]
#>  source                                  
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  Github (sillasgonzaga/lexiconPT@17ac2fd)
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  Github (rstudio/rmarkdown@067a920)      
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  Github (cbail/textnets@42d2366)         
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#>  CRAN (R 4.1.0)                          
#> 
#> [1] /Users/beatrizmilz/GitHub/Pesquisa/2021-SICSS/renv/library/R-4.1/aarch64-apple-darwin20
#> [2] /private/var/folders/z5/nh0wlcsj2fq99rjrj1x7hcwc0000gn/T/RtmpHylj25/renv-system-library
#> [3] /Library/Frameworks/R.framework/Versions/4.1-arm64/Resources/library
#> 
#>  P ── Loaded and on-disk path mismatch.
```
