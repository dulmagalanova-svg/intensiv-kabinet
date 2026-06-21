// Supabase client — публичные значения (URL + publishable key безопасны в браузере).
// Секретный ключ (sb_secret_...) сюда НИКОГДА не кладём — только в Netlify Function.
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const SUPABASE_URL = 'https://bqwbskmfdrjmsrpejxlj.supabase.co'
const SUPABASE_PUBLISHABLE_KEY = 'sb_publishable_vjONC50nmj5iSVYw6LHNqA_4KXphpZq'

export const supabase = createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY)
