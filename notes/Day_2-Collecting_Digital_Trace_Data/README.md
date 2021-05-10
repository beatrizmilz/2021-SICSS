
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

### Application Programming Interfaces

Previsto 12/05

### Screen Scraping

Previsto 13/05

### Building Apps and Bots for Social Science Research

Previsto 14/05
