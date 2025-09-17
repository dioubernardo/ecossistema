# Premissas

- ✓ Autocontido 
- ✓ Desenvolvimento/Homologação/Produção juntos (faltam algumas definições)
- ✓ Controle dos IPs (para o processo de transição mas pode ser descartado)
- ✓ Controle dos certificados SSL automático 
- ✓ Possibilidade de subir por blocos
- ✓ Suporte a Single Page Application
- ✓ HTTP3 (falta testar, mas está anuncionado)
- Autenticação centralizada
- Autoatualização

# TODO

- testar branchs diferentes nas apliações
- pensar onde está o build 
- pensar volumes vs imagens
    - https://docs.docker.com/reference/compose-file/build/#additional_contexts

# Para desenvolvimento incluir no hosts

```
192.168.3.220 dashboard.local
192.168.3.220 sistemas.local
192.168.3.220 psvo.local
192.168.3.220 ava.local
```

# Configurações

Usar como base o .env.exemplo
```
copy .env.exemplo .env
```

# Para rodar

Execução normal
```
docker compose up -d
```

Execução de profiles não daemon
```
docker compose --profile tests up
```

# Servidor de testes requisitos

- Ubuntu 24.04 server com instalação minima (minimized) + ssh
- Instalação extra Docker + ufw
- IP: 192.168.3.220 (para subir multiplos ecosistemas precisa de mais de um IP)

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

## Referências
- https://doc.traefik.io/traefik/getting-started/docker/

## Memórias
- Tive que mexer no DNS do docker porque não estava rodando npm install
