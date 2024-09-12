### Git Do
---

#### C01. branches
1. dev: development phase, X.X.0;
2. test: test phase: X.X.1;
3. main
4. release: release phase: X.X.Y, Y >= 2;
5. dev -> test -> main -> release(v1.0.0)

#### C02.
```bash
git diff -- ':!bin/*'
```

```bash
git branch test
git checkout test
git push --set-upstream origin test
```

#### C03. submodules
```
git submodule add git@github.com:d2jvkpn/swagger-go.git swagger-go

cat .gitmodules
```

#### C04. Creating a new repository on the command line
```
touch README.md
git init
git checkout -b dev
git add README.md
git commit -m "first commit"
git remote add origin git@github.com:d2jvkpn/playground.git
git push -u origin dev
```

#### C05. Pushing an existing repository from the command line
```
git remote add github git@github.com:d2jvkpn/playground.git
git push -u github dev
git push -u github test
git push -u github main
```
