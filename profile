-- profile | OYUNCU PROFİLİ (v1.0)  -> loadsystem deposuna "profile" adıyla yükle
-- =========================================================
-- Avatar, hesap bilgileri, yayın istatistikleri, sıralama, unvan, rozetler ve oturum bilgileri.
-- ctx: { lang, accent, bg, anim, nick, player, onBack }

local G = (type(getgenv) == "function" and getgenv()) or _G
local S = G.__LOADSYS or {}
G.__LOADSYS = S

local BASE = "https://raw.githubusercontent.com/scptr1155-gif/loadsystem/refs/heads/main/"

local function loadCore()
  if type(S.CORE) == "table" then return S.CORE end
  local ok, src = pcall(function() return game:HttpGet(BASE .. "hubcore?t=" .. tostring(os.time())) end)
  if not ok or type(src) ~= "string" or type(loadstring) ~= "function" then return nil end
  local fn = loadstring(src)
  if not fn then return nil end
  local okR, c = pcall(fn)
  if okR and type(c) == "table" then return c end
  return nil
end

local STR = {
  tr = {
    back = "← GERİ", title = "Profil", sub = "Hesabın ve yayın istatistiklerin",
    published = "Yayınlanan", runs = "Toplam çalıştırma", good = "Aldığın 👍", bad = "Aldığın 👎",
    rank = "Yazar sıralaması", best = "En sevilen script", badges = "ROZETLER",
    acc_age = "Hesap yaşı", session = "Oturum süresi", executor = "Executor", place = "Oyun (PlaceId)",
    last_pub = "Son yayın", daily = "Bugünkü yayın hakkı", d_free = "Var", d_used = "Kullanıldı",
    days = " gün", none = "—", unknown = "Bilinmiyor", loading = "...",
    r1 = "Çaylak", r2 = "Yazar", r3 = "Usta", r4 = "Efsane", userid = "ID",
    b_first = "İlk Script", b_five = "5 Script", b_pop = "Popüler", b_loved = "Sevilen", b_top = "Zirvede", b_today = "Bugün Yayında",
  },
  en = {
    back = "← BACK", title = "Profile", sub = "Your account and publishing stats",
    published = "Published", runs = "Total runs", good = "👍 received", bad = "👎 received",
    rank = "Author rank", best = "Best script", badges = "BADGES",
    acc_age = "Account age", session = "Session time", executor = "Executor", place = "Game (PlaceId)",
    last_pub = "Last publish", daily = "Today's publish", d_free = "Available", d_used = "Used",
    days = " days", none = "—", unknown = "Unknown", loading = "...",
    r1 = "Rookie", r2 = "Author", r3 = "Master", r4 = "Legend", userid = "ID",
    b_first = "First Script", b_five = "5 Scripts", b_pop = "Popular", b_loved = "Loved", b_top = "On Top", b_today = "Published Today",
  },
}

local M = {}

