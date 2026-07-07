# Feed do SIMETBox para o projeto OpenWRT

Arquivos necessários para poder compilar e instalar o sistema SIMETBox nas distribuições OpenWRT (25.12, 24.10, 23.05, 22.03, 20.02).

Há suporte limitado ao OpenWRT 19.07 e 18.06, e suporte *muito* limitado ao OpenWRT "Chaos Calmer" (15.05) e lede-17.01.  Nestes casos, é necessário que o openwrt seja atualizado com alguns backports (do openwrt, luci e packages) disponíveis em simetnicbr/openwrt-openwrt, simetnicbr/openwrt-luci e simetnicbr/openwrt-packages.

Documetação para integradores e hardware vendors, estará disponível em arquivos no subdiretório docs/.  Atentem para o fato de, na maioria das vezes, essa documentação não ser especial para o OpenWRT, e portanto estar disponibilizada *no pacote simet-ma upstream*.

* https://docs.medicoes.nic.br/
* https://github.com/simetnicbr/simet-ma/tree/master/docs

# Sobre o SIMETBox

O SIMETBox é um sistema inicialmente desenvolvido para roteadores com OpenWRT para medir a qualidade de vários quesitos na internet.  Várias medições de qualidade são realizadas utilizando servidores localizados nos ISPs ou no IX.br: vazão, perda de pacotes, latência e jitter, e traceroutes.  Também realiza medições suplementares como filtragem anti-spoofing de origem, latência de resposta DNS e validação de DNSSEC.

Os resultados ficam disponíveis aos usuários através de interface WEB e ao provedor através de [portal](https://pas.nic.br) próprio para isto.

## Pacotes que compõem o projeto e o que medem

1. simetbox-openwrt-simet-ma (motor de medição SIMET2 -- obrigatório!)

2. simetbox-openwrt-simet-lmapd (componente do motor de medição -- obrigatório!)

3. simetbox-openwrt-luci (aba da interface WEB para os resultados do SIMETBox)

outros pacotes que são dependências obrigatórias serão ativados automaticamente.


## Instalação

O feed do SIMETBox se integra com os projeto [OpenWRT](http://openwrt.org).  Para que possa ser fechada uma distribuição com ele é necessário que se compile a imagem para o roteador desejado a partir do código fonte dos projetos.

Não é recomendado utilizar o "openwrt-18.06" e posteriores (inclusive openwrt "master") em equipamentos com menos de 64MiB de RAM: nestes casos, o lede-17.01 é mais estável.  Ainda assim, em equipamentos com apenas 32MiB de RAM, podem haver problemas durante "sysupgrade" via interface web e é necessário utilizar tr-069, ssh, ou tftp via bootloader para atualização.  Esta é uma limitação do firmware openwrt, e não das extensões simetbox.  Nesses casos, considerar remover os pacotes que ocupam memória o tempo inteiro (como zabbix).

### problemas comuns de build

O OpenWRT em versões mais recentes (20.02 e mais recentes, talvez 19.07) pode falhar o build de uma imagem de firmware por colisão ao tentar instalar um pacote "default" como ustream-mbedtls ou dnsmasq, *que o openwrt força a ser instalado na imagem mesmo se configurado para M*, com um outro pacote como ustream-opentls ou dnsmasq-full, que foi selecionado para ser instalado na imagem (configurado como "Y").  Neste caso, a solução é ter ambos selecionados como "M" para que a compilação tenha sucesso (e a imagem normal *não vai incluir nenhum dos dois pacotes, portanto provavelmente não será funcional*), e utilizar o ImageBuilder para gerar uma imagem de firmware funcional, incluindo o(s) pacote(s) desejado(s) e removendo o(s) pacote(s) "default" indesejados (por exemplo: na lista de pacotes informadas ao imagebuilder, especificar "-dnsmasq" para remover o dnsmasq default, e especificar "dnsmasq-full" para instalar o dnsmasq-full em seu lugar).

### Evitar build do postgresql

Em versões recentes do OpenWRT, ao selecionar o pacote simetbox-openwrt-zabbix, ele vai selecionar o pacote zabbix-agentd.  Compilar o zabbix-agentd compila também (mesmo que desmarcados) o servidor Zabbix, que precisa (por padrão) do postgresql, e isso aumenta bastante o peso/tempo de build.  Configure o OpenWRT para que o banco do Zabbix seja o "embedsql", e o build vai ficar muito mais rápido, ou não use o pacote simetbox-openwrt-zabbix.


## Regras de Firewall

Não são necessárias regras adicionais para que as medições sejam realizadas.

Caso haja interesse em configurar regras, como por exemplo endereços IPs que possam acessar a porta 80 (http) da interface WAN, deve-se seguir estes passos:

* Na interface WEB vá em Network \-\> Firewall \-\> Open ports on router  

> Name: Gerencia  
> Protocol: TCP  
> External port: 80  

* Aplique e salve a regra. Para filtrar o IP de origem (recomendado) vá no novo item que surgiu chamado "Gerencia" e clique em editar. No campo "Source address" escolha "Custom" e coloque o endereço IP de origem da conexão.

Este processo pode ser repetido para quantos filtros forem necessários serem colocados. Os nomes dos filtros devem ser diferentes.

## Contribuições ao projeto

1. Crie um branch para a funcionalidade que foi desenvolvida: `git checkout -b <nova-funcionalidade>`
2. Envie sua alteração: `git commit -am '<descrição-da-funcionalidade>'`
3. Faça um push para o branch: `git push origin <nova-funcionalidade>`
4. Faça um pull request :D


## Como usar o sistema para fazer medições

A mais tradicional para realizar testes é através da configuração da frequência de testes na aba SIMET/Configurações na interface WEB do roteador. Porém, caso o usuário queira fazer um determinado teste pontual é possível. Para isto deve ser feito um ssh para o equipamento (é importante definir uma senha via interface WEB primeiro) usando o usuário root.  


# AVISOS

* PROVEDORES E INTEGRADORES: se precisam de uma SIMETBox devido a editais como FUST e EACE,
  leiam a documentação em https://docs.medicoes.nic.br/simet-integrado/ e entrem em contato
  com nosso suporte antes de tentar compilar e usar o SIMETBox para atender esses editais.
  É necessário *parametrizar* e homologar o firmware resultante (processo gratuíto, mas é
  best-effort e pode demorar).


# Histórico

* 2017-05-24 - Primeiro release público
* 2018-05-29 - Atualização para adequação ao LEDE-17.01 e OpenWRT-18.06
* 2026-07-07 - SIMET1 foi descomissionado e removido do SIMETBox.

# TODO

* Documentar melhor o processo de build, e publicar como exemplo Dockefiles de build-containers.

# Créditos

NIC.br
<medicoes@simet.nic.br>

# License

## Aggregated work license
* Copyright (c) 2012-2026 NIC.br
* Overall source code license is GNU GPL version 3, with extra clauses

## Source-code file-specific licenses
* Copytight attribution and copyright licenses are present in individual source code files
* Several different source code licenses, compatible with the GNU GPL version 3
