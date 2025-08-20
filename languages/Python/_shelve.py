#!/usr/bin/env python3
import os, shelve


def shelve_dump(data: dict, filename: str):
    os.makedirs(os.path.dirname(filename), mode=511, exist_ok=True)

    with shelve.open(filename, 'c') as db:
        for k, v in data.items():
            db[key] = value

def shelve_load(filename: str) -> dict:
    with shelve.open(filename) as db:
        return { item[0]: item[1] for item in db.items() }

d1 = [1, 2, 3]
d2 = {'x': 10, 'y': 20}

db = {'d1': d1, 'd2': d2}
shelve_path = os.path.join("data", "shelve", "db.shelve")

shelve_dump(db, shelve_path)

db = shelve_load(shelve_path)
