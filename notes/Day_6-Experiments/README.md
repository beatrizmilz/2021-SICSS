
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Day 6: Experiments

## Pre-arrival

-   Materiais disponíveis em: <https://sicss.io/curriculum>

## What, Why, and Which Experiments?

-   Importância dos grupos de controle

-   Em experimentos digitais, os custos não aumentam, mas é preciso
    pensar mais em questões éticas

-   randomized controlled experiments

## Moving Beyond Simple Experiments

-   Optimization experiment vs Understanding experiments

    -   Understading: desenvolver o entendimento de algum tópico
    -   Optimization: otimizar uma métrica (ex. qual cor de botão faz as
        pessoas clicarem mais?)
    -   Uma forma de otimizar é entender melhor. E otimizar também
        aumenta o entendimento.
    -   Vamos caminhar para fazer experimentos que não são vs, e sim + :
        Optimization + Understanding

-   Ir além dos experimentos simples:

    -   Validity
    -   Heterogeneity of treatment effects
    -   Mechanisms

-   Validity: checklist de formas em que um experimento pode dar errado

    -   statistical conclusion validity: vc fez a estatística correta?
    -   internal validity: seu experimento fez o que vc esperava que
        fizesse? deveria ser mais fácil em experimentos digitais.
    -   construct validity: o que fizemos é uma boa operacionalização da
        “construção” que estamos pensando.
    -   external validity: o experimento é provavel de encontrar
        resultados similares para outros grupos de pessoas ou outras
        formas de operacionalizar o construct. em experimentos digitais,
        é possível repetir o experimento várias vezes, e isso pode
        ajudar a avaliar a external validity.

-   Heterogeneity of treatment effects: experimentos digitais são bons
    nesse caso. Cuidado com o fishing (Tem formas para evitar fishing).

    -   Mechanisms: exemplo de frutas cítricas e escorbuto em pessoas em
        navios antigamente.

## Four Strategies for Making Experiments Happen

-   Custo: dinheiro, tempo

-   Controle: o quanto é possível controlar o ambiente onde está
    acontecendo o experimento

-   Realismo: ambiente parecido ou não com o mundo real

-   Ética: o quanto podemos ter complexidade em termos éticos

-   Tipos de estratégias!

-   Partner with the powerful: fazer parceria com empresas, governos,
    etc

    -   Cost: low
    -   Control: medium
    -   Realism: high
    -   Ethics: potentially complex

-   Just do it yourself: use existing systems

    -   Cost: low
    -   Control: low
    -   Realism: high
    -   Ethics: potentially complex

-   Just do it yourself: build an experiment

    -   Cost: medium
    -   Control: high
    -   Realism: medium
    -   Ethics: relatively easy

-   Just do it yourself: build a product

    -   Cost: high
    -   Control: high
    -   Realism: high
    -   Ethics: relatively easy
    -   Potencial: more research -&gt; better product -&gt; more users
        -&gt; more research -&gt; …

-   Pensar em qual é mais adequado para o contexto da pesquisa.

## Zero Variable Cost Data and Musiclab

-   Experimentos em escala.

-   Pq escala é importante? Permite fazer coisas que antes as pessoas
    nem imaginavam que era possível.

-   Experimento em digital age permite fazer experimentos grandes!

-   Em experimentos analógicos, o aumento do numero de participantes
    causa um aumento do custo da pesquisa. Isso não acontecce com
    experimentos digitais. O aumento de participantes não causa um
    aumento do custo de pesquisa.

-   Principais fontes de custos de “variables” - cada pessoa q participa
    na pesquisa: tempo da equipe, pagamento das pessoas participantes.
    Solução: automatização (os experimentos devem acontecer enquanto
    dormimos), desing experimentos legais (enjoyable).

-   Custo zero de variável para quem?

## 3Rs

Baseado em: The principles of humane experimental technique - by Russell
and Burch (1959)

-   Replace experiments with less invasive methods

-   Refine treatments to make them less harmful

-   Reduce the number of participants.

-   Humane methods.

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
#>  date     2021-06-13                                 
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
#> [2] /private/var/folders/z5/nh0wlcsj2fq99rjrj1x7hcwc0000gn/T/RtmpDdrMdP/renv-system-library
#> [3] /Library/Frameworks/R.framework/Versions/4.1-arm64/Resources/library
#> 
#>  P ── Loaded and on-disk path mismatch.
```
