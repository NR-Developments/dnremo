# NP Emote System - Setup Guide

## Step-by-Step Installation

### 1. Prerequisites Check

Before installing, ensure your FiveM server has these features:
- ✅ JavaScript support (most modern servers do)
- ✅ Lua 5.4+ (standard on FiveM)
- ✅ Database (for object storage in np-objects)

### 2. Installation

#### Option A: Direct Installation
```bash
# Copy the entire [np-emote] folder to your resources directory
cp -r [np-emote] /path/to/your/server/resources/
```

#### Option B: Git Clone
```bash
cd /path/to/your/server/resources
git clone https://github.com/NR-Developments/dnremo.git [np-emote]
```

### 3. Server Configuration

Add to your `server.cfg`:
```lua
# Place these in order (dependencies first)
ensure npx
ensure focusmanager
ensure isPed
ensure np-sync
ensure np-cleanup
ensure [np-emote]
```

### 4. Database Setup (Optional)

If you're using **np-objects**, create this table:
```sql
CREATE TABLE IF NOT EXISTS objects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    model VARCHAR(100),
    coordinates JSON,
    metaData JSON,
    randomId VARCHAR(10),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 5. Verification

After server restart, check:
- Console: `[NPX] Loaded!` message should appear
- Players: Type `/emote` command should work
- Server logs: No resource errors

## Startup Sequence

```
Server Start
    ↓
[npx] Atlas Library loads first
    ↓
[focusmanager] UI focus control loads
    ↓
[isPed] Ped detection loads
    ↓
[np-sync] Synchronization loads
    ↓
[np-cleanup] Cleanup system loads
    ↓
[np-emote] Main emote system starts
    ↓
✅ Ready for players!
```

## Common Issues & Fixes

### Issue: "Resource failed to start"

**Solution:**
```bash
# Check folder structure
ls -la /path/to/resources/[np-emote]/
# Should see: emotes/, npx/, np-sync/, np-ui/, etc.

# Check file permissions
chmod -R 755 /path/to/resources/[np-emote]/

# Restart server
# or in console: restart [np-emote]
```

### Issue: "Cannot find npx library"

**Solution:**
```lua
-- In server.cfg, npx MUST load first:
ensure npx         # ← First
ensure [np-emote]  # ← Second
```

### Issue: "Emote menu not appearing"

**Solution:**
1. Check UI files exist:
   ```bash
   ls -la [np-emote]/emotes/nui/dist/
   # Should see: index.html and other files
   ```

2. Check console for JS errors:
   ```
   Open browser console (F8 in-game)
   Check for network errors
   ```

3. Verify focusmanager running:
   ```
   /status focusmanager  # Should show "running"
   ```

### Issue: "SQL connection error" (if using np-objects)

**Solution:**
```javascript
// Edit np-objects/server/server.js
// Ensure SQL.execute() is using correct database connection
// Verify database credentials in your framework
```

### Issue: "Animations not syncing between players"

**Solution:**
```lua
-- Ensure np-sync is running
-- Check server.cfg: ensure np-sync is listed before [np-emote]

-- In console:
-- /restart np-sync
-- /restart [np-emote]
```

## Performance Optimization

### Client-Side
- Limit concurrent emote animations to 1-2 players
- Use animation cleanup: np-cleanup automatically removes abandoned objects
- Disable unused animation categories in `emotes/emotes.js`

### Server-Side
- Monitor SQL queries in `np-objects/server/server.js`
- Limit object database to last 10,000 entries
- Use indexed queries for better performance

## Testing

### Basic Test
```
1. Join server
2. Type: /emote stand
3. Should play standing animation
4. Type: /emote cancel (to stop)
5. ✅ Success!
```

### Advanced Test
```
1. Player A: /emote salute
2. Player B: Check if they see Player A saluting
3. Should be synchronized
4. ✅ Success!
```

### UI Test
```
1. Type: /emotes (open menu)
2. Browse emote categories
3. Select and play emote
4. Check animation plays correctly
5. ✅ Success!
```

## File Structure Reference

```
[np-emote]/
├── fxmanifest.lua              ← MAIN (new in v2.0)
├── README.md
├── SETUP_GUIDE.md              ← You are here
│
├── npx/                        ← Atlas Library (START FIRST)
│   ├── fxmanifest.lua
│   ├── client/lib.js
│   ├── server/lib.js
│   └── shared/
│
├── focusmanager/               ← UI Focus Manager
│   ├── fxmanifest.lua
│   └── main.lua
│
├── isPed/                      ← Ped Detection
│   ├── fxmanifest.lua
│   └── client.lua
│
├── np-sync/                    ← Animation Sync
│   ├── fxmanifest.lua
│   ├── client/
│   └── server/
│
├── np-cleanup/                 ← Object Cleanup
│   ├── fxmanifest.lua
│   ├── client.lua
│   └── server.lua
│
├── emotes/                     ← Main Emote System
│   ├── fxmanifest.lua
│   ├── emotes.js              ← Animation database
│   ├── animals.lua
│   └── nui/dist/              ← UI Menu
│
├── np-ui/                      ← UI Framework
│   ├── fxmanifest.lua
│   ├── client/
│   └── build/
│
├── np-objects/                 ← Object Management
│   ├── fxmanifest.lua
│   ├── client/client.js
│   └── server/server.js
│
└── interactions/               ← Interaction System
    ├── fxmanifest.lua
    └── build/
```

## Updating

To update to the latest version:
```bash
cd /path/to/resources/[np-emote]
git pull origin main
/refresh  # in server console
```

## Support

If you encounter issues:
1. Check this guide first
2. Review server.log for errors
3. Check console (F8) for client errors
4. Open an issue on GitHub with:
   - Error message
   - Server logs
   - Your server.cfg ensure list
   - Steps to reproduce

---

**Version:** 2.0.0  
**Last Updated:** 2024  
**Status:** ✅ Production Ready
