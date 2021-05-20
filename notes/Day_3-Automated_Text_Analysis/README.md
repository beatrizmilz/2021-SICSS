
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

## Informações da sessão

``` r
sessioninfo::session_info()
#> ─ Session info ───────────────────────────────────────────────────────────────
#>  setting  value                                 
#>  version  R version 4.1.0 RC (2021-05-17 r80314)
#>  os       macOS Big Sur 11.2.3                  
#>  system   aarch64, darwin20                     
#>  ui       X11                                   
#>  language (EN)                                  
#>  collate  en_US.UTF-8                           
#>  ctype    en_US.UTF-8                           
#>  tz       America/Sao_Paulo                     
#>  date     2021-05-20                            
#> 
#> ─ Packages ───────────────────────────────────────────────────────────────────
#>  ! package     * version date       lib
#>    assertthat    0.2.1   2019-03-21 [3]
#>  P cli           2.5.0   2021-04-26 [?]
#>  P colorspace    2.0-1   2021-05-04 [?]
#>  P crayon        1.4.1   2021-02-08 [?]
#>    DBI           1.1.1   2021-01-15 [3]
#>  P digest        0.6.27  2020-10-24 [?]
#>  P dplyr         1.0.6   2021-05-05 [?]
#>  P ellipsis      0.3.2   2021-04-29 [?]
#>  P evaluate      0.14    2019-05-28 [?]
#>  P fansi         0.4.2   2021-01-15 [?]
#>  P farver        2.1.0   2021-02-28 [?]
#>  P forcats       0.5.1   2021-01-27 [?]
#>  P generics      0.1.0   2020-10-31 [?]
#>  P ggplot2       3.3.3   2020-12-30 [?]
#>  P glue          1.4.2   2020-08-27 [?]
#>  P gtable        0.3.0   2019-03-25 [?]
#>  P highr         0.9     2021-04-16 [?]
#>  P htmltools     0.5.1.1 2021-01-22 [?]
#>  P janeaustenr   0.1.5   2017-06-10 [?]
#>  P knitr         1.33    2021-04-24 [?]
#>  P labeling      0.4.2   2020-10-20 [?]
#>  P lattice       0.20-44 2021-05-02 [?]
#>  P lexiconPT   * 0.1.0   2021-05-19 [?]
#>  P lifecycle     1.0.0   2021-02-15 [?]
#>  P lubridate     1.7.10  2021-02-26 [?]
#>  P magrittr    * 2.0.1   2020-11-17 [?]
#>  P Matrix        1.3-3   2021-05-04 [?]
#>  P modeltools    0.2-23  2020-03-05 [?]
#>  P munsell       0.5.0   2018-06-12 [?]
#>  P NLP         * 0.2-1   2020-10-14 [?]
#>  P pillar        1.6.1   2021-05-16 [?]
#>  P pkgconfig     2.0.3   2019-09-22 [?]
#>  P plyr          1.8.6   2020-03-03 [?]
#>  P purrr         0.3.4   2020-04-17 [?]
#>  P R6            2.5.0   2020-10-28 [?]
#>  P Rcpp          1.0.6   2021-01-15 [?]
#>  P reshape2      1.4.4   2020-04-09 [?]
#>  P rlang         0.4.11  2021-04-30 [?]
#>  P rmarkdown     2.8.3   2021-05-20 [?]
#>  P rstudioapi    0.13    2020-11-12 [?]
#>  P scales        1.1.1   2020-05-11 [?]
#>  P sessioninfo   1.1.1   2018-11-05 [?]
#>  P slam          0.1-48  2020-12-03 [?]
#>  P SnowballC     0.7.0   2020-04-01 [?]
#>  P stringi       1.6.2   2021-05-17 [?]
#>  P stringr       1.4.0   2019-02-10 [?]
#>  P tibble        3.1.2   2021-05-16 [?]
#>  P tidyr         1.1.3   2021-03-03 [?]
#>  P tidyselect    1.1.1   2021-04-30 [?]
#>  P tidytext      0.3.1   2021-04-10 [?]
#>  P tm          * 0.7-8   2020-11-18 [?]
#>  P tokenizers    0.2.1   2018-03-29 [?]
#>  P topicmodels * 0.2-12  2021-01-29 [?]
#>  P utf8          1.2.1   2021-03-12 [?]
#>  P vctrs         0.3.8   2021-04-29 [?]
#>  P viridisLite   0.4.0   2021-04-13 [?]
#>  P withr         2.4.2   2021-04-18 [?]
#>  P xfun          0.23    2021-05-15 [?]
#>  P xml2          1.3.2   2020-04-23 [?]
#>  P yaml          2.2.1   2020-02-01 [?]
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
#>  Github (rstudio/rmarkdown@067a920)      
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
#> 
#> [1] /Users/beatrizmilz/GitHub/Pesquisa/2021-SICSS/renv/library/R-4.1/aarch64-apple-darwin20
#> [2] /private/var/folders/z5/nh0wlcsj2fq99rjrj1x7hcwc0000gn/T/Rtmpw4zTkm/renv-system-library
#> [3] /Library/Frameworks/R.framework/Versions/4.1-arm64/Resources/library
#> 
#>  P ── Loaded and on-disk path mismatch.
```
