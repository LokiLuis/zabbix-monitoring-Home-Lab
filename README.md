# Piattaforma di Monitoraggio e Gestione Servizi (Home Lab)

![Dashboard di Grafana](https://imgur.com/a/dashboard-di-grafana-LYZ156R)

---

## 🎯 Obiettivo del Progetto

Questo progetto consiste nella creazione di un'infrastruttura di monitoraggio end-to-end, progettata e implementata da zero per supervisionare servizi reali in un ambiente server. L'obiettivo era replicare uno stack tecnologico moderno e dimostrare competenze pratiche in amministrazione di sistemi Linux, virtualizzazione, containerizzazione, monitoraggio, automazione e troubleshooting.

---

## 🛠️ Architettura e Stack Tecnologico

L'infrastruttura è costruita su una macchina virtuale locale e interamente orchestrata tramite Docker Compose, garantendo portabilità e facilità di deploy.

*   **Virtualizzazione:** VMware Workstation Player
*   **Sistema Operativo Host:** Ubuntu Server 24.04 LTS
*   **Containerizzazione:** Docker & Docker Compose
*   **Monitoraggio:** Zabbix 7.0 LTS
*   **Database:** PostgreSQL (per Zabbix)
*   **Visualizzazione Dati:** Grafana
*   **Servizi Monitorati:**
    *   L'host Ubuntu stesso (simulando un server fisico/virtuale).
    *   Container interni allo stack (es. `zabbix-agent`).
    *   Un servizio di rete reale per l'ad-blocking a livello DNS: **Pi-hole**.

---

## ✨ Funzionalità Implementate

*   **Monitoraggio Centralizzato:** Supervisione delle metriche critiche (CPU, RAM, disco, rete) per host e container da un'unica interfaccia.
*   **Alerting Proattivo:** Configurazione di un sistema di notifiche automatiche su **Telegram** per avvisare in tempo reale in caso di guasti (es. host irraggiungibile) o superamento di soglie.
*   **Backup Automatizzati:** Creazione di uno **script Bash** per il dump del database PostgreSQL di Zabbix, schedulato per l'esecuzione giornaliera tramite un **cron job**, con una policy di rotazione per conservare gli ultimi 7 giorni di backup.
*   **Hardening di Base del Server:** Implementazione di un firewall **UFW** sull'host Ubuntu, configurato per permettere il traffico solo sulle porte strettamente necessarie (SSH, Zabbix, Grafana, Pi-hole).
*   **Dashboard Avanzate:** Integrazione di Zabbix con **Grafana** per la creazione di dashboard personalizzate, visivamente efficaci e interattive per l'analisi dei dati di performance.
*   **Monitoraggio Applicativo (End-to-End):** Creazione di "Web Scenarios" in Zabbix per simulare la navigazione utente e controllare lo stato funzionale dei servizi web (es. la pagina admin di Pi-hole), garantendo non solo l'uptime dell'infrastruttura ma anche la disponibilità del servizio.

---

## 🔧 Sfide di Troubleshooting e Soluzioni

Durante lo sviluppo di questo progetto, ho affrontato e risolto diverse problematiche tecniche complesse, che hanno consolidato le mie capacità di problem-solving:

1.  **Connettività di Rete in Ambiente Virtualizzato:** Inizialmente ho riscontrato problemi di accesso ai servizi a causa della modalità di rete `NAT` di VMware, aggravati dall'uso di una VPN e di un extender di rete. Ho diagnosticato il problema e l'ho risolto configurando il **Port Forwarding** in VMware, dimostrando comprensione dei diversi layer di networking.

2.  **Conflitto di Porte Applicative:** Il deploy di Pi-hole falliva a causa del servizio `systemd-resolved` di Ubuntu che occupava la porta DNS (53). Ho identificato il processo in conflitto con `lsof` e ho risolto il problema modificando la configurazione di `systemd-resolved` per liberare la porta.

3.  **Gestione degli IP Dinamici:** Ho osservato che gli IP dei container e della VM cambiavano dopo ogni riavvio, causando il fallimento del monitoraggio. Ho risolto il problema in modo robusto:
    *   Configurando un **IP statico** sull'host Ubuntu tramite `netplan`.
    *   Assegnando **IP statici** ai container critici (come `zabbix-server`) all'interno della configurazione di rete di Docker Compose.

4.  **Permessi dei Volumi Docker:** Il container di Grafana falliva l'avvio con un errore di `Permission denied`. Analizzando i log (`docker logs`), ho capito che si trattava di un problema di permessi a livello di file system Linux e l'ho risolto assegnando la proprietà del volume sull'host all'UID corretto usato dal container (`sudo chown`).

5.  **Comunicazione tra Host e Container:** L'agente Zabbix sull'host non accettava connessioni dal server Zabbix in container. Analizzando i log dell'agente in tempo reale (`tail -f`), ho diagnosticato un errore di "access permissions" e l'ho risolto aggiornando la direttiva `Server=` nel file `zabbix_agentd.conf` per includere gli indirizzi IP della rete interna di Docker.

---

### **Come Eseguire il Progetto**

1.  Clonare il repository.
2.  Assicurarsi di avere Docker e Docker Compose installati.
3.  Eseguire `docker compose up -d` dalla cartella principale.
4.  Le interfacce web saranno disponibili ai seguenti indirizzi (potrebbe essere necessario configurare il port forwarding se si usa NAT):
    *   **Zabbix:** `http://<IP_SERVER>:8080`
    *   **Grafana:** `http://<IP_SERVER>:3000`
    *   **Pi-hole:** `http://<IP_SERVER>:8081`
