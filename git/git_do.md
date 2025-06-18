### Git Do
---

#### ch01. branches
1. dev: development phase, X.X.0;
- dev/alice
2. test: test phase: X.X.1;
3. main/prod: production, can't git push
- release: release phase: X.X.Y, Y >= 2;
- dev -> test -> main -> release(v1.0.0)
4. feaure/xx: feature branch
5. hotfix/xx: created from main/prod
6. refactor/xx: refactor branch
7. qa: Quality Assurance
8. sit: System Integration Testing
9. uat: User Acceptance Testing

#### ch02.
```bash
git diff -- ':!bin/*'
```

```bash
git branch test
git checkout test
git push --set-upstream origin test
```

#### ch03. submodules
```bash
git submodule add git@github.com:d2jvkpn/swagger-go.git swagger-go

cat .gitmodules
```

#### ch04. Creating a new repository
```bash
touch README.md
git init
git checkout -b dev
git add README.md
git commit -m "first commit"
git remote add origin git@github.com:d2jvkpn/playground.git
git push -u origin dev
```

#### ch05. Clone a repository
```bash
git clone git@github.com:d2jvkpn/playground.git
cd playground
touch README.md
git add README.md
git commit -m "add README"
git push -u origin dev
```

#### ch06. Pushing an existing repository
```bash
git remote add github git@github.com:d2jvkpn/playground.git
git push -u github dev
git push -u github test
git push -u github main
```

#### ch07. import a repository
```bash
git clone --bare https://git.example.com/your/playground.git playground.git
cd playground.git
git remote set-url origin git@github.com:d2jvkpn/playground.git
git push origin --tags
git push origin --all
```
