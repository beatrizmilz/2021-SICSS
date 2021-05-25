
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Day 4: Surveys in the Digital Age

## Pre-arrival

-   Materiais disponíveis em: <https://sicss.io/curriculum>

## Survey Research in the Digital Age

-   Vamos falar em custom made data. Mas é legal ter em mente que alguns
    dos trabalhos mais legais são feitos unindo custom-made e ready-made
    data.

-   Baseado no livro bit by bit.

-   Precisamos de surveys mesmo na digital age: especialmente! Tem
    propriedades complementares. Pq?

    -   Limitações de grandes bases de dados: não foi produzida por nós,
        não foi pensada por nós, não é para nós! O tipo de informação
        coletada nem sempre é o que precisamos.

    -   internal states vs external states: é dificil inferir os
        internal states a partir dos external states.

        -   internal states: questões como conhecimento, expectativas
            para o futuro, etc. geralmente é algo que queremos entender,
            ou que ajuda a entender external states.
        -   external states: questões de comportamento, como quantas
            vezes vamos ao médico no último mês, quantos copos de café
            tomou hoje, etc.

    -   Inacessibilidade de grandes bases de dados (principalmente sendo
        pessoas pesquisadoras). Muitas bases de dados que poderiam ser
        úteis são propriedade de alguma organização, e não temos acesso.

-   Como iremos perguntar coisas nas surveys é o que provavelmente vai
    mudar!

-   Mudanças na tecnologia mudam a forma que coletamos os dados. 3 eras
    dos surveys:

    -   1 era: estratégia de amostragem -&gt; area probability;
        entrevistas -&gt; presenciais/cara-a-cara

    -   2 era: estratégia de amostragem -&gt; random digital dial
        probability; entrevistas -&gt; telefone. Quando essa mudança
        aconteceu, houve pesquisadores que contestaram essa forma de
        coleta de dados! Mas essa tecnologia possibilitou diminuir os
        cus tos e tempo de pesquisa.

    -   3 era: estratégia de amostragem -&gt; amostragem não
        probabilística; entrevistas -&gt; administrada por computadores.
        Acha que cada vez mais teremos surveys que são linkadas com
        bases de big data.

-   Total survey error framework: presentes nas primeiras duas eras e
    que é importante para a terceira.

    -   Resumo: um framework pra ajudar a pensar em todas as coisas que
        podem dar errado em um survey!
    -   Ajuda as pessoas pesquisadoras a organizar a survey, pensando os
        erros que podem acontecer, equilibrar o trade-off: menor
        possibilidade de erro possível para um budget disponível.
    -   Insight 1: erros podem vir de bias ou variância (tem uma
        ilustração interessante).
    -   Insight 2: erros podem vir de erros de medição (como conseguimos
        aprender com as pessoas que estamos entrevistando) ou erros de
        representação (falamos com uma amostra de pessoas, e queremos
        fazer uma inferência sobre a população).
        -   Exemplo sobre o trump e a eleição: se o que queremos estimar
            está mudando, surveys não vão conseguir obter bons
            resultados. Nesse exemplo, teve muito mais respostas de
            pessoas que tinham ensino superior, mas isso não foi
            ajustado bem posteriormente, o que influenciou no resultado
            (problema de representação). Além disso, algumas pessoas que
            votam no trump não revelaram isso na pesquisa (problema de
            medição).
    -   o TSEF ajuda também a pensar como a digital age pode criar novas
        oportunidades (a quem perguntar, como perguntar)
    -   Sugestão de leitura sobre TSEF: [Groves *et al.*,
        2009](https://www.wiley.com/en-us/Survey+Methodology%2C+2nd+Edition-p-9780470465462)

## Probability and Non-Probability Sampling

…

## Computer-Administered Interviews

…

## Combining Surveys and Big Data

…

## Additions and Extension

…

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
#>  date     2021-05-25                                 
#> 
#> ─ Packages ───────────────────────────────────────────────────────────────────
#>  ! package     * version date       lib source                            
#>  P cli           2.5.0   2021-04-26 [?] CRAN (R 4.1.0)                    
#>  P digest        0.6.27  2020-10-24 [?] CRAN (R 4.1.0)                    
#>  P evaluate      0.14    2019-05-28 [?] CRAN (R 4.1.0)                    
#>  P htmltools     0.5.1.1 2021-01-22 [?] CRAN (R 4.1.0)                    
#>  P knitr         1.33    2021-04-24 [?] CRAN (R 4.1.0)                    
#>  P magrittr      2.0.1   2020-11-17 [?] CRAN (R 4.1.0)                    
#>  P rlang         0.4.11  2021-04-30 [?] CRAN (R 4.1.0)                    
#>  P rmarkdown     2.8.3   2021-05-20 [?] Github (rstudio/rmarkdown@067a920)
#>  P sessioninfo   1.1.1   2018-11-05 [?] CRAN (R 4.1.0)                    
#>  P stringi       1.6.2   2021-05-17 [?] CRAN (R 4.1.0)                    
#>  P stringr       1.4.0   2019-02-10 [?] CRAN (R 4.1.0)                    
#>  P withr         2.4.2   2021-04-18 [?] CRAN (R 4.1.0)                    
#>  P xfun          0.23    2021-05-15 [?] CRAN (R 4.1.0)                    
#>  P yaml          2.2.1   2020-02-01 [?] CRAN (R 4.1.0)                    
#> 
#> [1] /Users/beatrizmilz/GitHub/Pesquisa/2021-SICSS/renv/library/R-4.1/aarch64-apple-darwin20
#> [2] /private/var/folders/z5/nh0wlcsj2fq99rjrj1x7hcwc0000gn/T/RtmpedKqUw/renv-system-library
#> [3] /Library/Frameworks/R.framework/Versions/4.1-arm64/Resources/library
#> 
#>  P ── Loaded and on-disk path mismatch.
```
