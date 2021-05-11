
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Day 2: Collecting Digital Trace Data

## Pre-arrival

-   Materiais disponíveis em: <https://sicss.io/curriculum>

### What is Digital Trace Data?

-   “Pegadas digitais”. Novas possibilidades de acompanhar/estudar o
    comportamento humano em maior escala. Enquanto interagimos com a
    tecnologia, estamos deixando rastros digitais" do nosso
    comportamento.

-   Mostrou um exemplo de estudo: Eagle et al. 2010. O que podemos
    aprender com os dados? No estudo mostrado, a diversidade da rede de
    contatos das pessoas e as pessoas que elas conectavam nas redes
    sociais foram relacionadas com desigualdade econômica e diversidade.

-   Dados de celular! Onde as pessoas estão? Estão em casa? Relacionado
    com COVID-19: no futuro (talvez próximo) poderemos saber se as
    pessoas estão respeitando a quarentena (ou outras regras).

-   Digital trace data: são grandes bases de dados digitais, que
    permitem estudar o comportamento humano em uma escala jamais vista.
    Exemplo: redes sociais, dados de pesquisa na internet, blogs, dados
    geo-espaciais, audio-visual, arquivos históricos, registros
    administrativos. Qualquer tipo de pegada digital que deixamos! Esses
    dados nos permitem viajar no tempo, é possível acessar uma página da
    internet no passado.

