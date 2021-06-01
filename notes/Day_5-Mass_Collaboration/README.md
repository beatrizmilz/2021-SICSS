
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Day 5: Mass Collaboration

## Pre-arrival

-   Materiais disponíveis em: <https://sicss.io/curriculum>

## Introduction to Mass Collaboration

-   O Wikipedia ilustra bem a ideia de Mass Collaboration.

-   Pergunta: Quais são outros problemas intelectuais grandes que
    poderíamos resolver se tivessemos novas formas de colaboração?

-   Colaboração em massa combina ideias de:

    -   Crowdsourcing
    -   Citizen science
    -   Collective Intelligence

-   Grupos:

    -   Human computation
    -   Open call
    -   Distributed data collection

-   Ideia importante: pensar as pessoas como colaboradoras e não como
    cogs (o que é cogs?)

-   Mudar algumas ideias:

-   ~~Isso é pesquisa?~~ -&gt; Isso possibilita fazer novas pesquisas?

-   ~~Isso é perfeito?~~ -&gt; Isso é melhor do que conseguimos fazer
    sem colaboração em massa?

-   ~~Isso é impossível?~~ -&gt; Isso é possível?

## Human Computation

-   Projetos onde tem uma tarefa fácil para fazer. Mas a escala do
    problema é grande, e os humanos fazem melhor a tarefa do que os
    computadores.

-   Estratégia split-apply-combine.

-   Os esforços humanos podem ser ampliados usando aprendizado
    supervisionado (supervised learning).

-   É importante na medida em que caminhamos de dados numéricos de
    surveys para dados textuais, imagens, filmes, audio.

-   Projetos onde tem ajuda de voluntários, é importante ter uma etapa
    de limpeza. Depois, é importante ter uma etapa de de-biasing
    (remover os bias). Depois combinar os resultados.

-   No exemplo dado, depois de ter as labels que os voluntários
    classificaram, isso foi usado para treinar um modelo de machine
    learning.

-   Outro exemplo: crowd-source text analysis. É melhor pois é mais
    barato, e reprodutível.

Artigo citado:
<https://science.sciencemag.org/content/321/5895/1465/tab-pdf>

-   Dificuldade: grande escala do problema.

## Open Call

-   Em alguns casos, as pessoas pesquisadoras não sabem como resolver o
    problema. Abrindo uma open call, pode receber potenciais ideias de
    soluções.

-   Problemas onde as soluções são fáceis de checar, mas não sobre como
    pensar em como resolver.

-   Possibilita avaliar de forma simples e justa.

-   Seleciona a melhor submissão (e não a combinação de submissões, como
    foi é em human computation).

-   Participantes precisam ter habilidades específicas.

-   Exemplos: Netflix Prize, Foldit.

## Distributed Data Collection

-   As pessoas voluntárias podem estar onde as pessoas pesquisadoras não
    conseguem.

-   Claims:

    -   Coleta distribuída de dados é possível para pesquisas reais.
    -   Receios sobre amostragem e qualidade dos dados são superáveis.
    -   Coleta distribuída de dados pode produzir diferentes dados (e
        não apenas de forma mais barata).

-   Exemplos:

    -   eBird: usa “trabalho” que já está acontecendo de qualquer forma;
        é baseado em uma longa tradição de pessoas que pesquisam
        pássaros; coletou muitos dados, em diferentes regiões no mundo.
        Dados são complexos. É difícil avaliar a qualidade dos dados.
        Diferentes habilidades e protocolos usados pelas pessoas
        voluntárias e pesquisadoras.

    -   PhotoCity: a coleta de dados é padronizada devido ao uso de
        cameras; a verificação é automática por comparação de imagens
        similares; os pontos do jogo é calculado baseado na qualidade
        dos dados, isso treina as pessoas a coletarem dados com melhor
        qualidade.

    -   Malawi journal project.

## Fragile Families Challenge

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
#>  date     2021-06-01                                 
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
#> [2] /private/var/folders/z5/nh0wlcsj2fq99rjrj1x7hcwc0000gn/T/Rtmp23pJw5/renv-system-library
#> [3] /Library/Frameworks/R.framework/Versions/4.1-arm64/Resources/library
#> 
#>  P ── Loaded and on-disk path mismatch.
```
