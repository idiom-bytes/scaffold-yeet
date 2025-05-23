import { onchainTable } from "ponder";

export const greeting = onchainTable("greeting", (t) => ({
  id: t.text().primaryKey(),
  source: t.text().notNull(),
  text: t.text().notNull(),
  setterId: t.hex().notNull(),
  premium: t.boolean().notNull(),
  value: t.bigint().notNull(),
  timestamp: t.integer().notNull(),
}));
