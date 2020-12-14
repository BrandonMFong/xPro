# Setup
Auto Tag works only if the branch contains the Branch Type configured.

To include auto tag, add the following to your job:
```
  Tag-Commit:
    needs: [TEST-Powershell, TEST-pwsh]
    runs-on: windows-latest # On windows VM

    steps:
    - uses: actions/checkout@v2

    - name: Retrieve all branches and tags
      shell: pwsh
      run: |
        git fetch --prune --unshallow --tags

    - name: Set new tag
      shell: pwsh
      run: |
        if(Test-Path .\.github\tagging)
        {
          git clone https://github.com/BrandonMFong/xPro.git

          [string]$repodir = $(pwd).path;
          [string]$SetTagPath = $repodir + "\xPro\Functions\DetermineTagType.ps1";

          $env:GIT_REDIRECT_STDERR = '2>&1';
          & $SetTagPath -Push:$true -PathToVersionConfig:$("$($repodir)\.github\tagging\Version.json") -PathToTag:$($repodir);
        }

```
##To configure the tagging to your needs, please do the following:

### Create the tagging folder with the following structure
- tagging
  - Version.json

### Version.json
```
{
    "BranchNameDelimiter":"-", // The delimiter to your branch name.  Some people use '/'
    
    // The versions that you use for your repo
    // The amount of Versions determines how your tag is
    // For this, the tag would be: <Major>.<Minor>.<Patch>.<Bug>
    "Versions":[
        {"Version":"Major"},
        {"Version":"Minor"},
        {"Version":"Patch"},
        {"Version":"Bug"}
    ],
    
    // For the auto tag to execute, the branch name needs to contain the type followed by the delimiter
    // For this case *bug-*
    // From the type, the tag will be what Version is is connected to 
    "Branches":[
        {"Branch":{"Type":"bug","Version":"Bug"}},
        {"Branch":{"Type":"tests","Version":"Bug"}},
        {"Branch":{"Type":"patch","Version":"Patch"}},
        {"Branch":{"Type":"feature","Version":"Minor"}},
        {"Branch":{"Type":"update","Version":"Minor"}},
        {"Branch":{"Type":"upgrade","Version":"Minor"}},
        {"Branch":{"Type":"release","Version":"Major"}}
    ]
}
```
