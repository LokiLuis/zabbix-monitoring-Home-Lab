#!/bin/bash

# --- IMPOSTAZIONI ---
BACKUP_DIR="/home/luis/backups" # Usa il tuo username al posto di 'luis'
CONTAINER_NAME="postgres-db"
DB_USER="zabbix"
RETENTION_DAYS=7

# --- NOMI FILE ---
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/zabbix_db_backup_$DATE.sql.gz"

# --- ESECUZIONE BACKUP ---
echo "Avvio backup del database Zabbix..."

# Esegue il dump del database dal container, lo comprime al volo e lo salva nel file
docker exec -t $CONTAINER_NAME pg_dumpall -c -U $DB_USER | gzip > $BACKUP_FILE

echo "Backup completato: $BACKUP_FILE"

# --- PULIZIA VECCHI BACKUP ---
echo "Pulizia dei backup più vecchi di $RETENTION_DAYS giorni..."
find $BACKUP_DIR -type f -mtime +$RETENTION_DAYS -name '*.gz' -delete
echo "Pulizia completata."