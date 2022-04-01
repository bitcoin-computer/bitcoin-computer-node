CREATE TABLE IF NOT EXISTS
  "NonStandardTxos" (
    "id" BIGSERIAL PRIMARY KEY,
    "publicKey" VARCHAR(66) NOT NULL,
    "rev" VARCHAR(76) NOT NULL,
    "spent" BOOLEAN NOT NULL,
    "contractName" VARCHAR(70),
    "contractHash" VARCHAR(64)
);

CREATE UNIQUE INDEX "NonStandardTxosUniqueIndex"
ON "NonStandardTxos"("rev", "publicKey");

CREATE TABLE IF NOT EXISTS
  "Transactions" (
    "id" BYTEA PRIMARY KEY NOT NULL,
    "tx" BYTEA NOT NULL
);

CREATE TABLE IF NOT EXISTS
  "IdToRev" (
    "id" VARCHAR(70) NOT NULL PRIMARY KEY,
    "rev" VARCHAR(70) NOT NULL
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
