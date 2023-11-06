# Building and Deploying F7History

To build locally:

```ps1
.\Build.ps1
```

This will create the `./Output/F7History` folder containing the module, build the module, publish it to a local repository (`-Repository -local`), and import it into the current PowerShell session. To create the local repository, run this command:

```ps1
Register-PSRepository -Name local -SourceLocation "~/psrepo" -InstallationPolicy Trusted
```

To test:

```ps1
.\test.ps1
```

## Build & Test Locally with specific Terminal.Gui and ConsoleGuiTools versions

The `build.ps1` script will use the latest version of `Terminal.Gui` and `ConsoleGuiTools` from the PowerShell Gallery by default. To build and test with a specific of  `ConsoleGuiTools` publish it to the local repository first (you have to setup a local repository first):

```ps1
Publish-Module -Path .\ConsoleGuiTools -Repository local
```

If `Build.ps1` finds a local repository it will use it instead of the PowerShell Gallery.

## To Publish a new version to the PowerShell Gallery:

The module is published to the PowerShell Gallery using GitHub Actions. See the publish.yml GitHub Action for details.

1) Merge changes to the `main` branch, or push directly to `main`. The GitHub Action will build the module, but not publish it.

2) Add and push a new tag

```ps1
git tag v1.4.1 -a -m "Release v1.4.1"
git push --atomic origin main v1.4.1
```

 This will build, test, and publish to the PowerShell Gallery here: https://www.powershellgallery.com/packages/F7History

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="http://www.kindel.com"><img src="https://avatars.githubusercontent.com/u/585482?v=4?s=100" width="100px;" alt="Tig"/><br /><sub><b>Tig</b></sub></a><br /><a href="#maintenance-tig" title="Maintenance">🚧</a> <a href="#infra-tig" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="https://github.com/gui-cs/F7History/pulls?q=is%3Apr+reviewed-by%3Atig" title="Reviewed Pull Requests">👀</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
