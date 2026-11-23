import { createBrowserClient } from "@supabase/ssr";
import { SUPABASE_KEY, SUPABASE_URL } from "./env";

export function createBrowserDb() {
  return createBrowserClient(SUPABASE_URL, SUPABASE_KEY);
}
