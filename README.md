# Feed do SIMETBox para o projeto OpenWRT

Arquivos necessários para poder compilar e instalar o sistema SIMETBox nas distribuições OpenWRT (master, 19.07, 18.06, 17.01).

Há suporte muito limitado ao OpenWRT "Chaos Calmer" (15.05), mas requer alguns backports (do openwrt, luci e packages) disponíveis em simetnicbr/openwrt-openwrt, simetnicbr/openwrt-luci e simetnicbr/openwrt-packages.

# Sobre o SIMETBox

O SIMETBox é um sistema inicialmente desenvolvido para roteadores com OpenWRT para medir a qualidade de vários quesitos na internet. Vários testes são realizados até os PTTs do [IX.br](http://ix.br). Os testes realizados pela solução são: latência até os PTTs e gateway da rede, perda de pacotes, jitter, vazão, qualidade dos sites mais acessados no Brasil, localização dos servidores de conteúdo, validação da [BCP-38](http://bcp.nic.br), teste para [gerência de porta 25](http://www.antispam.br/admin/porta25/definicao/) e testes de P2P. Os resultados ficam disponíveis aos usuários através de interface WEB e ao provedor através de [portal](https://pas.nic.br) próprio para isto.

## Pacotes que compõem o projeto e o que medem

**Atenção: É recomendado que se selecione todos os pacotes ou pelo menos os pacotes 2, 3, 4, 7 e 8 com todos os seus componentes na configuração.**

1. simetbox-openwrt-availability-config (análise de disponibilidade e configuração remota com TR-069)  
1.1. Configuration  
1.1.1. TR-069 server address (endereço do servidor TR-069 usado)

2. simetbox-openwrt-base (medições básicas do SIMETBox)  
2.1. Configuration  
2.1.2. Standard measurements (jitter, latência, perda de pacotes e vazão)  
2.1.3. Port 25 management (gerência de porta 25)  
2.1.4. Content Providers (localização dos provedores de conteúdo/CDN)  
2.1.5. DNS measurements and ping to gateway (qualidade dos servidores de DNS e ping até o gateway da rede)  
2.1.6. Alexa top 10 Brazil (qualidade dos sites mais acessados do Brasil)  
2.1.7. Traffic amount registration (total de tráfego por interface)  
2.1.8. BCP 38 validation (validação da BCP-38)  

3. simetbox-openwrt-config (bibliotecas para leitura dos arquivos de configuração)
 
4. simetbox-openwrt-luci (aba da interface WEB para os resultados do SIMETBox)

5. simetbox-openwrt-ntpd (análise de escorregamento do NTP)

6. simetbox-openwrt-zabbix (análise de memória e processamento)

7. simetbox-openwrt-simet-ma (novo motor de medição SIMET -- obrigatório!)

8. simetbox-openwrt-core (configuração openwrt -- irá substituir o simetbox-openwrt-base no futuro)

9. simetbox-openwrt-simet-lmapd (componente do novo motor de medição)


## Instalação

O feed do SIMETBox se integra com os projeto [OpenWRT](http://openwrt.org).  Para que possa ser fechada uma distribuição com ele é necessário que se compile a imagem para o roteador desejado a partir do código fonte dos projetos.

Não é recomendado utilizar o "openwrt-18.06" e posteriores (inclusive openwrt "master") em equipamentos com menos de 64MiB de RAM: nestes casos, o lede-17.01 é mais estável.  Ainda assim, em equipamentos com apenas 32MiB de RAM, podem haver problemas durante "sysupgrade" via interface web e é necessário utilizar tr-069, ssh, ou tftp via bootloader para atualização.  Esta é uma limitação do firmware openwrt, e não das extensões simetbox.  Nesses casos, considerar remover os pacotes que ocupam memória o tempo inteiro (zabbix, tr-069...).

Tenhamos como exemplo o roteador TP-Link Archer C7 v2. Veja como  fechar uma distribuição (imagem) para este roteador usando Ubuntu. Os passos são desde a instalação de dependências até o fechamento da imagem, baseando-se no OpenWRT versão lede-17.01:


#### Atualiza e instala pré-requisitos
```bash
sudo apt-get update
sudo apt-get install --install-recommends build-essential ccache perl python
binutils util-linux patch diffutils flex findutils grep gawk intltool gettext
bzip2 xz-utils unzip libncurses5-dev zlib1g-dev libssl-dev git rsync wget curl
subversion time
```
#### Cria o diretório necessário, garate uma umask que não irá causar problemas
```bash
umask 022
mkdir openwrt
cd openwrt
```
#### Busca e configura o OpenWRT lede-17.01
```bash
git clone -b lede-17.01 https://github.com/openwrt/openwrt.git
cd openwrt
echo "src-git simetbox https://github.com/simetnicbr/simetbox-openwrt-feed.git" > feeds.conf
cat feeds.conf.default >> feeds.conf
```
#### Habilita os pacotes para serem configurados
```bash
./scripts/feeds update -a
./scripts/feeds install -a
```
#### Escolhe plataforma e pacotes a serem compilados
```bash
make menuconfig
```
* Escolher a opção **Target System** -\> **Atheros AR7xxx/AR9xxx**
* Voltar ao menu principal
* Escolher a opção **Target Profile** -\> **TP-LINK Archer C7 v2**
* Marcar a opção "Image configuration" com "\*" (usa-se a tecla de espaço para marcar uma opção). É importante que apareça "\*" e não a letra "M"
* Depois de marcada a opção "Image configuration" deve-se entrar nela pressionando a tecla \<enter\>
* No novo menu que surge, deve-se marcar com "\*" a opção "Version configuration options" e também entrar nela
* Pressionar a tecla enter na opção "Release version code" e escolher um número para a versão do sistema que será gerado. Esta será a versão do firmware que aparecerá caso esteja usando o protocolo TR-069 para gerência do roteador. Caso venha a fazer upgrade do firmware usando este protocolo, é o valor colocado aqui que indicará qual o firmware atual e qual será o novo. No exemplo, vamos usar a versão 100:

> **(100) Release version code**

(em versões anteriores do OpenWRT, não existia a opção "Release version code").

* Voltar para o menu principal e escolher a opção **Network** -\> **SIMETBox** e marcar com "*" (usando a tecla "y") as opções relevantes :

> \<\*\> simetbox-openwrt-availability-config  
> 	Configuration  ---\>  
> \-\*\- simetbox-openwrt-base........................................... SIMETBox  
> Configuration  ---\>  
> \-\*\- simetbox-openwrt-config.......................... SIMETBOX Config Library  
> \<\*\> simetbox-openwrt-luci................................ SIMETBox Luci Files  
> \<\*\> simetbox-openwrt-ntpd....................................... Ntpd Support  
> \<\*\> simetbox-openwrt-zabbix................................... Zabbix Support  
> ...

* Voltar para o menu principal e escolher a opção **Libraries** -\> **libcurl**. Trocar o SSL support para OpenSSL e habilitar o **Enable cryptographic authentication**

* Salvar as modificações feitas na configuração

#### compilar tudo
```bash
make -j8 # tenha paciência - esta parte demora vários minutos ao ser executada pela primeira vez
```
#### Os arquivos gerados (.bin) estarão no diretório bin/targets/ar71xx/generic/
> Lembre-se que os arquivos .bin com "factory" no nome são para trocar o firmware original do seu roteador, e o arquivos .bin com "sysupgrade" no nome são para atualizar algum firmware compatível com openwrt que já está instalado (por exemplo, versão antiga do simetbox).


## Regras de Firewall

Não são necessárias regras adicionais para que as medições sejam realizadas.  Se o pacote **simetbox-openwrt-availability-config** for instalado, as regras de firewall para acesso ao servidor ACS (TR-069) já ficam previamente configuradas.  
Caso haja interesse em configurar regras, como por exemplo endereços IPs que possam acessar a porta 80 (http) da interface WAN, deve-se seguir estes passos:

* Na interface WEB vá em Network \-\> Firewall \-\> Open ports on router  

> Name: Gerencia  
> Protocol: TCP  
> External port: 80  

* Aplique e salve a regra. Para filtrar o IP de origem (recomendado) vá no novo item que surgiu chamado "Gerencia" e clique em editar. No campo "Source address" escolha "Custom" e coloque o endereço IP de origem da conexão.

Este processo pode ser repetido para quantos filtros forem necessários serem colocados. Os nomes dos filtros devem ser diferentes.



## TR-069

O protocolo [TR-069](https://pt.wikipedia.org/wiki/TR-069) foi desenvolvido pelo Broadband Forum. Ele permite que se gerencie CPEs remotamente, incluindo questões relacionadas a update de firmware. O agente TR-069 usado pelo SIMETBox é o [Easy CWMP](http://easycwmp.org). Os servidores (ACS) testados para trabalhar com esta plataforma são: 

* [FreeACS](http://www.freeacs.com)
* [GenieACS](https://genieacs.com)
* [OpenACS](http://openacs.org)

O SIMETBox já deixa o sistema configurado para utilizar o servidor desejado.  Caso não haja necessidade de utilizar servidor TR-069 local, pode-se manter o endereço do servidor do NIC.br, que será usado futuramente para análise de tempo de downtime dos equipamentos. O usuário e senha utilizados por padrão para cada roteador é o seu endereço MAC, tanto para o nome de usuário quanto para a senha. O servidor do NIC.br está preparado para receber registros neste formato.

## Contribuições ao projeto

1. Crie um branch para a funcionalidade que foi desenvolvida: `git checkout -b <nova-funcionalidade>`
2. Envie sua alteração: `git commit -am '<descrição-da-funcionalidade>'`
3. Faça um push para o branch: `git push origin <nova-funcionalidade>`
4. Faça um pull request :D

## Arquivos instalados no OpenWRT/LEDE

Arquivo | Descrição
--------|----------
/etc/simet/tr069_server | Endereço do servidor TR-069 (ACS) utilizado
/usr/lib/simet/simet\_installed/simetbox\_network\_and\_config\_installed | Indica se foi instalado o pacote de gerência de disponibilide
/usr/bin/simet_client \*\* | Cliente para realização de teste de latência, jitter, perda de pacotes e vazão
/usr/bin/simet_ws \*\* | Cliente WEB (CLI) com suporte a https
/usr/bin/simet\_hash\_measure | Busca um identificador único para uma sessão de testes
/etc/init.d/simetbox_config | Faz configurações iniciais para os sistemas do SIMETBox
/usr/bin/get\_mac\_address.sh | Retorna o MAC address da LAN. Este é um identificador único por dispositivo
/usr/bin/get\_model.sh | Retorna o modelo do equipamento
/usr/bin/get\_lat\_long.sh | Retorna latitude e longitude do equipamento com precisão máxima de 150 metros
/usr/bin/get\_simet\_box\_version.sh | Retorna a versão do sistema ("Release version number" da compilação)
/etc/simet/simet1.conf | Arquivo de configuração do SIMETBox
/usr/lib/lua/simet/simet\_utils.lua | Biblioteca LUA com várias funções utilizadas pelo SIMETBox
/usr/bin/get_uci.sh | Retorna valor da chave UCI solitada
/usr/bin/set_uci.sh | Configura valor da chave UCI fornecida
/usr/bin/simet_geolocation.sh | Envia a geolocalização aproximada do equipamento (a melhor precisão é de 150 metros.
/usr/bin/run_simet.sh | Roda um conjunto de testes do SIMET (testes relacionados a resolução 574 da ANATEL)
/usr/bin/simetbox_register.sh | Registra o SIMETBox e seu HASH único para liberar consulta via WEB
/etc/uci-defaults/99-simet-cron | Configura crontab para os testes do SIMET
/usr/lib/lua/simet/crontab_writer.lua | Biblioteca LUA usada para gerar a crontab
/usr/lib/lua/simet/personal_data.lua | Biblioteca LUA usada para gravar os dados cadastrados pelo usuário (nome, velocidade contratada e outros)
/usr/lib/simet/simet\_installed/simetbox\_base\_installed | Indica que o pacote básico do SIMETBox foi instalado
/usr/bin/simet_porta25 \*\* | Realiza testes de gerência de porta 25
/usr/lib/simet/simet\_installed/simetbox\_port25\_installed | Indica que o pacote para testes de gerência de porta 25 foi instalado
/usr/bin/simet_bcp38 \*\* | Realiza testes de BCP-38
/usr/lib/simet/simet\_installed/simetbox\_bcp38\_installed | Indica que o pacote para testes de conformidade com BCP-38 foi instalado
/usr/bin/sendcontentprovider.sh | Envia localização dos servidores de conteúdo 
/usr/bin/simet_alexa \*\* | Realiza testes referentes a qualidade no acesso aos sites mais acessados no Brasil
/usr/lib/simet/simet\_installed/simetbox\_top10alexa\_installed | Indica que o pacote para testes de qualidade dos sites mais acessados no Brasil foi instalado
/usr/bin/simet\_send\_if\_traffic.sh | Envia o consumo de tráfego por interface 
/usr/lib/simet/simet\_installed/simetbox\_iftraffic\_installed | Indica que o pacote para envio do total de tráfego por interface foi instalado
/usr/bin/simet\_dns \*\* | Realiza testes de DNS
/usr/bin/simet\_dns\_ping\_traceroute.sh | Realiza testes de ping e traceroute até os servidores DNS raiz
/usr/bin/simet\_traceroute.sh | Realiza testes de traceroute
/usr/bin/simet\_ping.sh | Realiza testes de ping
/usr/lib/simet/simet\_installed/simetbox\_dns\_installed | Indica que o pacote para realização de testes de DNS foi instalado
/usr/lib/simet/simet\_installed/simetbox\_ping\_installed | Indica que o pacote para realização de testes de ping foi instalado
/usr/lib/libsimetconfig.so | Shared Object para leitura dos arquivos de configuração do SIMETBox
/etc/ntp.conf\_simetbox | Arquivo de configuração do servidor ntpd já com os servidores do ntp.br configurados
/usr/bin/simet\_ntpq \*\* | Envia o escorregamento de tempo obtido via NTP para os servidores do NIC.br
/usr/lib/simet/simet\_installed/simetbox\_ntpd\_installed | Indica que o pacote com suporte ao ntp foi instalado
/etc/zabbix\_agentd\_v2\_simetbox.conf | Configuração para o agente Zabbix 2.x (geralmente OpenWRT)
/etc/zabbix\_agentd\_v3\_simetbox.conf | Configuração para o agente Zabbix 3.x (geralmente LEDE)

\* Depreciado (removido em versões atuais do firmware).  Em processo de troca por um componente novo de uptime que escala melhor no lado servidor.
\*\* Link simbólico para /usr/bin/simet_tools.

## Como usar o sistema para fazer medições

A mais tradicional para realizar testes é através da configuração da frequência de testes na aba SIMET/Configurações na interface WEB do roteador. Porém, caso o usuário queira fazer um determinado teste pontual é possível. Para isto deve ser feito um ssh para o equipamento (é importante definir uma senha via interface WEB primeiro) usando o usuário root.  

Comando | Exemplos de Uso
--------|----------------
run_simet.sh | Roda automaticamente os testes de latência, jitter, perda de pacotes e vazão, tanto em IPv4 quanto em IPv6 no PTT de latência mais baixa detectado. **Este é o comando recomendado para este tipo de medição**
simet_client | Roda um conjunto de testes da resolução 574 da ANATEL de forma pontual. Exemplo de uso:<br />**simet\_client --help** # Exibe ajuda<br />**simet\_client -4** # faz testes usando IPv4<br />**simet\_client -6** # faz testes usando IPv6<br />**simet\_client -4 -s sp-ipv4.simet.nic.br** # faz testes IPv4 no PTT de São Paulo<br />**simet\_client -vvvvv -4 -s sp-ipv4.simet.nic.br** # faz testes IPv4 no PTT de São Paulo em modo debug<br />A nomenclatura para os servidores de testes usada é a que estão nos links em <http://ix.br/localidades/atuais><br />Exemplo: URL de Londrina é <http://ix.br/adesao/lda/>, então o servidor para testes IPv4 será **lda-ipv4.simet.nic.br** e o de IPv6 será **lda-ipv6.simet.nic.br**
/usr/bin/simet\_porta25 | Para testar gerência de porta 25:<br />**/usr/bin/simet\_porta25** # sem debug<br />**/usr/bin/simet_porta25 -vvvvv** # com debug
/usr/bin/simet\_bcp38 | Realiza testes de validação da BCP-38<br />**/usr/bin/simet\_bcp38** # sem debug <br />**/usr/bin/simet_bcp38 -vvvvv** # com debug
/usr/bin/simet\_alexa | Realiza testes do top 10 Brasil do Alexa<br />**/usr/bin/simet\_alexa** # sem debug<br />**/usr/bin/simet\_alexa -vvvvv** # com debug
/usr/bin/sendcontentprovider.sh | Realiza testes para saber a localização de provedores de conteúdo<br />**/usr/bin/sendcontentprovider.sh** # roda os testes
/usr/bin/simet\_dns | Realiza testes de DNS (respeito a TTL, latência, servidores usados)<br />**/usr/bin/simet\_dns** # sem debug<br />**/usr/bin/simet\_dns -vvvvv** # com debug
/usr/bin/simet\_dns\_ping\_traceroute.sh | Realiza testes de ping e traceroute até os servidores DNS raiz<br />**/usr/bin/simet\_dns\_ping\_traceroute.sh** # realiza os testes

## Histórico

2017-05-24 - Primeiro release público
2018-05-29 - Atualização para adequação ao LEDE-17.01 e OpenWRT-18.06
2018-06-12 - Revisado.

## TODO

* Adicionar testes para localização dos servidores do Netflix
* Adicionar testes para detectar MITM contra instituições financeiras (*requer parceria com a instituição financeira*)
* Integrar dados do servidor Zabbix usado pelo NIC.br na interface de visualização dos resultados
* Integrar dados do servidor TR-069 usado pelo NIC.br na interface de visualização dos resultados
* Apresentar resultados dos testes de DNS na interface
* Apresentar resultados dos testes de gerência de porta 25 na interface

## Créditos

NIC.br  
<medicoes@simet.nic.br>

## License

GNU Public Licence 2
