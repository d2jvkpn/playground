### Gaussian Splatting
---

#### 1. Related links
- https://repo-sam.inria.fr/fungraph/3d-gaussian-splatting/
- https://github.com/graphdeco-inria/gaussian-splatting
- https://sibr.gitlabpages.inria.fr/?page=index.html&version=0.9.6

#### 3. SIBR viewers
```bash
wget 3dgs_viewers.zip https://repo-sam.inria.fr/fungraph/3d-gaussian-splatting/binaries/viewers.zip
mkdir -p 3dgs_viewers
unzip 3dgs_viewers.zip -d 3dgs_viewers
```

```powershell
3dgs_viewer\SIBR_gaussianViewer_app.exe -m output\XXXX\
```

#### 4. Ureal Engine
- Plugin ThreeDGaussians, https://akiya-research-institute.github.io/3dGaussiansPlugin-Manual/
- Compile UE plugins, https://dev.epicgames.com/community/learning/tutorials/qz93/unreal-engine-building-plugins
1. Create an empty C++ project with the Engine version you wish to use.
2. Bring the plugin(s) to that C++ project
- Create a "Plugins" folder in the C++ project's root folder.
- Copy the plugin(s) folder(s) you want to build into the newly created "Plugins" folder.
3. Manually delete the “Intermediate” and “Binaries” folders of the plugin(s).
4. Double-click on your .uproject file to relaunch the Editor. You should see a popup telling you
that some modules need to be rebuilt.   Click Accept.  This should rebuild your plugin(s).
5. Once done, copy the plugin from the compiled C++ project to the Engine's plugins folder, and
overwrite any conflicting files.
