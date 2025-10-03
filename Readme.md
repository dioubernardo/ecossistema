# Premissas

- ✓ Autocontido 
- ✓ Desenvolvimento/Homologação/Produção juntos (faltam algumas definições)
- ✓ Controle dos IPs (para o processo de transição mas pode ser descartado)
- ✓ Controle dos certificados SSL automático 
- ✓ Possibilidade de subir por blocos
- ✓ Suporte a Single Page Application
- ✓ HTTP3 (falta testar, mas está anuncionado)
- Autoatualização
- Autenticação centralizada
- Logs

# TODO

- timezone
- Permissão dos arquivos no autodeploy
- testar branchs diferentes nas aplicações

- pensar volumes vs imagens
    - https://docs.docker.com/reference/compose-file/build/#additional_contexts

# Instalação do servidor

## Ambiente de homologação/produção

- Ubuntu 24.04 server com instalação minima (minimized) + ssh
- Instalação extra Docker + ufw
- IP: 192.168.3.220 (para subir multiplos ecosistemas precisa de mais de um IP)

## Ambiente de desenvolvimento

- Pode ser WSL 2 quando Windows, apenas ativar o permissionamento 

Incluir em /etc/wsl.conf
```
[automount]
options = "metadata"
```

## Instalar Docker

Seguindo manual
https://docs.docker.com/engine/install/ubuntu/

```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh

# não pode ser rootless
sudo groupadd docker
sudo usermod -aG docker $USER

sudo apt install ufw
sudo ufw allow from 192.168.3.0/24 to any proto tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 443/udp
sudo ufw enable

sudo reboot
```

## Configurações do ambiente

Após clonar o repositorio base, utilizar .env.exemplo e acertar criar a pasta dos certificados
```
cd ecosistema 
copy .env.exemplo .env
mkdir certs
chmod 600 certs
```

### Para desenvolvimento incluir no hosts

```
127.0.0.1 dashboard.localhost.furg.br
127.0.0.1 sistemas.localhost.furg.br
127.0.0.1 psvo.localhost.furg.br
127.0.0.1 ava.localhost.furg.br
127.0.0.1 sso.localhost.furg.br
127.0.0.1 ldap.localhost.furg.br
```

Após executar pela primeira vez será gerado um certificado (certs/rootCA.crt) que deve ser instalado no computador

- Linux: ```sudo cp certs/rootCA.crt /usr/local/share/ca-certificates/ && sudo update-ca-certificates```
- Mac: ```sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain certs/rootCA.crt```
- Windows: clicar duas vezes em certs/rootCA.crt → Instalar Certificado → Autoridades de Certificação Raiz Confiáveis

# Para rodar

Execução normal
```
docker compose up -d
```

Execução de baterias de teste ou outros scripts manuais
```
docker compose run --rm psvo-test
```

# Autodeploy

```
cd ecosistema 
chmod +x autodeploy.sh

sudo apt install cron
sudo systemctl enable cron
sudo systemctl start cron

echo "*/5 * * * * root $(pwd)/autodeploy.sh >> /var/log/autodeploy.log 2>&1" | sudo tee -a /etc/crontab
```
Houve uma tentativa via container que estava OK porem com problema no docker compose up, por rodar no contexto do container e não no host https://github.com/dioubernardo/ecossistema/commit/2e50ef64cb617c7977cbcc2192770f75ab1f66bc

## Memórias
- Tive que mexer no DNS do docker porque não estava rodando npm install
