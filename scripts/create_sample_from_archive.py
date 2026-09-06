import zipfile, pandas as pd

ARCHIVE = "archive.zip"
OUT = "data"

# This script reproduces the compact subset used in the portfolio.
# It selects the top 500 players by current/peak market value,
# then keeps the 12,000 most recent appearances and 2,000 most recent transfers
# involving those players.

zf = zipfile.ZipFile(ARCHIVE)
with zf.open("players.csv") as f:
    players = pd.read_csv(f)

players = (players.sort_values(["market_value_in_eur","highest_market_value_in_eur"], ascending=False)
                 .drop_duplicates("player_id")
                 .head(500))

ids = set(players["player_id"].astype(int))

with zf.open("appearances.csv") as f:
    appearances = pd.read_csv(f)

appearances = appearances[appearances["player_id"].isin(ids)]
appearances = appearances.sort_values("date", ascending=False).head(12000)

with zf.open("transfers.csv") as f:
    transfers = pd.read_csv(f)

transfers = transfers[transfers["player_id"].isin(ids)]
transfers = transfers.sort_values("transfer_date", ascending=False).head(2000)

players.to_csv(f"{OUT}/sample_players.csv", index=False)
appearances.to_csv(f"{OUT}/sample_appearances.csv", index=False)
transfers.to_csv(f"{OUT}/sample_transfers.csv", index=False)

print("Created compact real-data subset.")
