#!/bin/sh

RF_PATH="/data/snomed-rf"
DB_PATH="/data/snomed.db"

echo "[Hermes] Waiting for $RF_PATH..."

while [ ! -d "$RF_PATH" ]; do
    echo "[Hermes] Still waiting for $RF_PATH...";
    sleep 5;
done

while [ -z "$(ls -A $RF_PATH)" ]; do
    echo "[Hermes] Still waiting for files in $RF_PATH...";
    sleep 5;
done

echo "[Hermes] Importing SNOMED RF2..."
java -jar hermes.jar --db $DB_PATH import $RF_PATH

echo "[Hermes] Indexing SNOMED CT..."
java -jar hermes.jar --db $DB_PATH index compact

echo "[Hermes] Indexing complete. Exiting..."
exit 0 # Ensure Hermes exits after tasks
