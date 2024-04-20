# Git

#### P01. playground
-
```
git clone git@github.com:d2jvkpn/playground.git
cd playground

git config user.name d2jvkpn
git config user.email d2jvkpn@noreply.local

git remote add origin git@MyHost.Domain:d2jvkpn/playground.git

# git add -A && git commit -m "init"
git commit -am "init"

git push
```

-
```bash
git init
git config user.name d2jvkpn
git config user.name d2jvkpn@noreply.local

git branch -m main
git remote add origin git@github.com:d2jvkpn/swagger-go.git

git add -A
git commit -m "init"
git push -u origin main
```

#### P02. microservices
```bash
mkdir microservices && cd microservices

git init
touch .gitignore

git remote add origin git@github.com:d2jvkpn/microservices.git
git pull git@github.com:d2jvkpn/microservices.git master
# git push --set-upstream origin master
git branch --set-upstream-to=origin/master master
git branch -M master

git config user.name d2jvkpn
git config user.email d2jvkpn@noreply.local

git remote set-url --add origin git@gitlab.com:d2jvkpn/microservices.git

git add -A
git commit -m "init"
git push --set-upstream origin master
git push
```
