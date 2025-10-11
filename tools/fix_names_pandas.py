#!/usr/bin/env python3
"""
Fix the Player column in a TSV from 'Lastname, Firstname' -> 'Firstname Lastname'.
Uses pandas and takes the filename as an argument.
"""

import argparse
import sys
from pathlib import Path

import pandas as pd

def main():
    parser = argparse.ArgumentParser(description="Reformat Player names in TSV")
    parser.add_argument("filename", help="Path to the TSV file")
    parser.add_argument("--column", default="Player", help="Column name to transform (default: Player)")
    parser.add_argument("--backup", action="store_true", help="Save a backup copy with .bak extension")
    args = parser.parse_args()

    try:
        df = pd.read_csv(args.filename, sep="\t")
    except Exception as e:
        print(f"Error reading {args.filename}: {e}", file=sys.stderr)
        sys.exit(1)

    if args.column not in df.columns:
        print(f"Column '{args.column}' not found. Available columns: {', '.join(df.columns)}", file=sys.stderr)
        sys.exit(1)

    # Backup if requested
    if args.backup:
        backup_name = args.filename + ".bak"
        df.to_csv(backup_name, sep="\t", index=False)
        print(f"Backup written to {backup_name}")

    # Function to reformat names from 'Lastname, Firstname' to 'Firstname Lastname'
    def reformat_name(x):
        if x == "-":
            return ""
        if isinstance(x, str) and "," in x:
            parts = x.split(", ")
            if len(parts) == 2:
                return f"{parts[1]} {parts[0]}"
            else:
                return x
        return x

    # Apply transformation
    df[args.column] = df[args.column].apply(reformat_name)

    # Remove rows where the target column is empty or only whitespace
    non_empty_mask = df[args.column].notna() & df[args.column].astype(str).str.strip().ne("")
    df = df[non_empty_mask]

    # Determine output path with .csv extension
    output_path = Path(args.filename).with_suffix(".csv")

    # Write results to CSV
    df.to_csv(output_path, index=False)
    print(f"Updated {output_path}: reformatted {args.column} column.")

if __name__ == "__main__":
    main()
