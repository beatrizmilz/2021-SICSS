
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

-   Esse video vai focar na 3 era do survey.

-   Senso comum antigamente: amostragem não probabilística é ruim. Como
    ele vê agora:

    -   Amostragem probabilistica: unknown sampling process, weighting
        based of unverifiable assumptions
    -   Amostragem não-probabilística: unknown sampling process,
        weighting based of unverifiable assumptions
    -   Tem muitos níveis de non-response. Por isso, a questão de a.
        probabilistica X a. não-probabilistica é muito mais complicada.

-   Probability sample (roughly):

    -   every unit from a frame population has a known and non-zero
        probability of inclusion
    -   not all probability samples look like miniature versions of the
        population
    -   with appropriate weighting, probability samples can yield
        unbiased estimates of the frame population.
    -   how you collect your data impacts how you make inference
    -   focus on properties of estimators not properties samples
    -   na equação horivtz-thompson estimator, é preciso saber a
        probabilidade de que alguem seja incluído na pesquisa, porém é
        difícil saber (principalmente pensando na taxa de não-resposta).

-   Inferência de amostragem probabilística

    -   na teoria: respondents + known information about sampling -&gt;
        estimates
    -   na prática: respondents + estimated information about sampling
        (auxiliary information + assumptions) -&gt; estimates

-   Inferência de amostragem não-probabilística

    -   na prática: respondents + estimated information about sampling
        (auxiliary information + assumptions) -&gt; estimates

-   O que quer dizer? Não tem grandes diferenças entre a amostragem
    probabilística e não probabilística na prática.

-   Weighted estimate uses auxiliary information and assumptions (no meu
    caso: acho que é interessante pensar na composição % do comitê!)

-   No geral: amostragem probabilística na prática -&gt; menos erros e
    mais custos; amostragem não-probabilística -&gt; mais erros e menos
    custos. Autor acha que os erros tendem a diminuir.

-   Nem todas as pessoas estarão dispostas a participar da pesquisa, e
    precisamos pensar nisso e ajustar na hora de estimar.

-   Sugestões de leitura:

    -   Sampling: Design and Analysis - Lohr (2009)
    -   Model Assisted Survey Sampling - Sarndal *et al* (2013).

## Computer-Administered Interviews

-   Esse video vai focar na 3 era do survey.

-   Antigamente, as surveys eram administradas por humanos: pessoalmente
    ou telefone.

-   Estamos migrando para surveys administradas por computadores:
    possibilita mudanças, pensar quais são as mudanças necessárias.

-   Schober et al 2015: resultados: os dados coletados através de
    mensagem de texto resultou em dados de qualidade melhor.

-   We can and should take advantage of the tools of the digital age to
    ask in new ways

## Combining Surveys and Big Data

-   Esse video vai focar na 3 era do survey.

-   Big data não é subtituto de survey, o melhor é pensar que podem ser
    pensado como complementares.

-   2 approaches:

    -   Enriched asking: record linkage between big data and survey
        data, e esse join é usado na pesquisa. Ex de leitura:
        [Ansolabehere and Hersh,
        2012](https://www.cambridge.org/core/journals/political-analysis/article/validation-what-big-data-reveal-about-survey-misreporting-and-the-real-electorate/8EAEC7B63CD44AED85075AB4FF5BE4F0).

    -   Ampliflied asking: Temos dados de survey para x pessoas (survey
        data), e temos uma base de big data para x + y pessoas (big data
        source). Usar isso para estimar o modelo e predict a possível
        resposta de survey das pessoas y (imputed survey data).
        Amplifica os dados de survey, e o que usa na pesquisa é os dados
        de survey (originais e imputados). Ex de leitura: [Predicting
        poverty and wealth from mobile phone
        metadata](https://science.sciencemag.org/content/350/6264/1073/tab-pdf).
        É difícil saber se os resultados estão corretos, mas é mais
        rápido e mais barato de fazer este tipo de pesquisa do que fazer
        o survey para as pessoas x + y.

## Additions and Extension

1.  Wiki surveys. princípios gerais: greedy, collaborative (construído
    de forma conjunta), adaptive (usar informações que obtemos para
    tornar a coleta de dados mais eficiente). É uma nova forma de
    interagir com respondentes, e não uma forma de amostragem.

-   <https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0123483>

-   <https://www.allourideas.org/>

2.  Amplified asking -&gt; deep learning

-   <https://github.com/nealjean/predicting-poverty>

-   <http://sustain.stanford.edu/predicting-poverty>

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
