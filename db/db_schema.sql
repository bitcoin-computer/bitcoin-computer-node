CREATE TABLE IF NOT EXISTS
  "NonStandardTxos" (
    "id" VARCHAR(70) NOT NULL PRIMARY KEY,
    "rev" VARCHAR(70),
    "publicKeys" VARCHAR(66)[],
    "contractName" VARCHAR(70),
    "contractHash" VARCHAR(64)
);

CREATE UNIQUE INDEX "NonStandardTxosUniqueIndex"
ON "NonStandardTxos"("rev", "publicKeys");

CREATE TABLE IF NOT EXISTS
   "StandardUtxos" (
     "rev" VARCHAR(70) NOT NULL PRIMARY KEY,
     "address" VARCHAR(66) NOT NULL,
     "satoshis" BIGINT NOT NULL,
     "scriptPubKey" TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS
  "User" (
    "publicKey" VARCHAR(66) NOT NULL PRIMARY KEY,
    "clientTimestamp" BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS
  "OffChainStore" (
    "id" VARCHAR(64) NOT NULL PRIMARY KEY,
    "data" TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS
  "SyncProgress" (
   "oneRowId" bool PRIMARY KEY DEFAULT TRUE,
   "syncedHeight" INTEGER NOT NULL,
   "bitcoindSyncedHeight" INTEGER NOT NULL,
   "bitcoindSyncedProgress" DECIMAL(10,9) NOT NULL,
   CONSTRAINT "OneRowUni" CHECK ("oneRowId")
);
INSERT INTO "SyncProgress" ("syncedHeight", "bitcoindSyncedHeight", "bitcoindSyncedProgress") VALUES (-1, -1, 0);