function M.open(ctx)
  ctx = ctx or {}
  local core = loadCore()
  if not core then
    print("[profile] hubcore yuklenemedi")
    if type(ctx.onBack) == "function" then ctx.onBack() end
    return
  end
  local lang = (ctx.lang == "en") and "en" or "tr"
  local function T(k) return STR[lang][k] or STR.tr[k] or k end
  local spawn, num = core.spawn, core.num
  local uid = core.userId()

  local u = core.ui(ctx, { name = "Profile", title = T("title"), sub = T("sub"), back = true, backText = T("back") })
  if not u then return end
  local C, FNT = u.C, u.FNT
  local PAD, IW = u.PAD, u.IW
  local AC = Enum.TextXAlignment.Center
  local win = u.window

  local lp
  core.safe(function() lp = game:GetService("Players").LocalPlayer end)
  local uname = (lp and lp.Name) or tostring(ctx.player or "Player")
  local dname = (lp and lp.DisplayName) or tostring(ctx.nick or uname)

  ----------------------------------------------------------
  -- Sol kart: avatar + kimlik
  ----------------------------------------------------------
  local LW = 250
  local left = u.new("Frame", {
    Size = UDim2.fromOffset(LW, 410), Position = UDim2.fromOffset(PAD, 84), BackgroundColor3 = C.card, BorderSizePixel = 0, ZIndex = 3,
  }, win)
  u.round(left, 16)
  u.stroke(left, C.line)

  local avatar = u.new("ImageLabel", {
    Size = UDim2.fromOffset(110, 110), Position = UDim2.fromOffset((LW - 110) / 2, 24), BackgroundColor3 = C.cardHi,
    BorderSizePixel = 0, Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(uid) .. "&w=150&h=150", ZIndex = 4,
  }, left)
  u.round(avatar, 55)
  u.stroke(avatar, u.accent)

  u.label(left, dname, 12, 148, LW - 24, 28, 20, FNT.bold, C.text, { TextXAlignment = AC, TextTruncate = Enum.TextTruncate.AtEnd })
  u.label(left, "@" .. uname, 12, 176, LW - 24, 18, 12, FNT.med, C.muted, { TextXAlignment = AC, TextTruncate = Enum.TextTruncate.AtEnd })
  u.label(left, T("userid") .. " " .. tostring(uid), 12, 196, LW - 24, 16, 11, FNT.reg, C.faint, { TextXAlignment = AC })

  local chip = u.new("Frame", {
    Size = UDim2.fromOffset(120, 30), Position = UDim2.fromOffset((LW - 120) / 2, 226), BackgroundColor3 = u.accent, BorderSizePixel = 0, ZIndex = 4,
  }, left)
  u.round(chip, 15)
  local chipT = u.label(chip, T("loading"), 0, 0, 120, 30, 12, FNT.bold, C.white, { TextXAlignment = AC })

  local dailyT = u.label(left, "", 16, 276, LW - 32, 40, 12, FNT.med, C.muted, { TextXAlignment = AC, TextWrapped = true })

  -- Alt bilgi satırları (sol kart içinde)
  local function infoRow(y, key, value)
    u.label(left, T(key), 16, y, 110, 22, 11, FNT.reg, C.faint)
    return u.label(left, value, 116, y, LW - 132, 22, 12, FNT.med, C.text, { TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd })
  end
  local ageDays = (lp and lp.AccountAge) or 0
  infoRow(322, "acc_age", tostring(math.floor(ageDays)) .. T("days"))
  local sessVal = infoRow(346, "session", "00:00")
  local exName = T("unknown")
  core.safe(function() if type(identifyexecutor) == "function" then exName = tostring((identifyexecutor())) end end)
  infoRow(370, "executor", exName)
  infoRow(394, "place", tostring(game.PlaceId))

  local sess = (type(S.SESSION) == "table" and tonumber(S.SESSION.time)) or os.time()
  spawn(function()
    while u.alive() do
      core.safe(function() sessVal.Text = core.fmtTime(os.time() - sess) end)
      core.sleep(1)
    end
  end)

  ----------------------------------------------------------
  -- Sağ taraf: istatistik kartları
  ----------------------------------------------------------
  local RX = PAD + LW + 16
  local RW = IW - LW - 16
  local CWD = math.floor((RW - 20) / 3)
  local vals = {}
  local function statCard(col, row, key, color)
    local f = u.new("Frame", {
      Size = UDim2.fromOffset(CWD, 76), Position = UDim2.fromOffset(RX + col * (CWD + 10), 84 + row * 86),
      BackgroundColor3 = C.card, BorderSizePixel = 0, ZIndex = 3,
    }, win)
    u.round(f, 14)
    u.stroke(f, C.line)
    local v = u.label(f, T("loading"), 12, 10, CWD - 24, 30, 22, FNT.bold, color or C.text, { TextTruncate = Enum.TextTruncate.AtEnd })
    u.label(f, T(key), 12, 44, CWD - 24, 20, 11, FNT.med, C.muted, { TextTruncate = Enum.TextTruncate.AtEnd })
    vals[key] = v
  end
  statCard(0, 0, "published")
  statCard(1, 0, "runs")
  statCard(2, 0, "rank", u.accent)
  statCard(0, 1, "good", C.ok)
  statCard(1, 1, "bad", C.danger)
  statCard(2, 1, "best")
  vals.best.TextSize = 15

  -- Rozetler
  u.label(win, T("badges"), RX, 266, RW, 16, 11, FNT.bold, C.faint)
  local BADGES = {
    { "b_first", function(st) return st.count >= 1 end },
    { "b_five",  function(st) return st.count >= 5 end },
    { "b_pop",   function(st) return st.uses >= 100 end },
    { "b_loved", function(st) return (st.good - st.bad) >= 10 end },
    { "b_top",   function(st) return st.rank == 1 end },
    { "b_today", function(st) return st.today end },
  }
  local BW = math.floor((RW - 20) / 3)
  local badgeObjs = {}
  for i, b in ipairs(BADGES) do
    local col, row = (i - 1) % 3, math.floor((i - 1) / 3)
    local f = u.new("Frame", {
      Size = UDim2.fromOffset(BW, 40), Position = UDim2.fromOffset(RX + col * (BW + 10), 290 + row * 50),
      BackgroundColor3 = C.card, BorderSizePixel = 0, ZIndex = 3,
    }, win)
    u.round(f, 12)
    u.stroke(f, C.line)
    local t = u.label(f, "🔒 " .. T(b[1]), 0, 0, BW, 40, 12, FNT.bold, C.faint, { TextXAlignment = AC })
    badgeObjs[i] = { frame = f, text = t }
  end

  -- Son yayın + günlük hak (rozetlerin altı)
  u.label(win, T("last_pub"), RX, 400, 140, 22, 11, FNT.reg, C.faint)
  local lastVal = u.label(win, T("none"), RX + 140, 400, RW - 140, 22, 12, FNT.med, C.text)
  u.label(win, T("daily"), RX, 428, 140, 22, 11, FNT.reg, C.faint)
  local dayVal = u.label(win, T("loading"), RX + 140, 428, RW - 140, 22, 12, FNT.med, C.text)

  ----------------------------------------------------------
  -- Veri
  ----------------------------------------------------------
  spawn(function()
    local idx = core.readIndex()
    if not u.alive() then return end
    local st = core.statsFor(uid, idx)
    local left_ = core.dailyLeft(uid, idx)
    st.today = left_ > 0

    vals.published.Text = tostring(st.count)
    vals.runs.Text = tostring(st.uses)
    vals.good.Text = tostring(st.good)
    vals.bad.Text = tostring(st.bad)
    vals.rank.Text = st.rank and ("#" .. st.rank .. " / " .. st.authors) or T("none")
    vals.best.Text = st.best and tostring(st.best.name or "?") or T("none")

    local title = st.uses >= 1000 and "r4" or st.uses >= 100 and "r3" or st.uses >= 10 and "r2" or "r1"
    chipT.Text = T(title)

    for i, b in ipairs(BADGES) do
      local got = b[2](st)
      local o = badgeObjs[i]
      o.text.Text = (got and "🏅 " or "🔒 ") .. T(b[1])
      o.text.TextColor3 = got and C.text or C.faint
      if got then u.tw(o.frame, { BackgroundColor3 = u.accent }, 0.3) end
    end

    lastVal.Text = st.last > 0 and os.date("!%d.%m.%Y %H:%M UTC", st.last) or T("none")
    dayVal.Text = st.today and T("d_used") or T("d_free")
    dayVal.TextColor3 = st.today and C.danger or C.ok
    dailyT.Text = T("daily") .. ": " .. (st.today and T("d_used") or T("d_free"))
  end)

  u.backBtn.MouseButton1Click:Connect(function()
    local back = ctx.onBack
    u.close()
    if type(back) == "function" then back() end
  end)
end

return M
