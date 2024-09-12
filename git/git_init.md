# git init
---

#### C01. Creating a new repository on the command line
```
touch README.md
git init
git checkout -b dev
git add README.md
git commit -m "first commit"
git remote add origin git@github.com:d2jvkpn/playground.git
git push -u origin dev
```

#### C02. Pushing an existing repository from the command line
```
git remote add github git@github.com:d2jvkpn/playground.git
git push -u github dev
git push -u github test
git push -u github main
```
