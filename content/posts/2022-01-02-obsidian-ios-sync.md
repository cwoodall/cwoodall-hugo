---
title: "Using Git To Sync Obsidian Notes on iOS with a-shell (free)"
date: 2022-01-02T13:30:09-04:00
draft: false
mermaid: true
image: /img/posts/2022-01-02-obsidian-ios-sync.md/banner.png
---

Obsidian is a wonderful note-taking too, but until mid-2021 there was no official mobile application. I use git to host my Obsidian vaults, and github to store them and sometimes create websites from them using a GitHub Action, GitHub Pages and Neuron. This is how I host my [Generative Art Studio](https://cwoodall.com/generative-art-studio/) page. However, on iOS there is no native support for using git to sync your notes. You can use iCloud, or Obsidian Sync. I have no issues with paying for either of these services, but I wanted to be able to keep my current workflow, but extend it to mobile. 

I developed a free method using [**a-shell**](https://holzschu.github.io/a-Shell_iOS), which can be automated, after initial setup, using iOS Shortcuts. There are two other methods that are well documented on the [Obsidian forum](https://forum.obsidian.md):

- [WorkingCopy](https://forum.obsidian.md/t/mobile-setting-up-ios-git-based-syncing-with-mobile-app-using-working-copy/16499): WorkingCopy is a paid application, which runs
- [iSH](https://forum.obsidian.md/t/mobile-sync-with-git-on-ios-for-free-using-ish/20861/8):  iSH runs an alpine linux container, and this method works. However, it does not have shortcut access, so you would need to launch the application and run git manually.

This method uses [**a-shell**](https://holzschu.github.io/a-Shell_iOS), which uses webAssembly for many of it's executables, which allows it to be more flexible, this has support for python, lua, javascript, C and C++, and most importantly git, using lg2. The main benefit is it is free (iSH is also free), and it is natively scriptable using Shortcuts (which iSH is not).

So let's get started.

<!--more-->


### Install the software

1. Install [Obsidian from the AppStore](https://apps.apple.com/us/app/obsidian-connected-notes/id1557175442) and launch it.
2. Install [a-shell from the AppStore](https://apps.apple.com/us/app/a-shell/id1473805438). We will be using this and a few of it's built in shortcuts such as `pickFolder` and the `lg2` (which is based on [libgit2](https://github.com/libgit2/libgit2))

### Setup your ssh keys and git configuration:
1. Launch a-shell. 
2. Mount the Obsidian directory you will be doing your work within. This will be the Obsidian folder  : `pickFolder`
    <embed src="/img/posts/2022-01-02-obsidian-ios-sync.md/2022-01-02 18-03-48.mp4" autostart="false" height="300" width="100%"></emb>
3. Create an ssh key`ssh-keygen` (We assume that you use the default and have already used `pickFolder`).
4. Share the public key with your github or gitlab accounts you need to clone from.
5. Clone your obsidian vault:
    ```lg2 clone ssh://git@github.com:blah/blah.git folder-name```
    This will prompt you for which ssh key you want to use. We will fix that in the next step. You will be prompted to enter your ssh password, if there is none press return.
6. `cd folder-name`
7. Setup `user.identityFile` and user configurations. This will set the default identity file to use, as well as the name and email address to sign the commits with. These are setup per repository with lg2 as it does not seem to have `--global` configuration access.
    ``` sh
    lg2 config user.identityFile ~/Documents/.ssh/id_rsa.pub
    lg2 config user.name "Name"
    lg2 config user.email "email@email.com"
    ```
8. Open up Obsidian, you should see the vault in you list of vaults if you saved it into the correct location.

### Setup Shortcuts

Setup shortcuts for `pulling` (download changes only), and syncing (`pulling, committing, and then pushing`). Here are the two that I created
#### [Pull Only](https://www.icloud.com/shortcuts/f609283a61ff44b8af1057b78c025c8f)
    
```sh
pickFolder
lg2 pull
```
<img src="/img/posts/2022-01-02-obsidian-ios-sync.md/shortcut-pull.png" width="200px" />

#### [Sync](https://www.icloud.com/shortcuts/f609283a61ff44b8af1057b78c025c8f)

```sh
pickFolder
lg2 pull
lg2 add .
lg2 commit -m "update: {{date}}"
lg2 push
```


<img src="/img/posts/2022-01-02-obsidian-ios-sync.md/shortcut-sync.png" width="200px" />


So long as you keep a strict discipline of pulling before making changes, and pushing changes from your Linux, Mac and Windows Obsidian instances frequently, this setup is pretty stable. It is a little additional step to manually trigger the sync shortcuts, when compared to a solution like Obsidian Sync, or iCloud which are all passive. If you end up with merge conflicts you will need to manually resolve them using `lg2`. This can be tricky because it diverges from `git` sometimes, and I found the documentation sparse.

Here is an example of the shortcuts in action:

<embed src="/img/posts/2022-01-02-obsidian-ios-sync.md/2022-01-02 18-06-40.mp4" autostart="false" height="300" width="100%"></emb>
