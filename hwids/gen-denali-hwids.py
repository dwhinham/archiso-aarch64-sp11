#!/usr/bin/python3
# Generate the Surface Pro 11 (Denali) hwid JSONs for stubble/systemd-stub.
#
# DMI product name picks Wi-Fi vs 5G; the EDID panel ID picks LCD, else OLED.
# Only product-name CHIDs are used, so SKUs and other Surfaces don't matter.
import hashlib, json, re, sys, uuid
from pathlib import Path

# Set once the 5G dtbs exist. Until then they map to the non-5G dtbs, because
# a compatible with no matching dtb in the UKI means no devicetree at all.
HAVE_5G_DTBS = False

M, F = "Microsoft Corporation", "Surface"
WIFI = "Microsoft Surface Pro, 11th Edition"
FIVEG = "Microsoft Surface Pro with 5G, 11th Edition"
LCD_PANELS = ["LGD0779", "LGD077b"]

def chid(*fields):
    h = hashlib.sha1(uuid.UUID("70ffd812-4c7f-4c7d-0000-000000000000").bytes
                     + "&".join(fields).encode("utf-16-le")).digest()[:16]
    return str(uuid.UUID(bytes=h, version=5))

def dmi(prod):  # types 5, 8, 9 (baseboard product == product name)
    return [chid(M, F, prod), chid(M, prod, M, prod), chid(M, prod)]

def lcd(prod):  # ext0: + EDID panel ID, checked before any DMI CHID
    return [chid(M, F, prod, panel) for panel in LCD_PANELS]

fiveg = "-5g" if HAVE_5G_DTBS else ""
FILES = {
    "x1e80100-microsoft-denali-oled.json":    ("Surface", "oled", dmi(WIFI)),
    "x1e80100-microsoft-denali-oled-5g.json": ("Surface (5G)", "oled" + fiveg, dmi(FIVEG)),
    "x1p64100-microsoft-denali-lcd.json":     ("Surface (LCD)", "lcd", lcd(WIFI)),
    "x1p64100-microsoft-denali-lcd-5g.json":  ("Surface (LCD, 5G)", "lcd" + fiveg, lcd(FIVEG)),
}

def check():  # replay reports/*.txt (systemd-analyze chid) through stubble's match order
    order = ["ext2", "ext1", "ext0", "3", "6", "8", "10", "4", "5", "7", "9", "11"]
    def match(ids):
        return next((n for t in order if t in ids for n, (*_, h) in FILES.items() if ids[t] in h), None)
    ok = True
    for report in sorted((Path(__file__).parent / "reports").glob("*.txt")):
        text = report.read_text()
        ids = dict(re.findall(r"^\s*(\w+)\s+\S+\s+([0-9a-f-]{36})$", text, re.M))
        got = match(ids)
        hidden = match({t: c for t, c in ids.items() if not t.startswith("ext")})
        good = bool(got) and got.endswith(f"-denali-{re.search(r'expect=(\S+)', text)[1]}.json")
        ok &= good
        print(f"{'ok  ' if good else 'FAIL'} {report.name}: {got} (panel ID hidden: {hidden})")
    sys.exit(not ok)

if sys.argv[1:] == ["--check"]:
    check()
outdir = Path(sys.argv[1] if len(sys.argv) > 1 else Path(__file__).parent)
outdir.mkdir(parents=True, exist_ok=True)
for name, (desc, compat, hwids) in FILES.items():
    with open(outdir / name, "w") as f:
        json.dump({"type": "devicetree", "name": f"Microsoft Corporation {desc}",
                   "compatible": f"microsoft,denali-{compat}", "hwids": hwids}, f, indent=4)
        f.write("\n")