-   Esses dados raramente são “perfeitos”. Falamos anteriormente que em
    CS separamos os dados “custom-made” e os dados “ready-made” (falado
    anteriormente na [aula
    1-1](https://github.com/beatrizmilz/2021-SICSS/blob/master/notes/Day_1-Introduction_and_Ethics/README.md#introduction-to-computational-social-science)).
    Nesse caso, os dados que usamos aqui são mais “ready-made”: são
    dados criados com um objetivo, e usamos esses dados com outros
    objetivos.

### Strengths and Weakness of Digital Trace Data

-   “Forças” da Digital trace data:

    -   Big: tem mais dados, e dados muito grandes! Avanços em poder
        computacional também permite que a gente consiga
        coletar/analisar esses dados.

    -   Always on: sempre disponível. Exemplo: redes sociais apresentam
        um registro do que está acontecendo on-line.

    -   Non-reactive: não resulta de uma interação onde a pessoa
        pesquisadora pergunta a opinião de uma pessoa que está
        participando do estudo (ex. entrevista, survey, grupo focal,
        etc). Isso é bem relevante quando se trata de pesquisas onde as
        perguntas feitas na entrevista/survey/grupo focal são de temas
        que possam constranger as pessoas participantes, e que elas não
        queiram responder.

    -   Capture social relationships: conseguimos dados das redes
        sociais.

-   “Fraquezas” da Digital trace data:

    -   Inaccessible: muito dos dados (e muitos dados valiosos para
        entender o comportamento humano) atualmente é inacessível, pois
        estão na posse de grandes empresas (como Google, Apple, Amazon,
        etc). Muitas vezes elas não podem disponibilizar essas bases de
        dados por questões legais.

    -   Non-representative: os dados não representam a população
        inteira. Pensando em redes sociais: % de pessoas da população
        que usa essa rede, pensar na presença grupos em termos de idade,
        sexo, urbano/rural, grupos minoritários, etc. Se queremos
        estudar dados de, por exemplo, twitter, precisamos estar cientes
        dessas vieses. E essas porcentagens da população nas redes
        sociais muda ao longo do tempo, e entre as plataformas. E se os
        dados conter vieses (bias), e não reflete fielmente a população
        que estamos tentando estudar?

    -   Drifting: as plataformas usadas mudam com o tempo, as pessoas
        migram de redes sociais (ex: myspace -&gt; facebook). A relação
        entre as pessoas e as plataformas usadas também muda com o
        tempo. Então precisamos ter atenção à isso: se queremos estudar
        um intervalo de tempo, pensar em quais plataformas eram usadas
        nesse período (e por quem).

    -   Algorithimically confounded: situação onde um algoritmo dentro
        de uma plataforma digital é alterado, e isso cria uma mudança no
        que vemos de comportamento humano. Interpretamos essa mudança
        como algo significativo, porém pode ser apenas a forma como as
        pessoas estão interagindo com o algoritmo. A caixa preta de ML:
        em alguns casos, não sabemos o que está causando algo.

    -   Unstructured: os dados são bagunçados e não estruturados! A
        maior parte do tempo das pessoas que trabalham com ciência de
        dados é usada limpando e arrumando dados!

    -   Sensitive: muitas pegadas digitais são informações privadas e
        sensíveis. Ex: dados de redes de relacionamento (ok cupid).

    -   Incomplete: os dados podem estar incompletos. Em alguns casos
        está relacionado as regras da plataforma usada para coletar os
        dados.

    -   Elite/publication bias: teremos uma fotografia distorcida da
        realidade. Em alguns casos, as informações encontradas são a
        visão de pessoas em situação privilegiada (ex comum em
        documentos históricos). Ex nas redes sociais: as pessoas estão
        postando coisas para fazer com que elas tenham mais status (look
        better).

    -   Positivity-bias: Nas redes sociais, as pessoas postam mais
        coisas positivas, e não postam tanto as coisas negativas.

-   O futuro do digital trace data: temos que encontrar formas de nos
    aproveitar das forças do DTD, ao mesmo tempo reconhecer as fraquezas
    de DTD (e lidar com isso). As melhores pesquisas futuras em CSC
    serão híbridas: usando dados ready-made e custom-made.

### Application Programming Interfaces (API)

-   O que é uma API?

    -   É uma das principais ferramentas usadas na CSC que quer estudar
        digital trace data.

    -   Possibilita coletar dados de algumas redes sociais, mas não
        apenas!

    -   A API possibilita alguns grupos de pessoas a acessarem alguns
        tipos de dados. Os dados disponíveis pode depender devido às
        credenciais (credentials).

    -   Muitas APIs não são públicas: existem dentro de uma empresa, ou
        entre duas companhias para transmitir dados.

    -   O número de APIs está crescendo! Pesquisar por APIs

        -   [Programmable
            Web](https://www.programmableweb.com/category/all/apis)
        -   [Any API](https://any-api.com/)

-   Como uma API funciona?

    -   Para criar a URL para buscar dados em uma API: Base API URL +
        Requested Filds/Data (endpoints) + Data format requested
        (usually JSON) + Query + API Key (credential/token)

    -   JSON é uma forma eficiente para armazenar dados, e é muito usado
        em API

    -   Para usar a API, lemos a documentação para descobrir como criar
        as URLs que devemos usar. A documentação é um manual.

    -   API credential/access token: algumas APIs não pedem credenciais.

    -   Rate limiting: uma API tem regras sobre a quantidade de dados
        que é permitido coletar em um intervalo determinado de tempo.
        Entender isso, e se necessário, colocar pausas no código.
        Throttling: o site mostra que está perto de atingir o rate limit
        e retorna os dados cada vez mais devagar.

    -   Exemplo com twitter: buscar dados na API do twitter. Usar no
        maximo n = 18 mil. Essa busca com a API simples só busca os
        dados recentes. O argumento `retryonratelimit` da função
        `rtweet::search_tweets()` é útil nesse caso.

-   Autenticando:

``` r
# install.packages("rtweet")
library(magrittr, include.only = "%>%")

# A forma de realizar a autenticação mostrada no video 
# estava gerando um erro. Nas issues do pacote, encontrei
# outras pessoas com o mesmo erro. Uma das sugestões que
# encontrei por lá é essa função bearer_token(), 
# que funcionou bem :)

rtweet::bearer_token()
```

-   Buscando os tweets

``` r
# Fiz a pesquisa com outro termo..
tweets <- rtweet::search_tweets(
  q = "rstats", # query para buscar
  n = 4000,  # número de tweets para coletar
  include_rts = FALSE # queremos os RTs ou não?
  )

# salvei o resultado pra nao precisar ficar coletando
# sempre que eu executar esse código (é demorado)

readr::write_rds(tweets, file = "exemplo_tweets.Rds")
```

``` r
# abrindo os tweets salvos
tweets_salvos <- readr::read_rds("exemplo_tweets.Rds")

# carregando apenas o pipe:
library(magrittr, include.only = "%>%") 

# não quero ver a base toda, tem muitas colunas!
tweets_salvos %>% 
  dplyr::select(created_at, screen_name, text) 
#> # A tibble: 4,000 x 3
#>    created_at          screen_name   text                                       
#>    <dttm>              <chr>         <chr>                                      
#>  1 2021-05-11 12:55:22 theRcast      "A great surprise to start the ☀️ : My abst…
#>  2 2021-05-11 12:52:10 theRcast      "A great surprise to start the ☀️: My abstr…
#>  3 2021-05-08 12:52:09 theRcast      "@moriah_taylor58 That's great! We are sta…
#>  4 2021-05-11 10:56:57 theRcast      "My week of ✍️ ➕🎙 for #rstats @rweekly_org …
#>  5 2021-05-05 13:27:17 theRcast      "@cantabile {renv} is the easiest path to …
#>  6 2021-05-07 12:51:36 vsni          "Our free tool ASRgenomics offers molecula…
#>  7 2021-05-11 12:45:56 vsni          "ASRgenomics facilitates the generation of…
#>  8 2021-05-07 12:53:39 ASreml        "Our free tool ASRgenomics offers molecula…
#>  9 2021-05-11 12:43:45 ASreml        "ASRgenomics facilitates the generation of…
#> 10 2021-05-08 18:41:00 SourabhSKato… "Learn Practical Text Classification With …
#> # … with 3,990 more rows
```

-   Quais são as colunas presentes?

``` r
names(tweets_salvos)
#>  [1] "user_id"                 "status_id"              
#>  [3] "created_at"              "screen_name"            
#>  [5] "text"                    "source"                 
#>  [7] "display_text_width"      "reply_to_status_id"     
#>  [9] "reply_to_user_id"        "reply_to_screen_name"   
#> [11] "is_quote"                "is_retweet"             
#> [13] "favorite_count"          "retweet_count"          
#> [15] "quote_count"             "reply_count"            
#> [17] "hashtags"                "symbols"                
#> [19] "urls_url"                "urls_t.co"              
#> [21] "urls_expanded_url"       "media_url"              
#> [23] "media_t.co"              "media_expanded_url"     
#> [25] "media_type"              "ext_media_url"          
#> [27] "ext_media_t.co"          "ext_media_expanded_url" 
#> [29] "ext_media_type"          "mentions_user_id"       
#> [31] "mentions_screen_name"    "lang"                   
#> [33] "quoted_status_id"        "quoted_text"            
#> [35] "quoted_created_at"       "quoted_source"          
#> [37] "quoted_favorite_count"   "quoted_retweet_count"   
#> [39] "quoted_user_id"          "quoted_screen_name"     
#> [41] "quoted_name"             "quoted_followers_count" 
#> [43] "quoted_friends_count"    "quoted_statuses_count"  
#> [45] "quoted_location"         "quoted_description"     
#> [47] "quoted_verified"         "retweet_status_id"      
#> [49] "retweet_text"            "retweet_created_at"     
#> [51] "retweet_source"          "retweet_favorite_count" 
#> [53] "retweet_retweet_count"   "retweet_user_id"        
#> [55] "retweet_screen_name"     "retweet_name"           
#> [57] "retweet_followers_count" "retweet_friends_count"  
#> [59] "retweet_statuses_count"  "retweet_location"       
#> [61] "retweet_description"     "retweet_verified"       
#> [63] "place_url"               "place_name"             
#> [65] "place_full_name"         "place_type"             
#> [67] "country"                 "country_code"           
#> [69] "geo_coords"              "coords_coords"          
#> [71] "bbox_coords"             "status_url"             
#> [73] "name"                    "location"               
#> [75] "description"             "url"                    
#> [77] "protected"               "followers_count"        
#> [79] "friends_count"           "listed_count"           
#> [81] "statuses_count"          "favourites_count"       
#> [83] "account_created_at"      "verified"               
#> [85] "profile_url"             "profile_expanded_url"   
#> [87] "account_lang"            "profile_banner_url"     
#> [89] "profile_background_url"  "profile_image_url"
```

-   Criar um gráfico

``` r
dia_min <- format(min(tweets_salvos$created_at), "%d/%m")
dia_max <- format(max(tweets_salvos$created_at), "%d/%m")

tweets_salvos %>% 
  rtweet::ts_plot(by = "hours") +
  ggplot2::theme_minimal() + 
  ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(x = "Data", y = "Número de tweets",
                title = glue::glue("Frequência de tweets sobre rstats, entre os dias {dia_min} e {dia_max}"),
                subtitle = "Contagem de tweets agregado por hora",
                caption = "\nFonte: Dados coletados da API do Twitter, através do pacote {rtweet}.")
```

<img src="README_files/figure-gfm/unnamed-chunk-6-1.png" style="display: block; margin: auto;" />

-   Ver os tweets em uma região (EUA)

``` r
geo_tweets <- rtweet::search_tweets(
  q = "rstats", # query para buscar
  n = 4000,  # número de tweets para coletar
  include_rts = FALSE, # queremos os RTs ou não?
  geocode = rtweet::lookup_coords("usa"),
  type = "recent"
  )

# salvei o resultado pra nao precisar ficar coletando
# sempre que eu executar esse código (é demorado)

readr::write_rds(geo_tweets, file = "exemplo_geo_tweets.Rds")
```

``` r
# abrindo os tweets salvos
tweets_geo_salvos <- readr::read_rds("exemplo_geo_tweets.Rds")

# arrumando as colunas lat long
geocoded <- rtweet::lat_lng(tweets_geo_salvos)
```

``` r
# plotando o mapa com o pacote maps
par(mar = c(0, 0, 0, 0))
maps::map("world", lwd = .25)
with(geocoded, points(
  lng,
  lat,
  pch = 20,
  cex = .50,
  col = rgb(0, .3, .7, .75)
))
```

<img src="README_files/figure-gfm/unnamed-chunk-9-1.png" style="display: block; margin: auto;" />

``` r
world <-
  rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")

sf_usa <-
  world %>% dplyr::filter(admin == "United States of America")

geocoded_filtrado_sf <- geocoded %>%
  tidyr::drop_na(lat, lng) %>%
  sf::st_as_sf(coords = c("lng", "lat"), crs = 4326)

dia_min <- format(min(geocoded_filtrado_sf$created_at), "%d/%m")
dia_max <- format(max(geocoded_filtrado_sf$created_at), "%d/%m")


  geocoded_filtrado_sf %>% 
  ggplot2::ggplot() +
  ggplot2::geom_sf(data = sf_usa) +
  ggplot2::geom_sf(color = rgb(0, .3, .7, .75)) +
  ggplot2::theme_bw() +
  ggplot2::coord_sf(xlim = c(-127, -65),
                    ylim = c(23, 51),
                    expand = FALSE) +
  ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = "Longitude",
    y = "Latitude",
    title = glue::glue(
      "Tweets sobre rstats entre os dias {dia_min} e {dia_max}"
    ),
    subtitle = "Tweets que informaram a localização, e postados nos EUA",
    caption = "\nFonte: Dados coletados da API do Twitter, através do pacote {rtweet}."
  )
```

<img src="README_files/figure-gfm/unnamed-chunk-10-1.png" style="display: block; margin: auto;" />

-   No exemplo, mostrou mais coisas que podemos fazer com o pacote
    rtweet.

-   Função pra checar o rate limit:

``` r
head(rtweet::rate_limit()[50:55, 1:4])
#> # A tibble: 6 x 4
#>   query                                             limit remaining reset       
#>   <chr>                                             <int>     <int> <drtn>      
#> 1 users/by/username/:source_username/following&POST    50        50 15.02709 mi…
#> 2 users/:id/followers                                  15        15 15.02709 mi…
#> 3 users/suggestions/:slug/members                      15        15 15.02709 mi…
#> 4 users/:id/following                                  15        15 15.02709 mi…
#> 5 users/:id/mentions                                  180       180 15.02709 mi…
#> 6 users/by/username/:username                         900       900 15.02709 mi…
```

-   Postar tweets: `rtweet::post_tweet()`

-   Podemos fazer um loop para repetir a busca :)

-   APIs podem ser usadas não apenas para coletar dados, mas também para
    visualização/análise/modelagem

-   Desafios ao trabalhar com APIs:

    -   Muitos dados ainda não estão disponíveis publicamente.

    -   Cada API tem seus padrões, então aprender a usar uma API
        significa que precisamos ler com cuidado a documentação.

-   O final do video está repetido.

### Screen Scraping

Previsto 13/05

### Building Apps and Bots for Social Science Research

Previsto 14/05
